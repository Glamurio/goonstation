
// Fabricator Defines

/obj/machinery/manufacturer/general
	name = "general manufacturer"
	supplemental_desc = "This one produces tools and other hardware, as well as general-purpose items like replacement lights."
	free_resources = list(/obj/item/material_piece/steel = 5,
		/obj/item/material_piece/copper = 5,
		/obj/item/material_piece/glass = 5)
	available = list(/datum/manufacture/screwdriver,
		/datum/manufacture/wirecutters,
		/datum/manufacture/wrench,
		/datum/manufacture/crowbar,
		/datum/manufacture/extinguisher,
		/datum/manufacture/welder,
		/datum/manufacture/flashlight,
		/datum/manufacture/weldingmask,
		/datum/manufacture/metal,
		/datum/manufacture/metalR,
		/datum/manufacture/rods2,
		/datum/manufacture/glass,
		/datum/manufacture/glassR,
		/datum/manufacture/atmos_can,
		/datum/manufacture/gastank,
		/datum/manufacture/miniplasmatank,
		/datum/manufacture/minioxygentank,
		/datum/manufacture/player_module,
		/datum/manufacture/cable,
		/datum/manufacture/powercell,
		/datum/manufacture/powercellE,
		/datum/manufacture/powercellC,
		/datum/manufacture/powercellH,
		/datum/manufacture/light_bulb,
		/datum/manufacture/red_bulb,
		/datum/manufacture/yellow_bulb,
		/datum/manufacture/green_bulb,
		/datum/manufacture/cyan_bulb,
		/datum/manufacture/blue_bulb,
		/datum/manufacture/purple_bulb,
		/datum/manufacture/blacklight_bulb,
		/datum/manufacture/light_tube,
		/datum/manufacture/red_tube,
		/datum/manufacture/yellow_tube,
		/datum/manufacture/green_tube,
		/datum/manufacture/cyan_tube,
		/datum/manufacture/blue_tube,
		/datum/manufacture/purple_tube,
		/datum/manufacture/blacklight_tube,
		/datum/manufacture/table_folding,
		/datum/manufacture/jumpsuit,
		/datum/manufacture/shoes,
#ifdef UNDERWATER_MAP
		/datum/manufacture/flippers,
#endif
		/datum/manufacture/breathmask,
#ifdef MAP_OVERRIDE_NADIR
		/datum/manufacture/nanoloom,
		/datum/manufacture/nanoloom_cart,
#endif
		/datum/manufacture/fluidcanister,
		/datum/manufacture/meteorshieldgen,
		/datum/manufacture/shieldgen,
		/datum/manufacture/doorshieldgen,
		/datum/manufacture/patch,
		/datum/manufacture/saxophone,
		/datum/manufacture/trumpet)
	hidden = list(/datum/manufacture/RCDammo,
		/datum/manufacture/RCDammomedium,
		/datum/manufacture/RCDammolarge,
		/datum/manufacture/bottle,
		/datum/manufacture/vuvuzela,
		/datum/manufacture/harmonica,
		/datum/manufacture/bikehorn,
		/datum/manufacture/bullet_22,
		/datum/manufacture/bullet_smoke,
		/datum/manufacture/stapler,
		/datum/manufacture/bagpipe,
		/datum/manufacture/fiddle,
		/datum/manufacture/whistle)

/obj/machinery/manufacturer/general/grody
	name = "grody manufacturer"
	desc = "It's covered in more gunk than a truck stop ashtray. Is this thing even safe?"
	supplemental_desc = "This one has seen better days. There are bits and pieces of the internal mechanisms poking out the side."
	free_resources = list()
	malfunction = TRUE
	wires = 15 & ~(1 << 3) // This cuts the malfunction wire, so the fab malfunctions immediately

