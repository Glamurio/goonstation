/datum/hud/robopack
	var/atom/movable/screen/hud
		lhand
		rhand
		twohandl
		twohandr
		swaphands

	var/layout_style = "goon"
	var/icon/icon_hud = 'icons/mob/hud_human_new.dmi'
	var/static/list/layouts = \
							list("goon" = list( \
										"lhand" = ui_lhand,\
										"rhand" = ui_rhand,\
										"twohand" = ui_twohand,\
										"twohandl" = ui_lhand,\
										"twohandr" = ui_rhand,\
										"swaphands" = 0,\
										), \
							"tg" = list( \
										"lhand" = tg_ui_lhand,\
										"rhand" = tg_ui_rhand,\
										"twohand" = tg_ui_twohand,\
										"twohandl" = tg_ui_lhand,\
										"twohandr" = tg_ui_rhand,\
										"swaphands" = tg_ui_swaphands,\
										))

	New()
		..()
		lhand_back = create_screen("lhand_back", "left back hand", src.icon_hud, "handl0", layouts[layout_style]["lhand"], HUD_LAYER+1)
		rhand_back = create_screen("rhand_back", "right back hand", src.icon_hud, "handr0", layouts[layout_style]["rhand"], HUD_LAYER+1)
		lhand_back.invisibility = INVIS_ALWAYS
		rhand_back.invisibility = INVIS_ALWAYS
