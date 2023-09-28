/obj/item/robopack
	name = "RoboPack"
	desc = "A bulky, wearable device made of metal, allows the user to control up to two additional robotic arms."
	icon_state = "backpack"										// ToDo
	inhand_image_icon = 'icons/mob/inhand/hand_storage.dmi'		// ToDo
	item_state = "backpack"										// ToDo
	flags = FPRINT | TABLEPASS | NOSPLASH
	c_flags = ONBACK
	w_class = W_CLASS_BULKY
	wear_image_icon = 'icons/mob/clothing/back.dmi'				// ToDo
	var/list/hands = list()
	var/obj/item/parts/robot_parts/arm/r_arm = null
	var/obj/item/parts/robot_parts/arm/l_arm = null
	duration_remove = 3 SECONDS
	duration_put = 3 SECONDS

	// equipped(/mob/living/carbon/human/user, slot)
	// 	..()
	// 	if(user)
	// 		user.hud.add_object(I, HUD_LAYER, (user.hand ? user.hud.layouts[user.hud.layout_style]["lhand"] : user.hud.layouts[user.hud.layout_style]["rhand"]))

	// 		user.icon_state = "handr"
	// 		user.icon_state = "handl"

/obj/item/robopack_frame
	name = "RoboPack Frame"
	desc = "An empty frame used in the construction of a RoboPack."
	icon = 'icons/mob/hivebot.dmi' 	// ToDo
	icon_state = "shell-frame"		// ToDo
	item_state = "shell-frame"		// ToDo
	w_class = W_CLASS_SMALL
	var/build_step = 0
	var/obj/item/storage/backpack/bag = null
	var/obj/item/parts/robot_parts/arm/r_arm = null
	var/obj/item/parts/robot_parts/arm/l_arm = null

/obj/item/robopack_frame/attackby(obj/item/W, mob/user)
	if (istype(W, /obj/item/storage/backpack))
		if (!src.bag)
			src.build_step++
			boutput(user, "You add \the [W] to [src]!")
			playsound(src, 'sound/impact_sounds/Generic_Stab_1.ogg', 40, 1)
			src.bag = W
			user.u_equip(W)
			W.set_loc(src)
			return
	if (istype(W, /obj/item/parts/robot_parts/arm))
		if (!src.r_arm)
			src.build_step++
			boutput(user, "You add \the [W] to [src]!")
			playsound(src, 'sound/impact_sounds/Generic_Stab_1.ogg', 40, 1)
			src.r_arm = W
			user.u_equip(W)
			W.set_loc(src)
			return
		else
			boutput(user, "\The [src] already has [src.r_arm] in that slot!")
		if (!src.l_arm)
			src.build_step++
			boutput(user, "You add \the [W] to [src]!")
			playsound(src, 'sound/impact_sounds/Generic_Stab_1.ogg', 40, 1)
			src.l_arm = W
			user.u_equip(W)
			W.set_loc(src)
			return
		else
			boutput(user, "\The [src] already has [src.l_arm] in that slot!")
		return
	if(iswrenchingtool(W))
		if (src.r_arm && src.l_arm && src.bag)
			src.build_step++
			boutput(user, "You wrench the arms into place.")
			playsound(src, 'sound/items/Ratchet.ogg', 40, 1)
			var/obj/item/robopack/R = new /obj/item/robopack(get_turf(src))
			R.l_arm = src.l_arm
			R.r_arm = src.r_arm
			src.l_arm.set_loc(R)
			src.r_arm.set_loc(R)
			src.l_arm = null
			src.r_arm = null
			src.bag = null
			qdel(src)
			return
		else if (!src.bag)
			boutput(user, "The [src] is still missing a bag!")
			return
		else if (src.r_arm && !src.l_arm || !src.r_arm && src.l_arm)
			boutput(user, "The [src] is still missing an arm!")
			return
		else
			boutput(user, "There's nothing to wrench!")
			return