/obj/machinery/manufacturer/robotics
	name = "robotics fabricator"
	supplemental_desc = "This one produces robot parts, cybernetic organs, and other robotics-related equipment."
	icon_state = "fab-robotics"
	icon_base = "robotics"
	free_resources = list(/obj/item/material_piece/steel = 5,
		/obj/item/material_piece/copper = 5,
		/obj/item/material_piece/glass = 5)
	available = list(/datum/manufacture/robo_frame,
		/datum/manufacture/full_cyborg_standard,
		/datum/manufacture/full_cyborg_light,
		/datum/manufacture/robo_head,
		/datum/manufacture/robo_chest,
		/datum/manufacture/robo_arm_r,
		/datum/manufacture/robo_arm_l,
		/datum/manufacture/robo_leg_r,
		/datum/manufacture/robo_leg_l,
		/datum/manufacture/robo_head_light,
		/datum/manufacture/robo_chest_light,
		/datum/manufacture/robo_arm_r_light,
		/datum/manufacture/robo_arm_l_light,
		/datum/manufacture/robo_leg_r_light,
		/datum/manufacture/robo_leg_l_light,
		/datum/manufacture/robo_leg_treads,
		/datum/manufacture/robo_head_screen,
		/datum/manufacture/robo_module,
		/datum/manufacture/cyberheart,
		/datum/manufacture/cybereye,
		/datum/manufacture/cybereye_meson,
		/datum/manufacture/cybereye_spectro,
		/datum/manufacture/cybereye_prodoc,
		/datum/manufacture/cybereye_camera,
		/datum/manufacture/shell_frame,
		/datum/manufacture/ai_interface,
		/datum/manufacture/latejoin_brain,
		/datum/manufacture/shell_cell,
		/datum/manufacture/cable,
		/datum/manufacture/powercell,
		/datum/manufacture/powercellE,
		/datum/manufacture/powercellC,
		/datum/manufacture/powercellH,
		/datum/manufacture/crowbar,
		/datum/manufacture/wrench,
		/datum/manufacture/screwdriver,
		/datum/manufacture/scalpel,
		/datum/manufacture/circular_saw,
		/datum/manufacture/surgical_scissors,
		/datum/manufacture/hemostat,
		/datum/manufacture/suture,
		/datum/manufacture/stapler,
		/datum/manufacture/surgical_spoon,
		/datum/manufacture/implanter,
		/datum/manufacture/secbot,
		/datum/manufacture/medbot,
		/datum/manufacture/firebot,
		/datum/manufacture/floorbot,
		/datum/manufacture/cleanbot,
		/datum/manufacture/digbot,
		/datum/manufacture/visor,
		/datum/manufacture/deafhs,
		/datum/manufacture/robup_jetpack,
		/datum/manufacture/robup_healthgoggles,
		/datum/manufacture/robup_sechudgoggles,
		/datum/manufacture/robup_spectro,
		/datum/manufacture/robup_recharge,
		/datum/manufacture/robup_repairpack,
		/datum/manufacture/robup_speed,
		/datum/manufacture/robup_mag,
		/datum/manufacture/robup_meson,
		/datum/manufacture/robup_aware,
		/datum/manufacture/robup_physshield,
		/datum/manufacture/robup_fireshield,
		/datum/manufacture/robup_teleport,
		/datum/manufacture/robup_visualizer,
		/datum/manufacture/robup_efficiency,
		/datum/manufacture/robup_repair,
		/datum/manufacture/sbradio,
		/datum/manufacture/implant_health,
		/datum/manufacture/implant_antirot,
		/datum/manufacture/cyberappendix,
		/datum/manufacture/cyberpancreas,
		/datum/manufacture/cyberspleen,
		/datum/manufacture/cyberintestines,
		/datum/manufacture/cyberstomach,
		/datum/manufacture/cyberkidney,
		/datum/manufacture/cyberliver,
		/datum/manufacture/cyberlung_left,
		/datum/manufacture/cyberlung_right,
		/datum/manufacture/rods2,
		/datum/manufacture/metal,
		/datum/manufacture/glass,
		/datum/manufacture/asimov_laws,
		/datum/manufacture/borg_linker)

	hidden = list(/datum/manufacture/flash,
		/datum/manufacture/cybereye_thermal,
		/datum/manufacture/cybereye_laser,
		/datum/manufacture/cyberbutt,
		/datum/manufacture/robup_expand,
		/datum/manufacture/cardboard_ai,
		/datum/manufacture/corporate_laws,
		/datum/manufacture/robocop_laws)

/obj/machinery/manufacturer/medical
	name = "medical fabricator"
	supplemental_desc = "This one produces medical equipment and sterile clothing."
	icon_state = "fab-med"
	icon_base = "med"
	free_resources = list(/obj/item/material_piece/steel = 2,
		/obj/item/material_piece/copper = 2,
		/obj/item/material_piece/glass = 2,
		/obj/item/material_piece/cloth/cottonfabric = 2)
	available = list(
		/datum/manufacture/scalpel,
		/datum/manufacture/circular_saw,
		/datum/manufacture/surgical_scissors,
		/datum/manufacture/hemostat,
		/datum/manufacture/suture,
		/datum/manufacture/stapler,
		/datum/manufacture/surgical_spoon,
		/datum/manufacture/prodocs,
		/datum/manufacture/glasses,
		/datum/manufacture/visor,
		/datum/manufacture/deafhs,
		/datum/manufacture/hypospray,
		/datum/manufacture/patch,
		/datum/manufacture/mender,
		/datum/manufacture/penlight,
		/datum/manufacture/stethoscope,
		/datum/manufacture/latex_gloves,
		/datum/manufacture/surgical_mask,
		/datum/manufacture/surgical_shield,
		/datum/manufacture/scrubs_white,
		/datum/manufacture/scrubs_teal,
		/datum/manufacture/scrubs_maroon,
		/datum/manufacture/scrubs_blue,
		/datum/manufacture/scrubs_purple,
		/datum/manufacture/scrubs_orange,
		/datum/manufacture/scrubs_pink,
		/datum/manufacture/patient_gown,
		/datum/manufacture/eyepatch,
		/datum/manufacture/blindfold,
		/datum/manufacture/muzzle,
		/datum/manufacture/stress_ball,
		/datum/manufacture/body_bag,
		/datum/manufacture/implanter,
		/datum/manufacture/implant_health,
		/datum/manufacture/implant_antirot,
		/datum/manufacture/floppydisk,
		/datum/manufacture/crowbar,
		/datum/manufacture/extinguisher,
		/datum/manufacture/cyberappendix,
		/datum/manufacture/cyberpancreas,
		/datum/manufacture/cyberspleen,
		/datum/manufacture/cyberintestines,
		/datum/manufacture/cyberstomach,
		/datum/manufacture/cyberkidney,
		/datum/manufacture/cyberliver,
		/datum/manufacture/cyberlung_left,
		/datum/manufacture/cyberlung_right,
		/datum/manufacture/empty_kit,
		/datum/manufacture/rods2,
		/datum/manufacture/metal,
		/datum/manufacture/glass
	)

	hidden = list(/datum/manufacture/cyberheart,
	/datum/manufacture/cybereye)

