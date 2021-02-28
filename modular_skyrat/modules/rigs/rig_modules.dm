/obj/item/rig_module
	name = "Rig module"
	desc = "a motherfucking module"
	icon = 'modular_skyrat/modules/rigs/rig_sprites.dmi'
	icon_state = "rig_back_default"
	obj_integrity = 250
	w_class = WEIGHT_CLASS_SMALL
	/// This module requires a part of the suit to be deployed, 1-head 2-suit 3-gloves 4-boots
	var/linked_to = 2
	/// How much does this module weight ? used as a balance factor in how many modules one can have
	var/weight = 1
	/// Is it active????????
	var/active = FALSE
	/// If the item is emagged
	var/emagged = FALSE
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
	var/fried = FALSE
	/// Eee
	var/list/actions_to_add = list(/datum/action/rig_module, /datum/action/rig_module)
	/// This is the action storage, adding actions is handled in the item initialize
	var/list/datum/action/rig_module/action_storage = list()
	var/obj/item/rig_suit/rig = null

/// Handle your actions here
/obj/item/rig_module/Initialize()
	. = ..()
	var/special_counter = actions_to_add.len
	while(special_counter>0)
		var/datum/action/rig_module/to_add = actions_to_add[special_counter]
		var/datum/action/rig_module/handle = new to_add(src)
		handle.module = src
		handle.linked_to = linked_to
		action_storage.Add(handle)
		special_counter--

/obj/item/rig_module/proc/add_ability(obj/item/rig_suit/target)
	for(var/datum/action/rig_module/module_handle in action_storage)
		module_handle.Grant(target.wearer)
		module_handle.rig = target
		rig = target

/obj/item/rig_module/proc/remove_ability(obj/item/rig_suit/target)
	for(var/datum/action/rig_module/action_remove in action_storage)
		action_remove.Remove(target.wearer)

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
	var/linked_to

/// So we can freely parent call this proc for all the checks AND not have to deal with the trigger runtimes afterwards from the other parents
/datum/action/rig_module/Trigger()
	custom_trigger()

/datum/action/rig_module/proc/custom_trigger()
	var/obj/item/clothing/rig_suit_holder/holder = rig.suit_pieces[linked_to]
	if(holder.deployed == FALSE)
		to_chat(rig.wearer, text = "The module tries to do its act , but the suit pieces its linked to is not deployed!")
		return FALSE
	if(!rig.powered)
		return FALSE
	if(world.time < module.cooldown_timer)
		return FALSE
	if(!rig.use_power(module.fire_power_use))
		return FALSE
	if(module.fried)
		to_chat(rig.wearer, text = "You try to active the module , but it stops with a sharp electric buzz!")
		return FALSE
	to_chat(rig.wearer, text = "Module activated succesfully")
	module.cooldown_timer = world.time + module.cooldown


/obj/item/rig_module/reagent
	name = "Combat injector module"
	desc = "Adds a reagent from a beaker of your choice into your bloodstream!"
	fire_power_use = 300
	/// The beaker we will inject from
	var/obj/item/reagent_containers/selected_beaker = null
	actions_to_add = list(/datum/action/rig_module/reagent/inject, /datum/action/rig_module/reagent/next)

/obj/item/rig_module/reagent/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete)
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
/datum/action/rig_module/reagent/inject
	name = "Inject reagents"
	desc = "I swear its not black powder!"

/datum/action/rig_module/reagent/inject/custom_trigger()
	. = ..()
	var/obj/item/rig_module/reagent/module_handler = module
	if(!module_handler.contents)
		return to_chat(rig.wearer, text = "No beakers inside the module!")
	if(!module_handler.selected_beaker)
		return to_chat(rig.wearer, text ="No beaker selected!")
	module_handler.selected_beaker.reagents.trans_to(rig.wearer, 20)

/datum/action/rig_module/reagent/next
	name = "Switch beaker"
	desc = "Switch to the next beaker of rage-inducing drugs"

/datum/action/rig_module/reagent/next/custom_trigger()
	. = ..()
	var/obj/item/rig_module/reagent/module_handler = module
	if(!module_handler.contents)
		return to_chat(rig.wearer, text = "No beakers inside the module!")
	if(!module_handler.selected_beaker)
		module_handler.selected_beaker = module.contents[1]
	var/counter = module_handler.contents.Find(module_handler.selected_beaker,1,0)
	if(counter == module_handler.contents.len)
		counter = 1
	else
		counter++
	module_handler.selected_beaker = module.contents[counter]
	var/reagent_name = module_handler.selected_beaker.reagents.get_master_reagent_name()
	to_chat(rig.wearer, text = "Beaker selected with [reagent_name]")

