/mob/living/intangible/pdai
	name = "PDAI"
	icon = 'icons/mob/ai.dmi'
	icon_state = "a-eye"
	density = 0
	layer = 101
	see_in_dark = SEE_DARK_HUMAN
	stat = STAT_ALIVE
	mob_flags = USR_DIALOG_UPDATES_RANGE

	can_lie = FALSE //can't lie down, you're inside a PDA
	can_bleed = FALSE
	metabolizes = FALSE
	blood_id = null
	canmove = 0

	var/obj/item/device/pda2/pda_parent = null // PDA parent
	var/obj/item/organ/brain/latejoin/brain = null // I think, therefore I am

	var/obj/machinery/lawrack/law_rack_connection = null // which rack we're getting our laws from

	var/mob/living/silicon/hologram/holocam = null
	var/deployed_to_hologram = FALSE

	New(pda_parent)
		src.pda_parent = pda_parent
		src.holocam = new /mob/living/silicon/hologram(src)

	keys_changed(keys, changed)
		if (changed & (KEY_EXAMINE|KEY_BOLT|KEY_OPEN|KEY_SHOCK))
			src.update_cursor()

		if (keys & changed & (KEY_FORWARD|KEY_BACKWARD|KEY_LEFT|KEY_RIGHT))
			src.hologram_view()

/mob/living/intangible/pdai/proc/hologram_view()
	if (isdead(src))
		return

	if (!src.holocam)
		return
	else if (src.mind)
		src.holocam.pdai = src
		src.holocam.pda_parent = src.pda_parent
		src.holocam.name = src.name
		src.holocam.real_name = src.real_name
		src.deployed_to_hologram = 1
		src.mind.transfer_to(src.holocam)

//Returns either the AI PDA or the holocam mob, depending on whther or not we are deployed
/mob/living/intangible/pdai/proc/get_message_mob()
	RETURN_TYPE(/mob)

	if (deployed_to_hologram)
		return src.holocam
	return src

/mob/living/intangible/pdai/show_message(msg, type, alt, alt_type, group = "", var/just_maptext, var/image/chat_maptext/assoc_maptext = null)
	..()
	if (deployed_to_hologram && src.holocam)
		src.holocam.show_message(msg, 1, 0, 0, group)
	return

/mob/living/intangible/pdai/show_text(var/message, var/color = "#000000", var/hearing_check = 1, var/sight_check = 1, var/allow_corruption = 0, var/group)
	..()
	if (deployed_to_hologram && src.holocam)
		src.holocam.show_text(message, color, hearing_check, sight_check, allow_corruption, group)
	return

//					//
//	Hologram stuff	//
//					//

/mob/living/silicon/hologram
	icon = 'icons/mob/robots.dmi'

	var/mob/living/intangible/pdai/ai = null // PDA mainframe

	New(ai)
		src.ai = ai