/obj/machinery/manufacturer/science
	name = "science fabricator"
	supplemental_desc = "This one produces science equipment for experiments as well as expeditions."
	icon_state = "fab-sci"
	icon_base = "sci"
	free_resources = list(/obj/item/material_piece/steel = 2,
		/obj/item/material_piece/copper = 2,
		/obj/item/material_piece/glass = 2,
		/obj/item/material_piece/cloth/cottonfabric = 2,
		/obj/item/material_piece/cobryl = 2)
	available = list(
		/datum/manufacture/flashlight,
		/datum/manufacture/gps,
		/datum/manufacture/crowbar,
		/datum/manufacture/extinguisher,
		/datum/manufacture/welder,
		/datum/manufacture/patch,
		/datum/manufacture/atmos_can,
		/datum/manufacture/gastank,
		/datum/manufacture/artifactforms,
		/datum/manufacture/fluidcanister,
		/datum/manufacture/chembarrel,
		/datum/manufacture/chembarrel/yellow,
		/datum/manufacture/chembarrel/red,
		/datum/manufacture/condenser,
		/datum/manufacture/fractionalcondenser,
		/datum/manufacture/dropper_funnel,
		/datum/manufacture/beaker_lid_box,
		/datum/manufacture/bunsen_burner,
		/datum/manufacture/spectrogoggles,
		/datum/manufacture/atmos_goggles,
		/datum/manufacture/reagentscanner,
		/datum/manufacture/dropper,
		/datum/manufacture/mechdropper,
		/datum/manufacture/patient_gown,
		/datum/manufacture/blindfold,
		/datum/manufacture/muzzle,
		/datum/manufacture/audiotape,
		/datum/manufacture/audiolog,
		/datum/manufacture/rods2,
		/datum/manufacture/metal,
		/datum/manufacture/glass)

	hidden = list(/datum/manufacture/scalpel,
		/datum/manufacture/circular_saw,
		/datum/manufacture/surgical_scissors,
		/datum/manufacture/hemostat,
		/datum/manufacture/suture,
		/datum/manufacture/stapler,
		/datum/manufacture/surgical_spoon
	)

/obj/machinery/manufacturer/mining
	name = "mining fabricator"
	supplemental_desc = "This one produces mining equipment like concussive charges and powered tools."
	icon_state = "fab-mining"
	icon_base = "mining"
	free_resources = list(/obj/item/material_piece/steel = 2,
		/obj/item/material_piece/copper = 2,
		/obj/item/material_piece/glass = 2)
	available = list(/datum/manufacture/pick,
		/datum/manufacture/powerpick,
		/datum/manufacture/blastchargeslite,
		/datum/manufacture/blastcharges,
		/datum/manufacture/powerhammer,
		/datum/manufacture/drill,
		/datum/manufacture/conc_gloves,
		/datum/manufacture/digbot,
		/datum/manufacture/jumpsuit,
		/datum/manufacture/shoes,
		/datum/manufacture/breathmask,
		/datum/manufacture/engspacesuit,
		/datum/manufacture/lightengspacesuit,
#ifdef UNDERWATER_MAP
		/datum/manufacture/engdivesuit,
		/datum/manufacture/flippers,
#endif
		/datum/manufacture/industrialarmor,
		/datum/manufacture/industrialboots,
		/datum/manufacture/powercell,
		/datum/manufacture/powercellE,
		/datum/manufacture/powercellC,
		/datum/manufacture/powercellH,
		/datum/manufacture/ore_scoop,
		/datum/manufacture/oresatchel,
		/datum/manufacture/oresatchelL,
		/datum/manufacture/microjetpack,
		/datum/manufacture/jetpack,
#ifdef UNDERWATER_MAP
		/datum/manufacture/jetpackmkII,
#endif
		/datum/manufacture/geoscanner,
		/datum/manufacture/geigercounter,
		/datum/manufacture/eyes_meson,
		/datum/manufacture/flashlight,
		/datum/manufacture/ore_accumulator,
		/datum/manufacture/rods2,
		/datum/manufacture/metal,
#ifndef UNDERWATER_MAP
		/datum/manufacture/mining_magnet
#endif
		)

