TYPEINFO(/mob/living/silicon/robot/clockwork)
	start_listen_languages = list(LANGUAGE_ENGLISH, LANGUAGE_HELLENIC)

/mob/living/silicon/robot/clockwork
	name = "Clockwork Robot"
	voice_name = "mechanical voice"
	icon = 'icons/mob/robots.dmi'
	voice_type = "cyborg"
	icon_state = "clockborg"
	sound_scream = 'sound/voice/screams/clockwork_scream.ogg'
	scream_instrument_type = /obj/item/instrument/roboscream/clockwork
	sound_flip1 = 'sound/machines/whistlealert.ogg'
	sound_flip2 = 'sound/machines/whistlebeep.ogg'
	health = 300
	emaggable = FALSE
	syndicate_possible = 0
	movement_delay_modifier = 2 - BASE_SPEED
	say_language = LANGUAGE_HELLENIC

	New()
		// Ideally this will spawn in a physical location at some point, but for now we create it for the first borg that needs it
		if(!ticker?.ai_law_rack_manager.first_registered_clockwork)
			var/obj/machinery/lawrack/hephaestus/rack = new /obj/machinery/lawrack/hephaestus()
			ticker?.ai_law_rack_manager.register_new_rack(rack)
		..()

	attackby(obj/item/W, mob/user, params, is_special, silent)
		if(istype(W, /obj/item/clothing/mask/monkey_translator))
			if (!src.wiresexposed)
				boutput(user, SPAN_ALERT("You need to unlock the cyborg and expose the wires first."))
				return
			var/obj/item/clothing/mask/monkey_translator/translator = W
			if(src.part_mask)
				boutput(user, SPAN_ALERT("[src] already has a translator installed."))
				return
			translator.equipped(src, SLOT_WEAR_MASK)
			src.part_mask = translator
			user.drop_item()
			W.set_loc(src)
			user.visible_message(user, SPAN_ALERT("[user] installs [translator] into [src]."))
			playsound(src, 'sound/impact_sounds/Generic_Stab_1.ogg', 40, TRUE)
			logTheThing(LOG_STATION, src, "[key_name(user)] installs [translator] into [key_name(src)].")
			return
		..()