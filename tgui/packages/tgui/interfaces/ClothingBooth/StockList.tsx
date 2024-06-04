import { Fragment } from 'inferno';
import { useBackend, useLocalState } from '../../backend';
import { Box, Button, Divider, Dropdown, Input, Section, Stack } from '../../components';
import { BoothGrouping } from './BoothGrouping';
import { SlotFilters } from './SlotFilters';
import { buildFieldComparator, numberComparator, stringComparator } from './utils/comparator';
import { pluralize } from '../common/stringUtils';
import type { ComparatorFn } from './utils/comparator';
import type { ClothingBoothData, ClothingBoothGroupingData } from './type';
import { ClothingBoothSlotKey, ClothingBoothSortType } from './type';
import { LocalStateKey } from './utils/enum';

const clothingBoothItemComparators: Record<ClothingBoothSortType, ComparatorFn<ClothingBoothGroupingData>> = {
  [ClothingBoothSortType.Name]: buildFieldComparator((itemGrouping) => itemGrouping.name, stringComparator),
  [ClothingBoothSortType.Price]: buildFieldComparator((itemGrouping) => itemGrouping.cost_min, numberComparator),
  [ClothingBoothSortType.Variants]: buildFieldComparator(
    (itemGrouping) => Object.values(itemGrouping.clothingbooth_items).length,
    numberComparator
  ),
};

const getClothingBoothGroupingSortComparator
  = (usedSortType: ClothingBoothSortType, usedSortDirection: boolean) =>
    (a: ClothingBoothGroupingData, b: ClothingBoothGroupingData) =>
      clothingBoothItemComparators[usedSortType](a, b) * (usedSortDirection ? 1 : -1);

export const StockList = (_props: unknown, context) => {
  const { act, data } = useBackend<ClothingBoothData>(context);
  const { catalogue, accountBalance, cash, selectedGroupingName } = data;
  const catalogueItems = Object.values(catalogue);

  const [hideUnaffordable] = useLocalState(context, LocalStateKey.HideUnaffordable, false);
  const [slotFilters] = useLocalState<Partial<Record<ClothingBoothSlotKey, boolean>>>(
    context,
    LocalStateKey.SlotFilters,
    {}
  );
  const [searchText, setSearchText] = useLocalState(context, LocalStateKey.SearchText, '');
  const [sortType, setSortType] = useLocalState(context, LocalStateKey.SortType, ClothingBoothSortType.Name);
  const [sortAscending, setSortAscending] = useLocalState(context, LocalStateKey.SortAscending, true);

  const [tagFilters] = useLocalState<Partial<Record<string, boolean>>>(context, LocalStateKey.TagFilters, {});
  const [tagModal, setTagModal] = useLocalState(context, LocalStateKey.TagModal, false);

  const handleSelectGrouping = (name: string) => act('select-grouping', { name });

  const affordableItemGroupings = hideUnaffordable
    ? catalogueItems.filter((catalogueGrouping) => cash + accountBalance >= catalogueGrouping.cost_min)
    : catalogueItems;
  const slotFilteredItemGroupings = Object.values(slotFilters).some((filter) => filter)
    ? affordableItemGroupings.filter((itemGrouping) => slotFilters[itemGrouping.slot])
    : affordableItemGroupings;
  const tagFiltersApplied = !!tagFilters && Object.values(tagFilters).includes(true);
  const tagFilteredItemGroupings = tagFiltersApplied
    ? slotFilteredItemGroupings.filter((itemGrouping) =>
      itemGrouping.grouping_tags.some((groupingTag) => !!tagFilters[groupingTag])
    )
    : slotFilteredItemGroupings;
  const searchTextLower = searchText.toLocaleLowerCase();
  const searchFilteredItemGroupings = searchText
    ? tagFilteredItemGroupings.filter((itemGrouping) => itemGrouping.name.toLocaleLowerCase().includes(searchTextLower))
    : tagFilteredItemGroupings;
  const sortComparator = getClothingBoothGroupingSortComparator(sortType, sortAscending);
  const sortedStockInformationList = searchFilteredItemGroupings.sort(sortComparator);

  return (
    <Stack fill>
      <Stack.Item>
        <SlotFilters />
      </Stack.Item>
      <Stack.Item grow>
        <Stack fill vertical>
          <Stack.Item>
            <Section>
              <Stack fluid align="center" justify="space-between">
                <Stack.Item grow>
                  <Input
                    fluid
                    onInput={(_e: unknown, value: string) => setSearchText(value)}
                    placeholder="Search by name..."
                  />
                </Stack.Item>
                <Stack.Item grow>
                  <Dropdown
                    noscroll
                    className="clothingbooth__dropdown"
                    displayText={`Sort: ${sortType}`}
                    onSelected={(value) => setSortType(value)}
                    options={[ClothingBoothSortType.Name, ClothingBoothSortType.Price, ClothingBoothSortType.Variants]}
                    selected={sortType}
                    width="100%"
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon={sortAscending ? 'arrow-down-short-wide' : 'arrow-down-wide-short'}
                    onClick={() => setSortAscending(!sortAscending)}
                    tooltip={`Sort Direction: ${sortAscending ? 'Ascending' : 'Descending'}`}
                  />
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section>
              <Stack fluid align="center" justify="space-between">
                <Stack.Item>
                  <Box as="span" style={{ opacity: '0.5' }}>
                    {sortedStockInformationList.length} {pluralize('grouping', sortedStockInformationList.length)}{' '}
                    available
                  </Box>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    fluid
                    align="center"
                    color={Object.values(tagFilters).some((tagFilter) => tagFilter === true) && 'good'}
                    onClick={() => setTagModal(!tagModal)}>
                    Filter by Tags{' '}
                    {!!Object.values(tagFilters).some((tagFilter) => tagFilter === true)
                      && `(${Object.values(tagFilters).filter((tagFilter) => tagFilter === true).length} selected)`}
                  </Button>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <StockListSection
              onSelectGrouping={handleSelectGrouping}
              groupings={sortedStockInformationList}
              selectedGroupingName={selectedGroupingName}
            />
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

interface StockListSectionProps {
  groupings: ClothingBoothGroupingData[];
  onSelectGrouping: (name: string) => void;
  selectedGroupingName: string | null;
}

const StockListSection = (props: StockListSectionProps) => {
  const { groupings, onSelectGrouping, selectedGroupingName } = props;
  return (
    <Section fill scrollable>
      {groupings.map((itemGrouping, itemGroupingIndex) => (
        <Fragment key={itemGrouping.name}>
          {itemGroupingIndex > 0 && <Divider />}
          <BoothGrouping
            {...itemGrouping}
            onSelectGrouping={() => onSelectGrouping(itemGrouping.name)}
            selectedGroupingName={selectedGroupingName}
          />
        </Fragment>
      ))}
    </Section>
  );
};