/obj/machinery/manufacturer/hangar
	name = "ship component fabricator"
	supplemental_desc = "This one produces modules for space pods or minisubs."
	icon_state = "fab-hangar"
	icon_base = "hangar"
	free_resources = list(/obj/item/material_piece/steel = 2,
		/obj/item/material_piece/copper = 2,
		/obj/item/material_piece/glass = 2)
	available = list(
#ifdef UNDERWATER_MAP
		/datum/manufacture/sub/preassembeled_parts,
#else
		/datum/manufacture/putt/preassembeled_parts,
		/datum/manufacture/pod/preassembeled_parts,
#endif
		/datum/manufacture/pod/armor_light,
		/datum/manufacture/pod/armor_heavy,
		/datum/manufacture/pod/armor_industrial,
		/datum/manufacture/cargohold,
		/datum/manufacture/storagehold,
		/datum/manufacture/orescoop,
		/datum/manufacture/conclave,
		/datum/manufacture/communications/mining,
		/datum/manufacture/pod/weapon/bad_mining,
		/datum/manufacture/pod/weapon/mining,
		/datum/manufacture/pod/weapon/mining/drill,
		/datum/manufacture/pod/weapon/ltlaser,
		/datum/manufacture/engine,
		/datum/manufacture/engine2,
		/datum/manufacture/engine3,
		/datum/manufacture/pod/lock,
		/datum/manufacture/beaconkit,
		/datum/manufacture/podgps
	)

/obj/machinery/manufacturer/uniform // add more stuff to this as needed, but it should be for regular uniforms the HoP might hand out, not tons of gimmicks. -cogwerks
	name = "uniform manufacturer"
	supplemental_desc = "This one can create a wide variety of one-size-fits-all jumpsuits, as well as backpacks and radio headsets."
	icon_state = "fab-jumpsuit"
	icon_base = "jumpsuit"
	free_resources = list(/obj/item/material_piece/cloth/cottonfabric = 5,
		/obj/item/material_piece/steel = 5,
		/obj/item/material_piece/copper = 5)
	accept_blueprints = FALSE
	available = list(/datum/manufacture/shoes,	//hey if you update these please remember to add it to /hop_and_uniform's list too
		/datum/manufacture/shoes_brown,
		/datum/manufacture/shoes_white,
		/datum/manufacture/flippers,
		/datum/manufacture/civilian_headset,
		/datum/manufacture/jumpsuit_assistant,
		/datum/manufacture/jumpsuit_pink,
		/datum/manufacture/jumpsuit_red,
		/datum/manufacture/jumpsuit_orange,
		/datum/manufacture/jumpsuit_yellow,
		/datum/manufacture/jumpsuit_green,
		/datum/manufacture/jumpsuit_blue,
		/datum/manufacture/jumpsuit_purple,
		/datum/manufacture/jumpsuit_black,
		/datum/manufacture/jumpsuit,
		/datum/manufacture/jumpsuit_white,
		/datum/manufacture/jumpsuit_brown,
		/datum/manufacture/pride_lgbt,
		/datum/manufacture/pride_ace,
		/datum/manufacture/pride_aro,
		/datum/manufacture/pride_bi,
		/datum/manufacture/pride_inter,
		/datum/manufacture/pride_lesb,
		/datum/manufacture/pride_gay,
		/datum/manufacture/pride_nb,
		/datum/manufacture/pride_pan,
		/datum/manufacture/pride_poly,
		/datum/manufacture/pride_trans,
		/datum/manufacture/suit_black,
		/datum/manufacture/dress_black,
		/datum/manufacture/hat_black,
		/datum/manufacture/hat_white,
		/datum/manufacture/hat_pink,
		/datum/manufacture/hat_red,
		/datum/manufacture/hat_yellow,
		/datum/manufacture/hat_orange,
		/datum/manufacture/hat_green,
		/datum/manufacture/hat_blue,
		/datum/manufacture/hat_purple,
		/datum/manufacture/hat_tophat,
		/datum/manufacture/backpack,
		/datum/manufacture/backpack_red,
		/datum/manufacture/backpack_green,
		/datum/manufacture/backpack_blue,
		/datum/manufacture/satchel,
		/datum/manufacture/satchel_red,
		/datum/manufacture/satchel_green,
		/datum/manufacture/satchel_blue,
		/datum/manufacture/handkerchief)

	hidden = list(/datum/manufacture/breathmask,
		/datum/manufacture/patch,
		/datum/manufacture/towel,
		/datum/manufacture/tricolor,
		/datum/manufacture/hat_ltophat)

