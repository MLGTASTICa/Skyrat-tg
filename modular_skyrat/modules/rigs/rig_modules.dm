/obj/item/rig_module
	icon = ''
	icon_state = ""
	obj_integrity = 250
	w_class = WEIGHT_CLASS_SMALL
	/// If the item is emagged
	var/emagged
	/// Cooldown for the use of this moduless ability
	var/cooldown
	/// Power usage when we fire it or use it
	var/use_power
	/// Power usage when its sitting doing nothing
	var/idle_power_use
	/// If it got destroyed by an EMP or ruined
	var/fried


/obj/item/rig_module/proc/add_ability(obj/item/rig_suit/target)

/obj/item/rig_module/proc/remove_ability(obj/item/rig_suit/target)

/obj/item/rig_module/emp_act(severity)
	. = ..()

/obj/item/rig_module/emag_act(mob/user, obj/item/card/emag/E)
	. = ..()

/obj/item/rig_module/attackby(obj/item/I, mob/living/user, params)
	. = ..()

