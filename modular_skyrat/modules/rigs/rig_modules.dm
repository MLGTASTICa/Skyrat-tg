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
	var/cooldown = 50
	/// Power usage when we fire it or use it
	var/use_power = 0
	/// Var for keeping track of time don't edit
	var/cooldown_timer
	/// Power usage when its sitting doing nothing
	var/idle_power_use = 0
	// Power usage when we fire it , for one time actions
	var/fire_power_use = 0
	/// If it got destroyed by an EMP or ruined
	var/fried
	/// ability to add
	var/datum/action/rig_module/action = /datum/action/rig_module/

/obj/item/rig_module/proc/add_ability(obj/item/rig_suit/target)
	if(!action)
		action = new action(src)
	action.Grant(target.wearer)
	action.module = src
	action.rig = target

/obj/item/rig_module/proc/remove_ability(obj/item/rig_suit/target)
	action.Remove(target.wearer)


/obj/item/rig_module/emag_act(mob/user, obj/item/card/emag/E)
	. = ..()

/obj/item/rig_module/attackby(obj/item/I, mob/living/user, params)
	. = ..()
/*
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
*/

/datum/action/rig_module
	name = "Deploy module"
	desc = "Deploy a module."
	check_flags = AB_CHECK_CONSCIOUS
	background_icon_state = "bg_agent"
	icon_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "deploy_box"
	var/obj/item/rig_suit/rig
	var/obj/item/rig_module/module
	var/dispenser = FALSE

///Handles module stuff!
/datum/action/rig_module/Trigger()
	if(!rig.powered)
		return FALSE
	if(world.time < module.cooldown_timer)
		return FALSE
	if(!rig.use_power(module.fire_power_use))
		return FALSE
	to_chat(rig.wearer, text = "Module activated succesfully")
	module.cooldown_timer = world.time + module.cooldown

/obj/item/rig_module/reagent
	name = "Combat injector module"
	desc = "Adds a reagent from a beaker of your choice into your bloodstream!"
	fire_power_use = 300

/obj/item/rig_module/reagent/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 5
	STR.max_items = 5
	STR.insert_preposition = "in"
	STR.set_holdable(list(
		/obj/item/reagent_containers/glass/beaker,
		/obj/item/reagent_containers/glass/bottle,
		/obj/item/reagent_containers/food/drinks/waterbottle,
		/obj/item/reagent_containers/food/condiment,
	))
/datum/action/rig_module/reagent
	name = "Reagent injector"
	desc = "I swear its not black powder!"