/// cogwerks - a gas extractor for the engine

/obj/machinery/manufacturer/gas
	name = "gas extractor"
	supplemental_desc = "This one can create gas canisters, either empty or filled with gases extracted from certain minerals."
	icon_state = "fab-atmos"
	icon_base = "atmos"
	accept_blueprints = FALSE
	available = list(
		/datum/manufacture/atmos_can,
		/datum/manufacture/air_can/large,
		/datum/manufacture/o2_can,
		/datum/manufacture/co2_can,
		/datum/manufacture/n2_can,
		/datum/manufacture/plasma_can,
		/datum/manufacture/red_o2_grenade)

// a blank manufacturer for mechanics

/obj/machinery/manufacturer/mechanic
	name = "reverse-engineering fabricator"
	desc = "A specialized manufacturing unit designed to create new things (or copies of existing things) from blueprints."
	icon_state = "fab-hangar"
	icon_base = "hangar"
	free_resources = list(/obj/item/material_piece/steel = 2,
		/obj/item/material_piece/copper = 2,
		/obj/item/material_piece/glass = 2)

/obj/machinery/manufacturer/personnel
	name = "personnel equipment manufacturer"
	supplemental_desc = "This one can produce blank ID cards and access implants."
	icon_state = "fab-access"
	icon_base = "access"
	free_resources = list(/obj/item/material_piece/steel = 2,
		/obj/item/material_piece/copper = 2,
		/obj/item/material_piece/glass = 2)
	available = list(/datum/manufacture/id_card, /datum/manufacture/implant_access,	/datum/manufacture/implanter)
	hidden = list(/datum/manufacture/id_card_gold, /datum/manufacture/implant_access_infinite)

//combine personnel + uniform manufactuer here. this is 'cause destiny doesn't have enough room! arrg!
//and i hate this, i do, but you're gonna have to update this list whenever you update /personnel or /uniform
/obj/machinery/manufacturer/hop_and_uniform
	name = "personnel manufacturer"
	supplemental_desc = "This one is an multi-purpose model, and is able to produce uniforms, headsets, and identification equipment."
	icon_state = "fab-access"
	icon_base = "access"
	free_resources = list(/obj/item/material_piece/steel = 5,
		/obj/item/material_piece/copper = 5,
		/obj/item/material_piece/glass = 5,
		/obj/item/material_piece/cloth/cottonfabric = 5)
	accept_blueprints = FALSE
	available = list(/datum/manufacture/id_card,
		/datum/manufacture/implant_access,
		/datum/manufacture/implanter,
		/datum/manufacture/shoes,
		/datum/manufacture/shoes_brown,
		/datum/manufacture/shoes_white,
		/datum/manufacture/flippers,
		/datum/manufacture/civilian_headset,
		/datum/manufacture/jumpsuit_assistant,
		/datum/manufacture/jumpsuit,
		/datum/manufacture/jumpsuit_white,
		/datum/manufacture/jumpsuit_pink,
		/datum/manufacture/jumpsuit_red,
		/datum/manufacture/jumpsuit_orange,
		/datum/manufacture/jumpsuit_yellow,
		/datum/manufacture/jumpsuit_green,
		/datum/manufacture/jumpsuit_blue,
		/datum/manufacture/jumpsuit_purple,
		/datum/manufacture/jumpsuit_black,
		/datum/manufacture/jumpsuit_brown,
		/datum/manufacture/pride_lgbt,
		/datum/manufacture/pride_ace,
		/datum/manufacture/pride_aro,
		/datum/manufacture/pride_bi,
		/datum/manufacture/pride_inter,
		/datum/manufacture/pride_lesb,
		/datum/manufacture/pride_gay,
		/datum/manufacture/pride_nb,
		/datum/manufacture/pride_pan,
		/datum/manufacture/pride_poly,
		/datum/manufacture/pride_trans,
		/datum/manufacture/hat_black,
		/datum/manufacture/hat_white,
		/datum/manufacture/hat_pink,
		/datum/manufacture/hat_red,
		/datum/manufacture/hat_yellow,
		/datum/manufacture/hat_orange,
		/datum/manufacture/hat_green,
		/datum/manufacture/hat_blue,
		/datum/manufacture/hat_purple,
		/datum/manufacture/hat_tophat,
		/datum/manufacture/handkerchief,)

	hidden = list(/datum/manufacture/id_card_gold,
		/datum/manufacture/implant_access_infinite,
		/datum/manufacture/breathmask,
		/datum/manufacture/patch,
		/datum/manufacture/tricolor,
		/datum/manufacture/hat_ltophat)

