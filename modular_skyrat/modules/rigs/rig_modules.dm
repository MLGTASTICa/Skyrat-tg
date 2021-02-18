/obj/item/rig_module
	icon = 'modular_skyrat/modules/rigs/rig_sprites.dmi'
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
	/// ability to add
	var/obj/effect/proc_holder/rig_suit/proc


/obj/item/rig_module/proc/add_ability(obj/item/rig_suit/target)
	target.wearer.AddAbility(proc)

/obj/item/rig_module/proc/remove_ability(obj/item/rig_suit/target)
	target.wearer.RemoveAbility(proc)

/obj/item/rig_module/emag_act(mob/user, obj/item/card/emag/E)
	. = ..()

/obj/item/rig_module/attackby(obj/item/I, mob/living/user, params)
	. = ..()
/obj/effect/proc_holder/rig_suit
	name = "Rig deploy"
	desc = "Deploy a module"
	active = 0
	var/power_cost
	action_icon_state = ""
	base_action = /datum/action/item_action/rig_module
/datum/action/item_action/rig_module
	name = "Deploy module"
	desc = "Deploy a module."
	check_flags = AB_CHECK_CONSCIOUS
	background_icon_state = "bg_agent"
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "deploy_box"

///Handles opening and closing themodule
/datum/action/item_action/rig_module/Trigger()
	to_chat(owner, text = "Mors")
