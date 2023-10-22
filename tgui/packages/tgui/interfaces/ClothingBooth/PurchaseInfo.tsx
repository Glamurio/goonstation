import { useBackend } from '../../backend';
import { Button, Stack } from '../../components';
import type { ClothingBoothData } from './type';

export const PurchaseInfo = (_, context) => {
  const { act, data } = useBackend<ClothingBoothData>(context);
  const { itemLookup, money, selectedItemId } = data;
  const selectedItem = selectedItemId ? itemLookup[selectedItemId] : undefined;
  return (
    <Stack bold vertical textAlign="center">
      {selectedItem ? (
        <>
          <Stack.Item>Selected: {selectedItem.name}</Stack.Item>
          {/* {!!data.selectedItem && (
            <Stack.Item>
              {Object.values(data.selectedItem).map((variant) => (
                <VariantSwatch key={variant.name} {...variant} />
              ))}
            </Stack.Item>
          )} */}
          <Stack.Item>
            <Button color="green" disabled={selectedItem.cost > money} onClick={() => act('purchase')}>
              {`${selectedItem.cost > money ? 'Insufficent Cash' : 'Purchase'} (${selectedItem.cost}⪽)`}
            </Button>
          </Stack.Item>
        </>
      ) : (
        <Stack.Item>Please select an item.</Stack.Item>
      )}
    </Stack>
  );
};
