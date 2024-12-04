// zamu's "mail".
//
// mail in this case is actually just timed gifts sent to the crew,
// through the cargo system.
//
// mail is "locked" to the mob that should receive it,
// via dna (or whatever. todo: update me)
//
// ideally, the amount of mail "per cycle" would vary depending on
// how long since the last one and how many players are online
// ideally every player would get a few pieces of mail over the
// course of an hour (say, every 20 minutes)

/obj/item/random_mail
	name = "mail"
	desc = "A package!"
	icon = 'icons/obj/items/items.dmi'
	icon_state = "mail-1"
	item_state = "gift"
	pressure_resistance = 70
	var/recipient = "You"
	var/sender = "Me"
	var/obj/item/paper/letter = null // A letter included in the package
	var/no_letter = FALSE // For our letter-haters out here
	var/random_icons = TRUE
	var/spawn_type = null
	var/tmp/target_dna = null

	// this is largely copied from /obj/item/a_gift

	New()
		..()
		if (src.random_icons)
			src.icon_state = "mail-[rand(1,3)]"
		if (!no_letter)
			src.letter = new /obj/item/paper(src)

	attack_self(mob/M as mob)
		if (!ishuman(M))
			boutput(M, SPAN_NOTICE("You aren't human, you definitely can't open this!"))

		if (src.target_dna)
			var/dna = M?.bioHolder?.Uid

			if (!dna || dna != src.target_dna)
				boutput(M, SPAN_NOTICE("This isn't addressed to you! Opening it would be <em>illegal!</em> Also, the DNA lock won't open."))
				return

		if (!src.spawn_type)
			boutput(M, SPAN_NOTICE("[src] was empty! What a rip!"))
			qdel(src)
			return

		var/atom/movable/prize = src.open(M)
		logTheThing(LOG_STATION, M, "opened their [src] and got \a [prize] ([src.spawn_type]).")
		game_stats.Increment("mail_opened")
		// 100 credits + 10 more for every successful delivery after the first,
		// capping at 1000 per letter delivered
		shippingmarket.mail_delivery_payout += 90 + 10 * min(91, game_stats.GetStat("mail_opened"))

		return

	proc/setup_stamp(var/stamp_png, var/icon_state)
		if(!src.letter)
			return
		src.letter.stamp(rand(90,260), rand(150,390), rand(-20,20), stamp_png, icon_state)

	proc/setup_letter_text(var/sender, var/list/context)
		if(!src.letter)
			return
		src.sender = sender

		var/beginning = ""
		var/middle = ""
		var/end = ""
		if(length(context) == 0)
			return

		var/context_text = context["name"]
		switch(context["id"])
			if("trait")
				beginning = pick("\"[context_text]\"... I know that means a lot to you.", "\"[context_text]\" is a big part of your life, yeah?", "You spend a lot of thinking about it, don't you?<br>\"[context_text]\".")
				var/expression1 = pick("know what else to get you", "think that you would care", "bother thinking much about it", "spend much time picking this", "consider what you'd think")
				var/expression2 = pick("I remembered you care about this", "it suddenly came to me", "I saw an ad on TV about this", "I had your friend remind me of this")
				var/middle1 = pick("Didn't really [expression1]", "Honestly, I didn't [expression1]", "Frankly, I did not [expression1]")
				var/middle2 = pick("but then [expression2]", "it might be weird that [expression2]", "however [expression2]")
				middle = "[middle1], [middle2]."
			if("job")
				var/expression = pick("working really hard", "working your socks off", "pulling overtime", "doing excellent work", "doing a good job")
				beginning = pick("Your efforts as [context_text] have not gone unnoticed.", "How long has it been you started working as [context_text]?", "Working as [context_text] isn't easy, I know that.")
				middle = pick("Think I wouldn't notice you've been [expression]?", "I know you've been [expression] for me.", "Hate to say it, but you're [expression].")
				sender += "<br>[context["sender_job"]]"
			else
				beginning = "Literally have no idea why I'm doing this."
				middle = "Like, genuinely. I don't even know you. But anyway."
		end = pick("Thought I'd send you a little something in appreciation.", "Hope you like this little gift from me.", "Here's something to celebrate your hard work.")
		var/greeting = pick("Hey", "Hello", "Hi", "Salutations", "Greetings", "Yo", "Sup", "Hiya")
		var/signature = pick("Signed", "Kind regards", "XOXO", "Stay safe", "Peace", "You owe me")
		src.letter.info = {"[greeting] [src.recipient],<br><br>
			[beginning]<br>
			[middle]<br>
			[end]<br><br>
			[signature],<br>
			[sender]"}

	proc/open(mob/M, crime = FALSE)
		var/atom/movable/prize = new src.spawn_type
		. = prize
		if (prize && istype(prize, /obj/item))
			boutput(M, SPAN_NOTICE("You [crime ? "tear " : ""]open the package and pull out \a [prize]."))
			var/obj/item/P = prize
			P.name = "[recipient]'s [P.name]"
			P.quality = rand(5,80)
			M.u_equip(src)
			M.put_in_hand_or_drop(P)

		else if (prize)
			boutput(M, SPAN_NOTICE("You somehow pull \a [prize] out of \the [src]!"))
			prize.name = "[recipient]'s [prize.name]"
			prize.set_loc(get_turf(M))

		else
			boutput(M, SPAN_NOTICE("You have no idea what it is you did, but \the [src] collapses in on itself!"))
			logTheThing(LOG_STATION, M, "opened [src] but nothing was there, how the fuck did this happen? It was supposed to be \a [src.spawn_type]!.")

		if (src.letter)
			boutput(M, SPAN_NOTICE("Seems like there's a letter attached to \the [src]."))
			src.letter.name = "[src.sender]'s letter"
			M.put_in_hand_or_drop(src.letter)
		qdel(src)

	attackby(obj/item/I, mob/user)
		// You know, like a letter opener. It opens letters.
		if ((istype(I, /obj/item/kitchen/utensil/knife) || istype(I, /obj/item/dagger)) && src.target_dna)
			actions.start(new /datum/action/bar/icon/mail_lockpick(src, I, 5 SECONDS), user)
			return
		..()

	throw_impact(atom/hit_atom, datum/thrown_thing/thr)
		// copied from basketballs, but without the stun if you get beaned.
		..(hit_atom)
		if(hit_atom)
			if(ismob(hit_atom))
				var/mob/M = hit_atom
				if(ishuman(M))
					if((prob(50) && M.bioHolder.HasEffect("clumsy")))
						src.visible_message(SPAN_COMBAT("[M] gets beaned with \the [src.name]."))
						M.changeStatus("stunned", 2 SECONDS)
						JOB_XP(M, "Clown", 1)
						return
					else
						if (M.equipped() || get_dir(M, src) == M.dir)
							src.visible_message(SPAN_COMBAT("[M] gets beaned with \the [src.name]."))
							logTheThing(LOG_COMBAT, M, "is struck by [src]")
						else
							// catch the ~~ball~~ mail!
							src.Attackhand(M)
							M.visible_message(SPAN_COMBAT("[M] catches \the [src.name]!"), SPAN_COMBAT("You catch \the [src.name]!"))
							logTheThing(LOG_COMBAT, M, "catches [src]")
				else
					src.visible_message(SPAN_COMBAT("[M] gets beaned with the [src.name]."))
					logTheThing(LOG_COMBAT, M, "is struck by [src]")


/datum/action/bar/icon/mail_lockpick
	interrupt_flags = INTERRUPT_MOVE | INTERRUPT_ACT | INTERRUPT_STUNNED | INTERRUPT_ACTION
	duration = 5 SECONDS
	icon = 'icons/ui/actions.dmi'
	icon_state = "working"

	var/obj/item/random_mail/the_mail
	var/obj/item/the_tool
	var/is_syndi_dagger = FALSE

	New(var/obj/item/random_mail/O, var/obj/item/tool, var/duration_i)
		..()
		if (O)
			src.the_mail = O
		if (tool)
			src.the_tool = tool
			src.icon = src.the_tool.icon
			src.icon_state = src.the_tool.icon_state
			if (istype(src.the_tool, /obj/item/dagger/syndicate))
				src.is_syndi_dagger = TRUE

		if (duration_i)
			src.duration = duration_i
		if (src.is_syndi_dagger)
			src.duration *= 0.25

	onUpdate()
		..()
		if (src.the_mail == null || src.the_tool == null || owner == null || BOUNDS_DIST(owner, src.the_mail) > 0 || !src.the_mail.target_dna)
			interrupt(INTERRUPT_ALWAYS)
			return
		var/mob/source = owner
		if (istype(source) && src.the_tool != source.equipped())
			interrupt(INTERRUPT_ALWAYS)
			return
		if (!src.is_syndi_dagger && prob(8))
			owner.visible_message(SPAN_ALERT("[owner] messes up while disconnecting \the [src.the_mail]'s DNA lock!"))
			playsound(the_mail, 'sound/items/Screwdriver2.ogg', 50, TRUE)
			interrupt(INTERRUPT_ALWAYS)
			return

	onStart()
		..()
		if (!src.is_syndi_dagger)
			owner.visible_message(SPAN_ALERT("[owner] begins disconnecting \the [src.the_mail]'s lock..."))
		playsound(src.the_mail, 'sound/items/Screwdriver2.ogg', 50, 1)

	onEnd()
		..()
		owner.visible_message(SPAN_ALERT("[owner] disconnects \the [src.the_mail]'s DNA lock!"))
		logTheThing(LOG_STATION, owner, "commits MAIL FRAUD by cutting open [src.the_mail]")
		var/obj/decal/cleanable/mail_fraud/cleanable = new(get_turf(src.the_mail), src.the_mail)
		cleanable.add_fingerprint(owner)
		src.the_mail.open(owner, crime = TRUE)
		playsound(src.the_mail, 'sound/items/Screwdriver2.ogg', 50, 1)
		game_stats.Increment("mail_fraud")

		var/mob/living/ourselves = owner
		if (ourselves.mind.assigned_role == "Mail Courier")
			boutput(ourselves, SPAN_ALERT("<big style='font-size: 250%;'>WHAT HAVE YOU DONE!? WHY WOULD YOU DO THIS?</big>"))
			ourselves.emote("scream")
			ourselves.add_karma(-25)

		if (!ON_COOLDOWN(global, "mail_fraud_alert", 10 MINUTES)) // no spamming this
			SPAWN(0)
				for (var/mob/living/M in mobs)
					if (M.mind && M.mind.assigned_role == "Mail Courier")
						if (M == ourselves)
							// already handled above
							continue
						else if (ourselves.mind.assigned_role == "Mail Courier")
							// another mail courier is being evil, somehow, in case >1
							boutput(M, SPAN_ALERT("<big style='font-size: 150%;'>Your spine goes cold. Another mail courier has violated the sanctity of the mail..!</big>"))
							M.emote("shudder")
						else
							// some other schmuck did it
							boutput(M, SPAN_ALERT("You suddenly feel hollow. Someone has violated the sanctity of the mail."))

		// I TOLD YOU IT WAS ILLEGAL!!!
		// I WARNED YOU DOG!!!
		if (ishuman(owner) && seen_by_camera(owner))
			var/perpname = owner.name
			if (owner:wear_id && owner:wear_id:registered)
				perpname = owner:wear_id:registered

			var/datum/db_record/sec_record = data_core.security.find_record("name", perpname)
			if(sec_record && sec_record["criminal"] != ARREST_STATE_ARREST)
				sec_record["criminal"] = ARREST_STATE_ARREST
				sec_record["mi_crim"] = "Mail fraud."
				var/mob/living/carbon/human/H = owner
				H.update_arrest_icon()


/obj/decal/cleanable/mail_fraud
	name = "torn package"
	desc = "Some scraps of a mail package opened improperly and messily."
	icon = 'icons/obj/items/items.dmi'
	icon_state = "mail-1-b"

	New(loc, obj/item/random_mail/mail)
		..()
		if (mail)
			src.icon_state = "[mail.icon_state]-b"
			src.color = mail.color
		src.pixel_x += rand(-5,5)
		src.pixel_y += rand(-5,5)

// Creates a bunch of random mail for crewmembers
// Check shippingmarket.dm for the part that actually calls this.
/proc/create_random_mail(where, how_many = 1)

	// [mob] =  (name, rank, dna, fav_color)
	var/list/crew = list()

	// get a list of all living, connected players
	// that are not in the afterlife bar
	// and which are on the manifest
	for (var/client/C)
		if (!isliving(C.mob) || isdead(C.mob) || !ishuman(C.mob) || inafterlife(C.mob))
			continue

		var/mob/living/carbon/human/M = C.mob
		if (!istype(M)) continue	// this shouldn't be possible given ishuman, but lol

		var/datum/db_record/manifest_record = data_core.general.find_record("id", M.datacore_id)
		if (!manifest_record) continue	// must be on the manifest to get mail, sorry

		// these are all things we will want later
		crew[M] = list(
			name = manifest_record.get_field("name"),
			job = manifest_record.get_field("rank"),
			dna = manifest_record.get_field("dna"),
			fav_color = C.preferences.PDAcolor
		)

	// nobody here
	if (crew.len == 0)
		return list()


	// put created items here
	var/list/mail = list()
	var/list/already_picked = list()
	var/retry_count = 20	// arbitrary amount of how many times to try rerolling if we got someone already

	for (var/i in 1 to how_many)
		// get one of our living, on-manifest crew members

		// make an attempt to not mail the same person 5 times in a row.
		// key word: *attempt*
		// if we already generated mail for someone, try again, but only so many times
		// in case we ran out of people or they're just really (un?)lucky
		var/recipient = null
		var/picked = null
		do
			picked = pick(crew)
			recipient = crew[picked]
		while (already_picked[picked] && retry_count-- > 0)
		already_picked[picked] = TRUE

		var/datum/job/J = find_job_in_controller_by_string(recipient["job"])

		// make a gift for this person
		var/obj/item/random_mail/package = null
		var/package_color = recipient["fav_color"] ? recipient["fav_color"] : pick("#FFFFAA", "#FFBB88", "#FF8800", "#CCCCFF", "#FEFEFE")
		var/stamp_id = "stamp-stain-[rand(1, 3)]"
		var/sender = null
		var/sender_title = null
		var/list/context = list()

		// high chance to find an appropriate mail based on the traits chosen
		var/mob/living/carbon/human/H = picked
		if (ishuman(picked))
			H = picked
		if (prob(75) && length(H?.traitHolder.traits) > 0)
			if (!ishuman(picked))
				logTheThing(LOG_STATION, H, "was thought to be human, but they weren't a human. Which is really weird!!")
				break
			var/list/possible_mail = list()
			for (var/trait in mail_types_by_trait)
				if (H?.traitHolder.hasTrait(trait))
					var/random_pick = pick(mail_types_by_trait[trait])
					if(trait == "picky_eater")
						var/datum/trait/picky_eater/picky_trait = H?.traitHolder.getTrait(trait)
						if(length(picky_trait.fav_foods) > 0)
							random_pick = pick(picky_trait.fav_foods)
					possible_mail[trait] = random_pick
			if (length(possible_mail) > 0)
				var/datum/trait/chosen = getTraitById(pick(possible_mail))
				var/spawn_type = possible_mail[chosen.id]
				package = new(where)
				package.spawn_type = spawn_type
				context["id"] = "trait"
				context["name"] = chosen.name

		// the probability here can go up as the number of items for jobs increases.
		// right now the job pools are kind of small for some, so only use it sometimes.
		if (!package && prob(75) && length(mail_types_by_job[J.type]))
			var/spawn_type = weighted_pick(mail_types_by_job[J.type])
			package = new(where)
			package.spawn_type = spawn_type
			package_color = J.linkcolor ? J.linkcolor : "#FFFFFF"

			var/sender_job = null
			// Pick a cool stamp and random "official" sender based on job for flavor
			switch(J.job_category)
				if (JOB_COMMAND)
					stamp_id = "stamp-centcom"
					sender = "John NanoTrasen"
					sender_job = "CEO"
				if (JOB_SECURITY)
					sender_title = pick("Pvt.","Sgt","Cpl.","Maj.","Cpt.","Col.","Gen.")
					stamp_id = "stamp-hos"
					sender_job = "NanoTrasen Security Services"
				if (JOB_RESEARCH)
					// Why do we still not separate medical doctors and scientists
					sender_title = pick("Dr.", "Prof.", "Prof. Dr.")
					if (J.type == /datum/job/research/scientist || J.type == /datum/job/research/research_assistant)
						stamp_id = "stamp-rd"
						sender_job = "NanoTrasen Research & Development"
					else
						stamp_id = "stamp-md"
						sender = "NanoTrasen Medical Services"
				if (JOB_ENGINEERING)
					if (prob(50))
						sender_title = pick("Dr.")
					stamp_id = "stamp-ce"
					sender_job = "NanoTrasen Engineering Services"
				if (JOB_CIVILIAN)
					if (J.type == /datum/job/civilian/clown)
						stamp_id = "stamp-honk"
						sender = "Geoff Honkington"
						sender_job = "Ex-Clown"
					else
						stamp_id = "stamp-hop"
						sender_job = "NanoTrasen Human Resources"
				if (JOB_SPECIAL)
					if (J.type == /datum/job/special/mime)
						stamp_id = "stamp-mime"
						sender = "Mimi Mimesworth"
						sender_job = "Mime Lord"
				else
					stamp_id = "stamp-centcom"
					sender = "John NanoTrasen"
					sender_job = "CEO"
			context["id"] = "job"
			context["sender_job"] = sender_job
			context["name"] = J.name
		else if (!package)
			// if there are no job specific items or we aren't doing job-specific ones,
			// just throw some random crap in there, fuck it. who cares. not us
			var/spawn_type = weighted_pick(mail_types_everyone)
			package = new(where)
			package.spawn_type = spawn_type
			package.name = "mail for [recipient["name"]]"

			context["id"] = "normal"
			context["name"] = ""

		package.name = "mail for [recipient["name"]] ([recipient["job"]])"
		var/list/color_list = rgb2num(package_color)
		for(var/j in 1 to 3)
			color_list[j] = 127 + (color_list[j] / 2) + rand(-10, 10)
		package.color = rgb(color_list[1], color_list[2], color_list[3])
		package.pixel_x = rand(-2, 2)
		package.pixel_y = rand(-2, 2)

		// packages are dna-locked so you can't just swipe everyone's mail like a jerk.
		package.target_dna = recipient["dna"]
		package.recipient = recipient["name"]
		package.desc = "A package for [recipient["name"]]. It has a DNA-based lock, so only [recipient["name"]] can open it."

		sender = sender ? sender : "[pick(pick_string_autokey("names/first_male.txt"), pick_string_autokey("names/first_female.txt"))] [pick_string_autokey("names/last.txt")]"
		sender = sender_title ? "[sender_title] [sender]" : sender
		package.setup_letter_text(sender, context)
		package.setup_stamp("[stamp_id].png", stamp_id)

		mail += package

	return mail

// =======================================================
// Various random items jobs can get via the "mail" system

var/global/mail_types_by_job = list(
	/datum/job/command/captain = list(
		/obj/item/clothing/suit/bedsheet/captain = 2,
		/obj/item/item_box/gold_star = 1,
		/obj/item/stamp/cap = 2,
		/obj/item/cigarbox/gold = 2,
		/obj/item/paper/book/from_file/captaining_101 = 1,
		/obj/item/disk/data/floppy/read_only/communications = 1,
		/obj/item/reagent_containers/food/drinks/bottle/champagne = 3,
		/obj/item/reagent_containers/food/drinks/bottle/thegoodstuff = 3,
		/obj/item/pinpointer/category/pets = 2,
		/obj/item/device/flash = 2,
		),

	/datum/job/command/head_of_personnel = list(
		/obj/item/toy/judge_gavel = 3,
		/obj/item/storage/box/id_kit = 2,
		/obj/item/stamp/hop = 3,
		/obj/item/storage/box/trackimp_kit = 1,
		/obj/item/pinpointer/category/pets = 1,
		/obj/item/reagent_containers/food/drinks/rum_spaced = 2,
		/obj/item/device/flash = 2,
		),

	/datum/job/command/head_of_security = list(
		/obj/item/reagent_containers/food/drinks/coffee = 5,
		/obj/item/reagent_containers/food/snacks/donut/custom/random = 5,
		/obj/item/reagent_containers/food/snacks/donut/custom/robust = 1,
		/obj/item/reagent_containers/food/snacks/donut/custom/robusted = 1,
		/obj/item/device/flash = 3,
		/obj/item/clothing/head/helmet/siren = 2,
		/obj/item/handcuffs = 2,
		/obj/item/device/ticket_writer = 2,
		/obj/item/device/prisoner_scanner = 2,
		/obj/item/clothing/head/helmet/camera/security = 2,
		),

	/datum/job/command/chief_engineer = list(
		/obj/item/rcd_ammo = 10,
		/obj/item/chem_grenade/firefighting = 5,
		/obj/item/old_grenade/oxygen = 7,
		/obj/item/chem_grenade/metalfoam = 4,
		/obj/item/cable_coil = 3,
		/obj/item/lamp_manufacturer/organic = 5,
		/obj/item/pen/infrared = 4,
		/obj/item/sheet/steel/fullstack = 2,
		/obj/item/sheet/glass/fullstack = 2,
		/obj/item/rods/steel/fullstack = 1,
		/obj/item/tile/steel/fullstack = 1,
		),

	/datum/job/command/research_director = list(
		/obj/item/disk/data/tape/master/readonly = 5,
		/obj/item/aiModule/random = 5,
		/obj/item/reagent_containers/food/snacks/beefood = 4,
		/obj/item/stamp/rd = 2,
		/obj/item/device/flash = 2,
		/obj/item/parts/robot_parts/arm/right/light = 2,
		/obj/item/disk/data/tape = 3,
		/obj/item/pinpointer/category/artifacts = 1,
		/obj/item/device/gps = 1,
		/obj/item/guardbot_frame = 2,
		),

	/datum/job/command/medical_director = list(
		/obj/item/reagent_containers/mender/brute = 5,
		/obj/item/reagent_containers/mender/burn = 5,
		/obj/item/reagent_containers/mender/both = 3,
		/obj/item/reagent_containers/mender_refill_cartridge/brute = 6,
		/obj/item/reagent_containers/mender_refill_cartridge/burn = 6,
		/obj/item/reagent_containers/mender_refill_cartridge/both = 5,
		/obj/item/item_box/medical_patches/mini_styptic = 10,
		/obj/item/item_box/medical_patches/mini_silver_sulf = 10,
		/obj/item/medicaldiagnosis/stethoscope = 5,
		/obj/item/reagent_containers/hypospray = 2,
		/obj/item/reagent_containers/food/snacks/candy/lollipop/random_medical = 5,
		/obj/item/reagent_containers/emergency_injector/epinephrine = 3,
		/obj/item/reagent_containers/emergency_injector/saline = 3,
		/obj/item/reagent_containers/emergency_injector/charcoal = 3,
		/obj/item/reagent_containers/emergency_injector/random = 2,
		),


	/datum/job/security/security_officer = list(
		/obj/item/reagent_containers/food/drinks/coffee = 5,
		/obj/item/reagent_containers/food/snacks/donut/custom/random = 5,
		/obj/item/reagent_containers/food/snacks/donut/custom/robust = 1,
		/obj/item/reagent_containers/food/snacks/donut/custom/robusted = 1,
		/obj/item/device/flash = 3,
		/obj/item/clothing/head/helmet/siren = 2,
		/obj/item/handcuffs = 2,
		/obj/item/device/ticket_writer = 2,
		/obj/item/device/prisoner_scanner = 2,
		/obj/item/clothing/head/helmet/camera/security = 2,
		),

	/datum/job/security/security_officer/assistant = list(
		/obj/item/reagent_containers/food/drinks/coffee = 5,
		/obj/item/reagent_containers/food/snacks/donut/custom/random = 5,
		/obj/item/reagent_containers/food/snacks/donut/custom/robust = 1,
		/obj/item/reagent_containers/food/snacks/donut/custom/robusted = 1,
		/obj/item/device/flash = 3,
		/obj/item/clothing/head/helmet/siren = 2,
		/obj/item/device/ticket_writer = 2,
		/obj/item/device/prisoner_scanner = 2,
		/obj/item/clothing/head/helmet/camera/security = 2,
		),

	/datum/job/security/detective = list(
		/obj/item/device/detective_scanner = 4,
		/obj/item/cigpacket = 4,
		/obj/item/cigpacket/nicofree = 4,
		/obj/item/cigpacket/menthol = 4,
		/obj/item/cigpacket/propuffs = 4,
		/obj/item/cigpacket/cigarillo = 2,
		/obj/item/reagent_containers/vape = 2,
		/obj/item/reagent_containers/ecig_refill_cartridge = 3,
		/obj/item/device/light/zippo = 3,
		/obj/item/cigpacket/random = 1,
		),



	/datum/job/research/scientist = list(
		/obj/item/parts/robot_parts/arm/right/light = 5,
		/obj/item/cargotele = 5,
		/obj/item/disk/data/tape = 5,
		/obj/item/pinpointer/category/artifacts/safe = 8,
		/obj/item/pinpointer/category/artifacts = 1,
		/obj/item/device/gps = 3,
		/obj/item/clothing/head/helmet/camera = 3,
		),

	/datum/job/research/medical_doctor = list(
		/obj/item/reagent_containers/mender/brute = 5,
		/obj/item/reagent_containers/mender/burn = 5,
		/obj/item/reagent_containers/mender/both = 3,
		/obj/item/reagent_containers/mender_refill_cartridge/brute = 6,
		/obj/item/reagent_containers/mender_refill_cartridge/burn = 6,
		/obj/item/reagent_containers/mender_refill_cartridge/both = 5,
		/obj/item/item_box/medical_patches/mini_styptic = 10,
		/obj/item/item_box/medical_patches/mini_silver_sulf = 10,
		/obj/item/medicaldiagnosis/stethoscope = 5,
		/obj/item/reagent_containers/hypospray = 2,
		/obj/item/reagent_containers/food/snacks/candy/lollipop/random_medical = 5,
		/obj/item/reagent_containers/emergency_injector/epinephrine = 3,
		/obj/item/reagent_containers/emergency_injector/saline = 3,
		/obj/item/reagent_containers/emergency_injector/charcoal = 3,
		/obj/item/reagent_containers/emergency_injector/random = 2,
		),

	/datum/job/research/roboticist = list(
		/obj/item/reagent_containers/mender/brute = 5,
		/obj/item/reagent_containers/mender/burn = 5,
		/obj/item/reagent_containers/mender/both = 3,
		/obj/item/reagent_containers/mender_refill_cartridge/brute = 6,
		/obj/item/reagent_containers/mender_refill_cartridge/burn = 6,
		/obj/item/reagent_containers/mender_refill_cartridge/both = 5,
		/obj/item/robot_module = 5,
		/obj/item/parts/robot_parts/robot_frame = 4,
		/obj/item/cell/supercell/charged = 3,
		/obj/item/cable_coil = 5,
		/obj/item/sheet/steel/fullstack = 2,
		),

	/datum/job/research/geneticist = list(
		// so you can keep looking at your screen,
		// even in the brightness of nuclear hellfire o7
		/obj/item/clothing/glasses/sunglasses/tanning = 10,
		),



	/datum/job/engineering/engineer = list(
		/obj/item/chem_grenade/firefighting = 5,
		/obj/item/old_grenade/oxygen = 7,
		/obj/item/chem_grenade/metalfoam = 4,
		/obj/item/cable_coil = 6,
		/obj/item/lamp_manufacturer/organic = 5,
		/obj/item/pen/infrared = 7,
		/obj/item/sheet/steel/fullstack = 2,
		/obj/item/sheet/glass/fullstack = 2,
		/obj/item/rods/steel/fullstack = 2,
		/obj/item/tile/steel/fullstack = 2,
		),

	/datum/job/engineering/quartermaster = list(
		/obj/item/currency/spacecash/hundred = 10,
		/obj/item/currency/spacecash/fivehundred = 7,
		/obj/item/currency/spacecash/tourist = 3,
		/obj/item/stamp/qm = 5,
		/obj/item/cargotele = 3,
		/obj/item/device/appraisal = 4,
		),

	/datum/job/engineering/miner = list(
		/obj/item/device/gps = 3,
		/obj/item/satchel/mining = 3,
		/obj/item/satchel/mining/large = 2,
		/obj/item/storage/pill_bottle/antirad = 2,
		/obj/item/cargotele = 3,
		/obj/item/currency/spacecash/tourist = 3,
		),



	/datum/job/civilian/chef = list(
		/obj/item/kitchen/utensil/knife/bread = 5,
		/obj/item/kitchen/utensil/knife/cleaver = 5,
		/obj/item/kitchen/utensil/knife/pizza_cutter = 5,
		/obj/item/reagent_containers/food/drinks/mug = 5,
		/obj/item/reagent_containers/food/drinks/tea = 5,
		/obj/item/reagent_containers/food/drinks/coffee = 5,
		/obj/item/reagent_containers/food/snacks/ingredient/egg = 5,
		/obj/item/reagent_containers/food/snacks/plant/tomato = 5,
		/obj/item/reagent_containers/food/snacks/ingredient/meat/synthmeat = 5,
		),

	/datum/job/civilian/bartender = list(
		/obj/item/reagent_containers/food/drinks/drinkingglass = 2,
		/obj/item/reagent_containers/food/drinks/drinkingglass/cocktail = 2,
		/obj/item/reagent_containers/food/drinks/drinkingglass/shot = 2,
		/obj/item/reagent_containers/food/drinks/drinkingglass/flute = 2,
		/obj/item/reagent_containers/food/drinks/drinkingglass/wine = 2,
		/obj/item/reagent_containers/food/drinks/drinkingglass/oldf = 2,
		/obj/item/reagent_containers/food/drinks/drinkingglass/pitcher = 2,
		/obj/item/reagent_containers/food/drinks/drinkingglass/round = 2,
		/obj/item/reagent_containers/food/drinks/drinkingglass/random_style/filled/sane = 5,
		/obj/item/reagent_containers/food/drinks/bottle/hobo_wine = 4,
		),

	/datum/job/civilian/botanist = list(
		/obj/item/reagent_containers/food/snacks/ingredient/egg/bee = 10,
		/obj/item/plant/herb/cannabis/spawnable = 3,
		/obj/item/seed/alien = 10,
		/obj/item/satchel/hydro = 7,
		/obj/item/satchel/hydro/large = 5,
		/obj/item/reagent_containers/glass/bottle/powerplant = 5,
		/obj/item/reagent_containers/glass/bottle/fruitful = 5,
		/obj/item/reagent_containers/glass/bottle/topcrop = 5,
		/obj/item/reagent_containers/glass/bottle/groboost = 5,
		/obj/item/reagent_containers/glass/bottle/mutriant = 5,
		/obj/item/reagent_containers/glass/bottle/weedkiller = 5,
		/obj/item/reagent_containers/glass/compostbag = 5,
		/obj/item/reagent_containers/glass/happyplant = 4,
		),

	/datum/job/civilian/rancher = list(
		),

	/datum/job/civilian/janitor = list(
		/obj/item/chem_grenade/cleaner = 5,
		/obj/item/sponge = 7,
		/obj/item/spraybottle/cleaner = 6,
		/obj/item/caution = 5,
		/obj/item/reagent_containers/glass/bottle/acetone/janitors = 3,
		/obj/item/mop = 5,
		/obj/item/reagent_containers/glass/bucket = 5,
		/obj/item/reagent_containers/glass/bucket/red = 1,
		/obj/item/clothing/head/plunger = 2,
		),

	/datum/job/civilian/chaplain = list(
		/obj/item/bible = 2,
		/obj/item/device/light/candle = 4,
		/obj/item/device/light/candle/small = 5,
		/obj/item/device/light/candle/spooky = 2,
		/obj/item/ghostboard = 5,
		/obj/item/ghostboard/emouija = 2,
		/obj/item/card_box/tarot = 2,
		/obj/item/reagent_containers/glass/bottle/holywater = 3,
		),

	/datum/job/civilian/clown = list(
		/obj/item/reagent_containers/food/snacks/plant/banana = 15,
		/obj/item/storage/box/balloonbox = 5,
		/obj/item/canned_laughter = 15,
		/obj/item/bananapeel = 10,
		/obj/item/toy/sword = 3,
		/obj/item/rubber_hammer = 1,
		/obj/item/balloon_animal/random = 3,
		/obj/item/pen/crayon/rainbow = 2,
		/obj/item/pen/crayon/random = 1,
		/obj/item/storage/goodybag = 3,
		),

	/datum/job/civilian/staff_assistant = list(
		/obj/item/football = 2,
		/obj/item/basketball = 2,
		/obj/item/toy/sword = 2,
		/obj/item/toy/figure = 3,
		/obj/item/clothing/gloves/boxing = 3,
		/obj/item/device/light/zippo = 4,
		/obj/item/plant/herb/cannabis/spawnable = 4,
		/obj/item/reagent_containers/emergency_injector/epinephrine = 4,
		/obj/item/pen/crayon/random = 4,
		/obj/item/pen/crayon/rainbow = 2,
		/obj/item/sponge = 3,
		/obj/item/spraybottle/cleaner = 3,
		/obj/item/lamp_manufacturer/organic = 2,
		/obj/item/sheet/steel/fullstack = 3,
		/obj/item/tile/steel/fullstack = 3,
		/obj/item/sheet/glass/fullstack = 2,
		/obj/item/rods/steel/fullstack = 2,
		/obj/item/clothing/mask/balaclava = 1,
		/obj/item/clothing/head/helmet/welding = 2,

		)
	)

// =========================================================================
// Various items given out based on player trait choices, to make it more personal
var/global/mail_types_by_trait = list(
	"petasusaphilic" = filtered_concrete_typesof(/obj/item/clothing/head, /proc/filter_trait_hats),
	"pawnstar" = trinket_safelist,
	"petperson" = filtered_concrete_typesof(/mob/living/critter/small_animal/, GLOBAL_PROC_REF(filter_carrier_pets)),
	"lunchbox" = childrentypesof(/obj/item/storage/lunchbox),
	"loyalist" = list(/obj/item/clothing/head/NTberet, /obj/item/clothing/head/NTberet/commander),
	"conspiracytheorist" = list(/obj/item/clothing/head/tinfoil_hat),
	"beestfriend" = list(/obj/item/reagent_containers/food/snacks/ingredient/egg/bee/buddy),
	"bald" = list(/obj/item/reagent_containers/pill/hairgrownium, /obj/item/clothing/head/wig/spawnable),
	"pilot" = concrete_typesof(/obj/item/pod/paintjob) + list(/obj/item/pod/frame_box),
	"sleepy" = list(/obj/item/reagent_containers/ampoule/smelling_salts, /obj/item/clothing/suit/bedsheet/random, /obj/item/furniture_parts/bed),
	"partyanimal" = concrete_typesof(/obj/item/reagent_containers/food/drinks/bottle) + list(/obj/item/clothing/head/party/random),
	"jailbird" = list(/obj/item/paper/newspaper/rolled, /obj/item/clothing/mask/moustache, /obj/item/clothing/glasses/sunglasses),
	"burning" = list(/obj/item/extinguisher, /obj/item/storage/firstaid/fire),
	"carpenter" = concrete_typesof(/obj/item/furniture_parts),
	"allears" = list(/obj/item/device/radio/headset/civilian, /obj/item/device/radio/headset/research, /obj/item/device/radio/headset/engineer),
	"skeleton" = list(/obj/item/reagent_containers/food/drinks/milk, /obj/item/joint_wax),
	"pug" = list(/obj/item/reagent_containers/food/snacks/cookie/dog),
	"picky_eater" = list(/obj/item/reagent_containers/food/snacks), // Extra logic for determining favorite food
	"deaf" = list(/obj/item/device/radio/headset/deaf),
	"blind" = list(/obj/item/clothing/glasses/visor),
	"shortsighted" = list(/obj/item/clothing/glasses/regular),
	"nolegs" = list(/obj/item/furniture_parts/wheelchair, /obj/item/parts/robot_parts/leg/left/light, /obj/item/parts/robot_parts/leg/right/light),
	"plasmalungs" = list(/obj/item/tank/mini_plasma),
	"scottish" = list(/obj/item/instrument/bagpipe, /obj/item/clothing/under/gimmick/kilt,
		/obj/item/reagent_containers/food/snacks/haggis, /obj/item/reagent_containers/food/snacks/scotch_egg
	),
	"french" = concrete_typesof(/obj/item/clothing/head/frenchberet) + list(/obj/item/baguette,
		/obj/item/reagent_containers/food/snacks/ingredient/cheese, /obj/item/reagent_containers/food/snacks/croissant,
		/obj/item/reagent_containers/food/snacks/painauchocolat
	),
	"german" = list(/obj/item/reagent_containers/food/snacks/ingredient/egg/chocolate, /obj/item/reagent_containers/food/snacks/danish_apple,
		/obj/item/reagent_containers/food/snacks/danish_cherry, /obj/item/reagent_containers/food/snacks/danish_blueb
	),
	"elvis" = list(/obj/item/reagent_containers/food/snacks/breadloaf/elvis), // I'm sure the 1 guy using this trait will be happy about this
	"swedish" = list(/obj/item/reagent_containers/food/snacks/swedish_fish, /obj/item/reagent_containers/food/snacks/swedishmeatball),
	"allergy" = list(/obj/item/reagent_containers/emergency_injector/epinephrine)
)

// =========================================================================
// Items given out to anyone, either when they have no job items or randomly
var/global/mail_types_everyone = list(
#ifdef XMAS
    /obj/item/spacemas_card = 25,
#endif
	/obj/item/a_gift/festive = 4,
	/obj/item/reagent_containers/food/drinks/drinkingglass/random_style/filled/sane = 4,
	/obj/item/reagent_containers/food/snacks/donkpocket_w = 2,
	/obj/item/reagent_containers/food/snacks/donkpocket/warm = 5,
	/obj/item/reagent_containers/food/drinks/cola = 6,
	/obj/item/reagent_containers/food/snacks/candy/chocolate = 6,
	/obj/item/reagent_containers/food/snacks/chips = 6,
	/obj/item/reagent_containers/food/snacks/popcorn = 6,
	/obj/item/reagent_containers/food/snacks/candy/lollipop/random_medical = 5,
	/obj/item/tank/emergency_oxygen = 5,
	/obj/item/wrench = 4,
	/obj/item/crowbar = 4,
	/obj/item/screwdriver = 4,
	/obj/item/weldingtool = 4,
	/obj/item/device/radio = 1,
	/obj/item/currency/spacecash/small = 6,
	/obj/item/currency/spacecash/tourist = 3,
	/obj/item/coin = 2,
	/obj/item/pen/fancy = 3,
	/obj/item/toy/plush = 2,
	/obj/item/toy/figure = 3,
	/obj/item/toy/gooncode = 1,
	/obj/item/toy/cellphone = 1,
	/obj/item/toy/ornate_baton = 3,
	/obj/item/toy/handheld/robustris = 1,
	/obj/item/toy/handheld/arcade = 1,
	/obj/item/paint_can/rainbow = 4,
	/obj/item/paint_can/rainbow/plaid = 2,
	/obj/item/device/light/glowstick = 4,
	/obj/item/clothing/glasses/vr/arcade = 2,
	/obj/item/device/light/zippo = 4,

	// mostly taken from gangwar as a "relatively safe list of random hats"
	/obj/item/clothing/head/biker_cap = 1,
	/obj/item/clothing/head/cakehat = 1,
	/obj/item/clothing/head/chav = 1,
	/obj/item/clothing/head/flatcap = 1,
	/obj/item/clothing/head/formal_turban = 1,
	/obj/item/clothing/head/genki = 1,
	/obj/item/clothing/head/helmet/batman = 1,
	/obj/item/clothing/head/helmet/bobby = 1,
	/obj/item/clothing/head/helmet/viking = 1,
	/obj/item/clothing/head/helmet/welding = 1,
	/obj/item/clothing/head/mailcap = 1,
	/obj/item/clothing/head/mj_hat = 1,
	/obj/item/clothing/head/NTberet = 1,
	/obj/item/clothing/head/pinkwizard = 1,
	/obj/item/clothing/head/powdered_wig = 1,
	/obj/item/clothing/head/psyche = 1,
	/obj/item/clothing/head/pumpkin = 1,
	/obj/item/clothing/head/purplebutt = 1,
	/obj/item/clothing/head/rastacap = 1,
	/obj/item/clothing/head/rhinobeetle = 1,
	/obj/item/clothing/head/snake = 1,
	/obj/item/clothing/head/stagbeetle = 1,
	/obj/item/clothing/head/that = 1,
	/obj/item/clothing/head/that/purple = 1,
	/obj/item/clothing/head/turban = 1,
	/obj/item/clothing/head/waldohat = 1,
	/obj/item/clothing/head/westhat/black = 1,
	/obj/item/clothing/head/wizard = 1,
	/obj/item/clothing/head/wizard/green = 1,
	/obj/item/clothing/head/wizard/necro = 1,
	/obj/item/clothing/head/wizard/purple = 1,
	/obj/item/clothing/head/wizard/red = 1,
	/obj/item/clothing/head/wizard/witch = 1,
	/obj/item/clothing/head/XComHair = 1,
	/obj/item/clothing/head/mushroomcap/random = 4, // i am biased
	)