/obj/item/rig_module/targeted
	name = "Targetting system"
	desc = "The missile knows where it is by knowing where it isn't"
	actions_to_add = list(/datum/action/rig_module/targeted)


/datum/action/rig_module/targeted
	name = "Toggle a targeted ability"
	desc = "Blast the fucking clown off."
	var/toggled = FALSE
	/// What kind of projectile do we make ? its typepath.
	var/selected_projtype = null
	var/list/projectiles = list(/obj/projectile/beam/laser, /obj/projectile/beam/disabler)
	var/list/emag_projectiles = list(/obj/projectile/beam/laser/heavylaser)

/datum/action/rig_module/targeted/custom_trigger()
	. = ..()
	if(toggled)
		UnregisterSignal(rig.wearer, COMSIG_MOB_MIDDLECLICKON)
		name = "Toggle targetting on"
		toggled = FALSE
	else
		RegisterSignal(rig.wearer, COMSIG_MOB_MIDDLECLICKON, .proc/on_middle_click_rig)
		name = "Toggle targetting off"
		toggled = TRUE


/datum/action/rig_module/targeted/proc/on_middle_click_rig(mob/user, atom/target)
	SIGNAL_HANDLER
	rig.wearer.swap_hand()
	if(selected_projtype)
		var/obj/projectile/P = new selected_projtype(rig.wearer)
		P.starting = rig.wearer.loc
		P.firer = rig.wearer
		P.fired_from = rig
		P.yo = target.y - rig.wearer.loc.y
		P.xo = target.x - rig.wearer.loc.x
		P.original = target
		P.preparePixelProjectile(target, rig.wearer)
		INVOKE_ASYNC(P, /obj/projectile.proc/fire)
		return NONE

/obj/item/rig_module/tool_deploy
	name = "XS-7 Tactical analyzing module"
	desc = "What do the numbers mean"
	actions_to_add = list(/datum/action/rig_module/deploy_tool)
/datum/action/rig_module/deploy_tool
	name = "Deploy a tool"
	desc = "Deploys a tol"
	var/tool = /obj/item/analyzer
	var/active = FALSE

/datum/action/rig_module/deploy_tool/custom_trigger()
	. = ..()
	if(!active)
		var/obj/item/item_to_place = new tool(src)
		active = TRUE
		rig.wearer.put_in_hands(item_to_place)
		ADD_TRAIT(item_to_place, STICKY_NODROP, "RIG Module")


/obj/item/rig_module/targeted/laser
	name = "All-star C4 Laser module"
	desc = "A very compact module installed with a high-performance compact laser"
	actions_to_add = list(/datum/action/rig_module/targeted/laser)

/datum/action/rig_module/targeted/laser
	name = "Toggle All-star C4 carbine module"
	desc = "Laser go brr"

/datum/action/rig_module/targeted/laser/on_middle_click(mob/user, atom/target)
	SIGNAL_HANDLER
	var/obj/projectile/P = new /obj/projectile/beam/laser/heavylaser(get_turf(rig.wearer))
	P.starting = rig.wearer.loc
	P.firer = rig.wearer
	P.fired_from = rig
	P.yo = target.y - rig.wearer.loc.y
	P.xo = target.x - rig.wearer.loc.x
	P.original = target
	P.preparePixelProjectile(target, rig.wearer)
	P.fire()
	rig.wearer.swap_hand()
	return P



/*
Laser Modules!
*/
/obj/item/rig_module/targeted/laser
	name = "All-star C4 Laser module"
	desc = "A very compact module installed with a high-performance compact laser"
	actions_to_add = list(/datum/action/rig_module/targeted/laser)

/datum/action/rig_module/targeted/laser
	name = "Toggle All-star C4 carbine module"
	desc = "Laser go brr"
	selected_projtype = /obj/projectile/beam/laser/heavylaser

/obj/item/rig_module/targeted/laser_weak
	name = "All-star C5 Laser module"
	desc = "A very compact module installed with a a low performance laser"
	actions_to_add = list(/datum/action/rig_module/targeted/laser_weak)

/datum/action/rig_module/targeted/laser_weak
	name = "Toggle All-star C5 carbine module"
	desc = "Laser go brr"
	selected_projtype = /obj/projectile/beam/laser

/obj/item/rig_module/targeted/disabler
	name = "Armadyne KER-6 Disabler module"
	desc = "A very compact module installed with a peformant disabler!"
	actions_to_add = list(/datum/action/rig_module/targeted/disabler)

/datum/action/rig_module/targeted/disabler
	name = "Toggle KER-6 Disabler module"
	desc = "Laser go brr"
	selected_projtype = /obj/projectile/beam/disabler
/*
Ballistic modules
*/






/*
Reagent modules
*/

/*
Melle modules
*/