/obj/machinery/manufacturer/qm // This manufacturer just creates different crated and boxes for the QM. Lets give their boring lives at least something more interesting.
	name = "crate manufacturer"
	supplemental_desc = "This one produces crates, carts, that sort of thing. Y'know, box stuff."
	icon_state = "fab-crates"
	icon_base = "crates"
	free_resources = list(/obj/item/material_piece/steel = 1,
		/obj/item/material_piece/organic/wood = 1)
	accept_blueprints = FALSE
	available = list(/datum/manufacture/crate,
		/datum/manufacture/packingcrate,
		/datum/manufacture/wooden,
		/datum/manufacture/medical,
		/datum/manufacture/biohazard,
		/datum/manufacture/freezer)

	hidden = list(/datum/manufacture/classcrate)

/obj/machinery/manufacturer/zombie_survival
	name = "\improper Uber-Extreme Survival Manufacturer"
	desc = "This manufacturing unit seems to have been loaded with a bunch of nonstandard blueprints, apparently to be useful in surviving \"extreme scenarios\"."
	icon_state = "fab-crates"
	icon_base = "crates"
	free_resources = list(/obj/item/material_piece/steel = 50,
		/obj/item/material_piece/copper = 50,
		/obj/item/material_piece/glass = 50,
		/obj/item/material_piece/cloth/cottonfabric = 50)
	accept_blueprints = FALSE
	available = list(
		/datum/manufacture/engspacesuit,
		/datum/manufacture/breathmask,
		/datum/manufacture/suture,
		/datum/manufacture/scalpel,
		/datum/manufacture/flashlight,
		/datum/manufacture/armor_vest,
		/datum/manufacture/bullet_22,
		/datum/manufacture/harmonica,
		/datum/manufacture/riot_shotgun,
		/datum/manufacture/riot_shotgun_ammo,
		/datum/manufacture/clock,
		/datum/manufacture/clock_ammo,
		/datum/manufacture/saa,
		/datum/manufacture/saa_ammo,
		/datum/manufacture/riot_launcher,
		/datum/manufacture/riot_launcher_ammo_pbr,
		/datum/manufacture/riot_launcher_ammo_flashbang,
		/datum/manufacture/sniper,
		/datum/manufacture/sniper_ammo,
		/datum/manufacture/tac_shotgun,
		/datum/manufacture/tac_shotgun_ammo,
		/datum/manufacture/gyrojet,
		/datum/manufacture/gyrojet_ammo,
		/datum/manufacture/plank,
		/datum/manufacture/brute_kit,
		/datum/manufacture/burn_kit,
		/datum/manufacture/crit_kit,
		/datum/manufacture/spacecillin,
		/datum/manufacture/bat,
		/datum/manufacture/quarterstaff,
		/datum/manufacture/cleaver,
		/datum/manufacture/fireaxe,
		/datum/manufacture/shovel)

/obj/machinery/manufacturer/engineering
	name = "Engineering Specialist Manufacturer"
	desc = "This one produces specialist engineering devices."
	icon_state = "fab-engineering"
	icon_base = "engineering"
	free_resources = list(/obj/item/material_piece/steel = 2,
		/obj/item/material_piece/copper = 2,
		/obj/item/material_piece/glass = 2)
	available = list(
		/datum/manufacture/screwdriver/yellow,
		/datum/manufacture/wirecutters/yellow,
		/datum/manufacture/wrench/yellow,
		/datum/manufacture/crowbar/yellow,
		/datum/manufacture/extinguisher,
		/datum/manufacture/welder/yellow,
		/datum/manufacture/soldering,
		/datum/manufacture/multitool,
		/datum/manufacture/t_scanner,
		/datum/manufacture/RCD,
		/datum/manufacture/RCDammo,
		/datum/manufacture/RCDammomedium,
		/datum/manufacture/RCDammolarge,
		/datum/manufacture/atmos_goggles,
		/datum/manufacture/engivac,
		/datum/manufacture/lampmanufacturer,
		/datum/manufacture/pod/weapon/efif1,
		/datum/manufacture/breathmask,
		/datum/manufacture/engspacesuit,
		/datum/manufacture/lightengspacesuit,
		/datum/manufacture/floodlight,
		/datum/manufacture/powercell,
		/datum/manufacture/powercellE,
		/datum/manufacture/powercellC,
		/datum/manufacture/powercellH,
#ifdef UNDERWATER_MAP
		/datum/manufacture/engdivesuit,
		/datum/manufacture/flippers,
#endif
#ifdef MAP_OVERRIDE_OSHAN
		/datum/manufacture/cable/reinforced,
#endif
		/datum/manufacture/mechanics/laser_mirror,
		/datum/manufacture/mechanics/laser_splitter,
		/datum/manufacture/interdictor_kit,
		/datum/manufacture/interdictor_board_standard,
		/datum/manufacture/interdictor_board_nimbus,
		/datum/manufacture/interdictor_board_zephyr,
		/datum/manufacture/interdictor_board_devera,
		/datum/manufacture/interdictor_rod_lambda,
		/datum/manufacture/interdictor_rod_sigma,
		/datum/manufacture/interdictor_rod_epsilon,
		/datum/manufacture/interdictor_rod_phi
	)

	New()
		. = ..()
		if (isturf(src.loc)) //not inside a frame or something
			new /obj/item/paper/book/from_file/interdictor_guide(src.loc)

