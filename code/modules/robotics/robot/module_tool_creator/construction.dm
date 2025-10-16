/*
 * - cable coil
 * - glass sheet
 * - steel rod
 * - steel sheet
 * - steel tile
 */

/datum/robot/module_tool_creator/item_type/amount/cable_coil
	name = "cable coil"
	amount = 200
	item_type = /obj/item/cable_coil

/datum/robot/module_tool_creator/item_type/amount/cable_coil/setup(obj/item/cable_coil/I)
	..()
	if (!isnull(I))
		I.UpdateIcon()
	return I

/datum/robot/module_tool_creator/item_type/amount/cable_coil/reinforced
	name = "reinforced cable coil"
	amount = 300
	item_type = /obj/item/cable_coil/reinforced

/datum/robot/module_tool_creator/item_type/amount/glass_sheet
	name = "glass sheets"
	amount = 200
	item_type = /obj/item/sheet/glass

/datum/robot/module_tool_creator/item_type/amount/steel_rod
	name = "steel rods"
	amount = 200
	item_type = /obj/item/rods/steel

	copper
		name = "copper rods"
		item_type = /obj/item/rods/copper

/datum/robot/module_tool_creator/item_type/amount/steel_rod/setup(obj/item/rods/steel/I)
	..()
	if (!isnull(I))
		I.UpdateStackAppearance()
	return I

/datum/robot/module_tool_creator/item_type/amount/steel_sheet
	name = "steel sheets"
	amount = 200
	item_type = /obj/item/sheet/steel

/datum/robot/module_tool_creator/item_type/amount/copper_sheet
		name = "copper sheets"
		amount = 200
		item_type = /obj/item/sheet/copper

/datum/robot/module_tool_creator/item_type/amount/steel_tile
	name = "steel tiles"
	amount = 200
	item_type = /obj/item/tile/steel

/datum/robot/module_tool_creator/item_type/amount/copper_tile
	name = "copper tiles"
	amount = 200
	item_type = /obj/item/tile/copper