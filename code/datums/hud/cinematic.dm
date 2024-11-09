/datum/hud/cinematic
	click_check = 0

	proc/play(name)
		create_screen("bg", "", 'icons/mob/hud_common.dmi', "cinematic_bg", "1, 1 to NORTH, EAST", 98)
		switch (name)
			if ("nuke")
				var/atom/movable/screen/hud/anim = create_screen("cinematic", "", 'icons/effects/station_explosion.dmi', "start_nuke", "1:6, 1:50", 99)
				playsound_global(clients, 'sound/misc/airraid_loop_short.ogg', vol=100)
				SPAWN(3.5 SECONDS)//45)
					anim.icon_state = "explode"
					sleep(1 SECOND)
					playsound_global(clients, 'sound/effects/kaboom.ogg', vol=100)
					sleep(8 SECONDS)
					anim.icon_state = "loss_nuke"
			if ("malf")
				var/atom/movable/screen/hud/anim = create_screen("cinematic", "", 'icons/effects/station_explosion.dmi', "start_malf", "1:6, 1:50", 99)
				SPAWN(3.5 SECONDS)//45)
					anim.icon_state = "explode"
					sleep(1 SECOND)
					playsound_global(clients, 'sound/effects/kaboom.ogg', vol=100)
					sleep(7 SECONDS)
					anim.icon_state = "loss_malf"
			if ("sadbuddy")
				create_screen("cinematic", "", 'icons/effects/160x160.dmi', "sadbuddy", "CENTER-2,CENTER-2", 99)
				playsound_global(clients, 'sound/misc/sad_server_death.ogg', vol=100)
