/obj/item/roboupgrade/windup
	name = "cyborg kinetic priming upgrade"
	desc = "An old looking upgrade that attaches a kinetic primer to the cyborg, allowing for manual charging."
	icon_state = "up-windup"
	var/actual_name = "kinetic primer"
	var/charge_rate = 200
	var/windup_duration = 1 SECONDS

	upgrade_activate(mob/living/silicon/robot/user)
		if (!user)
			return ROBOT_UPGRADE_FAIL_DISABLED
		if(user.hasStatus("upgrade_disabled") || user.hasStatus("lockdown_robot") || user.hasStatus("no_cell_robot"))
			boutput(user, SPAN_ALERT("Your modules are currently disabled!"))
			return ROBOT_UPGRADE_FAIL_DISABLED
		if (!src.activated && !src.active)
			src.activated = TRUE
			boutput(user, "[src] has been activated. You can now be manually charged.")
		APPLY_ATOM_PROPERTY(user, PROP_MOB_CAN_BE_CRANKED, src)

	upgrade_deactivate(mob/living/silicon/robot/user)
		if (!user)
			return TRUE
		src.activated = FALSE
		boutput(user, "[src] has been deactivated. You can no longer be manually charged.")
		REMOVE_ATOM_PROPERTY(user, PROP_MOB_CAN_BE_CRANKED, src)

	proc/start_charging(mob/user, mob/living/silicon/robot/target)
		var/obj/item/cell/C = target.cell
		logTheThing(LOG_STATION, user, "[user] starts manually charging [target].")
		if (C.charge == C.maxcharge)
			boutput(user, "[src] is fully charged, there's no need to crank its [src.actual_name]!")
		else
			user.visible_message(SPAN_NOTICE("[user] starts cranking [target]'s [src.actual_name]."))
			actions.start(new /datum/action/bar/icon/windup_action(src, user, target, C, src.windup_duration), user)

/datum/action/bar/icon/windup_action
	id = "windup_action"
	duration = 1 SECOND
	interrupt_flags = INTERRUPT_ACT | INTERRUPT_STUNNED | INTERRUPT_ACTION | INTERRUPT_MOVE
	icon = 'icons/obj/robot_parts.dmi'
	icon_state = "up-windup"
	var/obj/item/crank
	var/mob/user
	var/mob/target
	var/obj/item/cell/cell

	New(crank, user, target, cell, duration)
		. = ..()
		src.crank = crank
		src.user = user
		src.target = target
		src.cell = cell
		src.duration = duration
		src.icon = src.crank.icon
		src.icon_state = src.crank.icon_state

	proc/checkContinue()
		if(!src.cell || src.cell.charge >= src.cell.maxcharge || BOUNDS_DIST(src.user, src.target) > 0 || src.user == null || src.target == null)
			return FALSE
		return TRUE

	onUpdate()
		..()
		if(!checkContinue())
			interrupt(INTERRUPT_ALWAYS)
			return

	loopStart()
		..()
		var/charge_rate = crank:charge_rate ? crank:charge_rate : 200
		src.cell.give(charge_rate)
		target.changeStatus("kineticcharging", src.duration, optional=null)
		playsound(target, 'sound/machines/windup.ogg', 50, TRUE)

	onStart()
		..()
		if(!checkContinue())
			interrupt(INTERRUPT_ALWAYS)
			return
		src.loopStart()

	onEnd()
		. = ..()
		src.onRestart()