/obj/item/tool/omnitool/artifact
	name = "artifact tool"
	icon = 'icons/obj/artifacts/artifactsitem.dmi'
	modes = list()
	mode = null
	switch_icons = FALSE
	artifact = 1
	var/datum/artifact/associated_datum = /datum/artifact/tool/
	var/switch_sound // Sound it makes when switching modes

	change_mode(var/new_mode, var/mob/holder)
		..()
		var/turf/T = get_turf(holder)
		playsound(T, src.switch_sound, 50, TRUE, -1)

	get_desc()
		return

	// Copying this over from /obj/item/artifact does not seem to be the most optimal way to do this
	New(var/loc, var/forceartiorigin)
		..()
		var/datum/artifact/AS = new src.associated_datum(src)
		if (forceartiorigin)
			AS.validtypes = list("[forceartiorigin]")
		src.artifact = AS

		SPAWN(0)
			src.ArtifactSetup()

	disposing()
		artifact_controls.artifacts -= src
		..()

	examine()
		. = list("You have no idea what this thing is!")
		if (!src.ArtifactSanityCheck())
			return
		var/datum/artifact/A = src.artifact
		if (istext(A.examine_hint) && (usr && (usr.traitHolder?.hasTrait("training_scientist")) || isobserver(usr)))
			if (A.activated)
				. += SPAN_ARTHINT("Seems like it's set to some sort of [src.mode_to_text(src.mode)] configuration.")
			else
				. += SPAN_ARTHINT(A.examine_hint)

	UpdateName()
		src.name = "[name_prefix(null, 1)][src.real_name][name_suffix(null, 1)]"

	attackby(obj/item/W, mob/user)
		if (src.Artifact_attackby(W,user))
			..()

	emp_act()
		src.Artifact_emp_act()

	reagent_act(reagent_id,volume)
		if (..())
			return
		src.Artifact_reagent_act(reagent_id, volume)
		return

	hitby(atom/movable/M, datum/thrown_thing/thr)
		if (isitem(M))
			var/obj/item/ITM = M
			for (var/obj/machinery/networked/test_apparatus/impact_pad/I in src.loc.contents)
				I.impactpad_senseforce(src, ITM)
		..()

/datum/artifact/tool
	associated_object = /obj/item/tool/omnitool/artifact
	type_name = "Tool"
	type_size = ARTIFACT_SIZE_MEDIUM
	rarity_weight = 400
	validtypes = list("ancient","precursor","clockwork")
	react_xray = list(16,78,90,9,"COMPLEX")
	validtriggers = list(/datum/artifact_trigger/force, /datum/artifact_trigger/electric, /datum/artifact_trigger/heat, /datum/artifact_trigger/cold,
	/datum/artifact_trigger/radiation, /datum/artifact_trigger/carbon_touch, /datum/artifact_trigger/silicon_touch)
	examine_hint = "It seems to have a handle you're supposed to hold it by."
	var/list/possible_modes = list(OMNI_MODE_PRYING, OMNI_MODE_SCREWING, OMNI_MODE_PULSING, OMNI_MODE_WRENCHING,
	OMNI_MODE_SNIPPING, OMNI_MODE_CUTTING, OMNI_MODE_WELDING, OMNI_MODE_DECON, OMNI_MODE_SOLDERING)

	post_setup()
		..()
		var/obj/item/tool/omnitool/artifact/O = src.holder
		switch(src.artitype.name)
			if ("ancient")
				O.switch_sound = pick('sound/effects/electric_shock_short.ogg', 'sound/machines/weapons-reloading.ogg', 'sound/machines/scan.ogg', 'sound/items/pickup_gun.ogg')
			if ("precursor")
				O.switch_sound  = pick('sound/effects/singsuck.ogg', 'sound/effects/screech_tone.ogg', 'sound/effects/sparks4.ogg', 'sound/effects/sparks5.ogg')
			if ("clockwork")
				O.switch_sound  = pick('sound/misc/automaton_scratch.ogg', 'sound/items/penclick.ogg', 'sound/items/can_open.ogg', 'sound/items/plate_tap.ogg', 'sound/effects/spring.ogg')
			else
				O.switch_sound  = 'sound/machines/click.ogg'

	effect_activate(var/obj/O)
		..()
		var/obj/item/tool/omnitool/artifact/I = O
		var/list/modes_to_pick = possible_modes.Copy()

		// Loop through the original list of modes
		for (var/mode in modes_to_pick)
			if(prob(50))
				I.modes.Add(mode)
				modes_to_pick -= mode

		// Guarantee at least one mode
		if(length(I.modes) == 0)
			I.modes.Add(pick(modes_to_pick))

		I.mode = I.modes[1]
		if (OMNI_MODE_WELDING in I.modes)
			I.create_reagents(rand(10, 100))
			I.reagents.add_reagent("fuel", rand(1, I.reagents.total_volume))
		I.setup_context_actions()
