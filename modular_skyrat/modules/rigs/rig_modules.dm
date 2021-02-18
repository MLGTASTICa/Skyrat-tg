/obj/item/rig_module
	name = "Rig module"
	desc = "a motherfucking module"
	icon = 'modular_skyrat/modules/rigs/rig_sprites.dmi'
	icon_state = ""
	obj_integrity = 250
	w_class = WEIGHT_CLASS_SMALL
	/// Is it active????????
	var/active
	/// If the item is emagged
	var/emagged
	/// Cooldown for the use of this moduless ability
	var/cooldown
	/// Power usage when we fire it or use it
	var/use_power
	/// Power usage when its sitting doing nothing
	var/idle_power_use
	// Power usage when we fire it , for one time actions
	var/fire_power_use
	/// If it got destroyed by an EMP or ruined
	var/fried
	/// ability to add
	var/obj/effect/proc_holder/rig_suit/proc_handle = /obj/effect/proc_holder/rig_suit

/obj/item/rig_module/proc/add_ability(obj/item/rig_suit/target)
	var/obj/effect/proc_holder/rig_suit/proc_handle_temporary = new proc_handle(src)
	target.wearer.AddAbility(proc_handle_temporary)

/obj/item/rig_module/proc/remove_ability(obj/item/rig_suit/target)
	target.wearer.RemoveAbility(proc_handle)

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
	base_action = /datum/action/rig_module // ONLY RIG MODULES IN HERE I SWEAR TO GOD IF YOU PUT ONE THAT IS NOT A RIG IT WILL FUCK UP

/obj/effect/proc_holder/fire(mob/living/user)
	var/datum/action/rig_module/rig_action = base_action
	if(!(rig_action.rig.powered))
		return FALSE

/datum/action/rig_module
	name = "Deploy module"
	desc = "Deploy a module."
	check_flags = AB_CHECK_CONSCIOUS
	background_icon_state = "bg_agent"
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "deploy_box"
	var/obj/item/rig_suit/rig

/datum/action/rig_module/New(Target)
	. = ..()
	rig = target

///Handles opening and closing the module
/datum/action/rig_module/Trigger()
	to_chat(owner, text = "Mors")