/// Artifact manufacturer used internally for /obj/artifact/fabricator, basically invisible
/obj/machinery/manufacturer/artifact
	name = "Artifact Manufacturer"
	desc = "You have no idea what this one fabricates."
	icon = 'icons/obj/artifacts/artifacts.dmi'
	icon_state = "unknown-1"
	accept_blueprints = FALSE
	free_resources = list(/obj/item/material_piece/steel = 2,
		/obj/item/material_piece/copper = 2,
		/obj/item/material_piece/glass = 2)
	// Availability of recipes determined by origin and RNG
	// This gets set in New() on the artifact itself because the manufacturer doesn't know its own origin
	available = list()
	// TODO: Implement other languages
	var/datum/language/lingo = new /datum/language/martian()

	New()
		..()
		var/recipes = concrete_typesof(/datum/manufacture) - concrete_typesof(/datum/manufacture/mechanics)
		for (var/i in 1 to 10)
			src.available += pick(recipes)

	build_icon()
		return

	begin_work(new_production = TRUE)
		src.error = null
		if (status & NOPOWER || status & BROKEN)
			return
		if (!length(src.queue))
			src.mode = "ready"
			src.build_icon()
			return
		if (!istype(src.queue[1],/datum/manufacture/))
			src.mode = "halt"
			src.error = "Corrupted entry purged from production queue."
			src.queue -= src.queue[1]
			src.visible_message(SPAN_ALERT("[src] emits an angry buzz!"))
			playsound(src.loc, src.sound_grump, 50, 1)
			src.build_icon()
			return
		var/datum/manufacture/M = src.queue[1]

		//Wire: Fix for href exploit creating arbitrary items
		if (!(M in src.available))
			src.mode = "halt"
			src.error = "Corrupted entry purged from production queue."
			src.queue -= src.queue[1]
			src.visible_message(SPAN_ALERT("[src] emits an angry buzz!"))
			playsound(src.loc, src.sound_grump, 50, 1)
			src.build_icon()
			return

		if (src.malfunction && prob(40))
			src.flip_out()

		if (new_production)
			var/list/mats_used = get_materials_needed(M)
			if (!(length(mats_used) == length(M.item_requirements)))
				src.mode = "halt"
				src.error = "Insufficient usable materials to continue queue production."
				src.visible_message(SPAN_ALERT("[src] emits an angry buzz!"))
				playsound(src.loc, src.sound_grump, 50, 1)
				src.build_icon()
				return

		playsound(src.loc, src.sound_beginwork, 50, 1, 0, 3)
		src.mode = "working"
		src.build_icon()

		src.action_bar = actions.start(new/datum/action/bar/manufacturer(src, src.time_left, null), src)

	/// Change interface language of the fabricator to be based on origin
	/// This is a cursed approach for now, ideally I'd like to atomize all of this into one singular function
	manufacture_as_list(datum/manufacture/M, mob/user)
		var/generated_names = list()
		var/generated_descriptions = list()

		// Fix not having generated material names for blueprints like multitools
		if (isnull(M.item_names))
			M.item_names = list()
			for (var/datum/manufacturing_requirement/R as anything in M.item_requirements)
				M.item_names += src.lingo.heard_not_understood(R.getName())

		for (var/i in 1 to length(M.item_outputs))
			var/T
			if (istype(M, /datum/manufacture/mechanics))
				var/datum/manufacture/mechanics/mech = M
				T = mech.frame_path
			else
				T = M.item_outputs[i]

			if (ispath(T, /atom/))
				var/atom/A = T
				generated_names += src.lingo.heard_not_understood(initial(A.name))
				generated_descriptions += "[src.lingo.heard_not_understood(initial(A.desc))]"

		var/img
		if (istype(M, /datum/manufacture/mechanics))
			var/datum/manufacture/mechanics/mech = M
			img = getItemIcon(mech.frame_path, C = user.client)
		else
			img = getItemIcon(M.item_outputs[1], C = user.client)

		var/requirement_data = list()
		for (var/datum/manufacturing_requirement/R as anything in M.item_requirements)
			requirement_data += list(list("name" = src.lingo.heard_not_understood(R.getName()), "id" = R.getID(), "amount" = M.item_requirements[R]))

		return list(
			"name" = src.lingo.heard_not_understood(M.name),
			"category" = src.lingo.heard_not_understood(M.category),
			"requirement_data" = requirement_data,
			"item_names" = generated_names,
			"item_descriptions" = generated_descriptions,
			"item_outputs" = M.item_outputs,
			"create" = M.create,
			"time" = M.time,
			"apply_material" = M.apply_material,
			"img" = img,
			"byondRef" = "\ref[M]",
			"isMechBlueprint" = istype(M, /datum/manufacture/mechanics),
		)

	blueprints_as_list(var/list/L, mob/user, var/static_elements = FALSE)
		var/list/as_list = list()
		for (var/datum/manufacture/M as anything in L)
			if (isnull(M.category) || !(M.category in src.categories)) // fix for not displaying blueprints/manudrives
				M.category = "Miscellaneous"
				logTheThing(LOG_DEBUG, src, "Manufacturing blueprint [M] has category [M.category], which is not on the list of categories for [src]!")
			var/translated_category = src.lingo.heard_not_understood(M.category)
			if (length(as_list[translated_category]) == 0)
				as_list[translated_category] = list()
			as_list[translated_category] += list(manufacture_as_list(M, user, static_elements))
		return as_list

	ui_data(mob/user)
		// When we update the UI, we must regenerate the blueprint data if the blueprints known to us has changed since last time
		// No need to do this if we're depowered/broken though
		if (should_update_static && !src.is_disabled())
			should_update_static = FALSE
			src.update_static_data(user)

		// Send material data as tuples of material name, material id, material amount
		var/resource_data = list()
		for (var/obj/item/material_piece/P as anything in src.get_contents())
			if (!P.material)
				continue
			resource_data += list(
				list(
					"name" = src.lingo.heard_not_understood(P.material.getName()),
					"id" = P.material.getID(),
					"amount" = P.amount,
					"byondRef" = "\ref[P]",
					"satisfies" = src.material_patterns_by_ref["\ref[P.material]"]
				)
			)

		// Package additional information into each queued item for the badges so that it can lookup its already sent information
		var/queue_data = list()
		for (var/datum/manufacture/M in src.queue)
			queue_data += list(
				list(
					"name" = src.lingo.heard_not_understood(M.name),
				 	"category" = src.lingo.heard_not_understood(M.category),
				  	"type" = src.get_blueprint_type(M)
				)
			)

		// This calculates the percentage progress of a blueprint by the time that already elapsed before a pause (0 if never paused)
		// added to the current time that has been elapsed, divided by the total time to be elapsed.
		// But we keep the pct a constant if we're paused, and just do time that was elapsed / time to elapse
		var/progress_pct = null // TODO: use predicted end time to have clientside progress animation instead of sending percentage
		if (length(src.queue))
			if (src.mode != "working")
				progress_pct = 1 - (src.time_left / src.original_duration)
			else
				progress_pct = ((src.original_duration - src.time_left) + (TIME - src.time_started)) / src.original_duration

		return list(
			"delete_allowed" = src.allowed(user),
			"queue" = queue_data,
			"progress_pct" = progress_pct,
			"panel_open" = src.panel_open,
			"hacked" = src.hacked,
			"malfunction" = src.malfunction,
			"mode" = src.mode,
			"wire_bitflags" = src.wires,
			"banking_info" = src.get_bank_data(),
			"speed" = src.speed,
			"repeat" = src.repeat,
			"error" = src.error,
			"resource_data" = resource_data,
			"manudrive_uses_left" = src.get_drive_uses_left(),
			"indicators" = list("electrified" = src.is_electrified(),
							    "malfunctioning" = src.malfunction,
								"hacked" = src.hacked,
								"hasPower" = !src.is_disabled(),
							   ),
		)

	ui_static_data(mob/user)
		var/list/translated_categories = list()
		for (var/cat in src.categories)
			translated_categories += src.lingo.heard_not_understood(cat)
		return list (
			"fabricator_name" = src.lingo.heard_not_understood(src.name),
			"all_categories" = translated_categories,
			"available_blueprints" = blueprints_as_list(src.available, user),
			"hidden_blueprints" = blueprints_as_list(src.hidden, user),
			"downloaded_blueprints" = blueprints_as_list(src.download, user),
			"recipe_blueprints" = blueprints_as_list(src.drive_recipes, user),
			"wires" = APCWireColorToIndex,
			"rockboxes" = rockboxes_as_list(),
			"manudrive" = list ("name" = "[src.manudrive]",
							   	"limit" = src.manudrive?.fablimit,
							   ),
			"min_speed" = 1,
			"max_speed_normal" = 3,
			"max_speed_hacked" = 3,
		)

/obj/machinery/manufacturer/artifact/martian
	name = "Martian Manufacturer"
	lingo = new /datum/language/martian()

/obj/machinery/manufacturer/artifact/ancient
	name = "Ancient Manufacturer"
	lingo = new /datum/language/binary()

/obj/machinery/manufacturer/artifact/clockwork
	name = "Clockwork Manufacturer"
	lingo = new /datum/language/clockwork()
