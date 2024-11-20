/obj/artifact/fabricator
	name = "artifact fabricator"
	associated_datum = /datum/artifact/fabricator

	attackby(obj/item/I, mob/user)
		// Handling for inserting material pieces
		if (istype(I, /obj/item/material_piece) && istype(src.artifact, /datum/artifact/fabricator))
			var/datum/artifact/fabricator/fab = src.artifact
			fab.internal_fabricator.Attackby(I, user)

/datum/artifact/fabricator
	associated_object = /obj/artifact/fabricator
	type_name = "Fabricator"
	type_size = ARTIFACT_SIZE_LARGE
	rarity_weight = 200
	validtypes = list("martian")
	validtriggers = list(/datum/artifact_trigger/force,/datum/artifact_trigger/electric,/datum/artifact_trigger/heat,
	/datum/artifact_trigger/carbon_touch,/datum/artifact_trigger/data)
	fault_blacklist = list(ITEM_ONLY_FAULTS)
	activated = 0
	activ_text = "rattles and opens up a compartment."
	deact_text = "closes its compartment."
	react_xray = list(20,95,95,11,"SEGMENTED")
	var/list/datum/manufacture/recipes = list()
	var/obj/machinery/manufacturer/internal_fabricator = new /obj/machinery/manufacturer/artifact()
	var/recharge_time = 60 SECONDS
	var/recharging = FALSE

	// New()
	// 	..()
	// 	src.recipes = concrete_typesof(/datum/manufacture) - concrete_typesof(/datum/manufacture/mechanics)
	// 	for (var/i in 1 to 10)
	// 		src.internal_fabricator.available += pick(src.recipes)

	effect_touch(var/obj/O, var/mob/living/user)
		if (..())
			return
		if (!user)
			return
		// var/turf/T = get_turf(O)
		// if (src.recharging)
		// 	boutput(user, SPAN_ALERT("The artifact makes an angry noise, but nothing else happens."))
		// 	playsound(O.loc, src.internal_fabricator.sound_grump, 50, 1)
		// 	return

		// if (src.recharge_time > 0)
		// 	src.internal_fabricator.status |= NOPOWER
		// T.visible_message("<b>[O]</b> whirrs up and starts working!")

		// var/datum/manufacture/item_bp = pick(src.recipes)
		// src.internal_fabricator.queue += item_bp
		// src.internal_fabricator.begin_work( new_production = TRUE )
		src.internal_fabricator.Attackhand(user)

		// SPAWN(src.recharge_time)
		// 	T.visible_message("<b>[O]</b> makes a gentle sound.")
		src.internal_fabricator.status &= ~NOPOWER
		// 	playsound(O.loc, src.internal_fabricator.sound_happy, 50, 1)
