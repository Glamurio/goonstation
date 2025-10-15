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

	New()
		// Ideally this will spawn in a physical location at some point, but for now we create it for the first borg that needs it
		if(!ticker?.ai_law_rack_manager.first_registered_clockwork)
			var/obj/machinery/lawrack/hephaestus/rack = new /obj/machinery/lawrack/hephaestus()
			ticker?.ai_law_rack_manager.register_new_rack(rack)
		..()
