import { Box } from '../../components';
import type { ClothingBoothGroupingTagsData } from './type';

export const GroupingTag = (props: ClothingBoothGroupingTagsData) => {
  const { name, colour } = props;

  return (
    <Box
      italic
      className={"clothingbooth__groupingtag"}
      color={colour ? colour : "white"}
      style={{ border: `0.0835rem solid ${colour ? colour : "white"}` }}
      px={0.5}>
      {name}
    </Box>
  );
};
