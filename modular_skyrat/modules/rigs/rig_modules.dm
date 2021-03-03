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
	/// Under PAI control at this moment?
	var/PAI_control = FALSE
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
	emagged = 1

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
	actions_to_add = list(/datum/action/rig_module/reagent/inject)

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
	if(!module_handler.selected_beaker)
		return to_chat(rig.wearer, text ="No beaker selected!")
	module_handler.selected_beaker.reagents.trans_to(rig.wearer, 20)

/datum/action/rig_module/reagent/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	to_chat(user, text = "called ui interact")
	if(!ui)
		ui = new(user, src, "RIGModuleReagent", name)
		ui.open()

/datum/action/rig_module/reagent/ui_data(mob/user)
	var/list/data = list()
	var/counter = 0
	for(var/obj/item/reagent_containers/beaker in module.contents)
		var/reagent_name = beaker.reagents.get_master_reagent_name()
		counter++
		var/list/handle = list()
		handle["reg_name"] = reagent_name
		handle["reg_id"] = counter
		var/obj/item/rig_module/reagent/handler = module
		if(handler.selected_beaker == beaker)
			handle["reg_color"] = "green"
		else
			handle["reg_color"] = "blue"
		data["reagents"] += list(handle)

	return data

/datum/action/rig_module/reagent/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("pick")
			var/id = params["identifier"]
			var/obj/item/rig_module/reagent/handle = module
			handle.selected_beaker = module.contents[id]

/datum/action/rig_module/reagent/ui_state()
	if(!rig.powered || module.fried || module.PAI_control)
		return UI_UPDATE
	if(!rig.wearer)
		return UI_CLOSE
	return UI_INTERACTIVE

/obj/item/rig_module/targeted
	name = "Targetting system"
	desc = "The missile knows where it is by knowing where it isn't"
	actions_to_add = list(/datum/action/rig_module/targeted)

/datum/action/rig_module/targeted
	name = "Toggle a targeted ability"
	desc = "Blast the fucking clown off."
	/// What kind of projectile do we make ? its typepath.
	var/selected_projtype = null
	var/normal_firecost = 200
	var/emagged_firecost = 500
	var/list/projectiles = list(/obj/projectile/beam/laser, "Laser", /obj/projectile/beam/disabler, "Disabler")
	var/list/emag_projectiles = list(/obj/projectile/beam/laser/heavylaser, "Overcharged Laser")

/datum/action/rig_module/targeted/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	to_chat(user, text = "called ui interact")
	if(!ui)
		ui = new(user, src, "RIGModuleTargeted", name)
		ui.open()

/datum/action/rig_module/targeted/ui_data(mob/user)
	var/list/data = list()
	var/emag_counter = emag_projectiles.len
	var/special_counter = projectiles.len
	data["projectiles"] = list()
	while(special_counter)
		var/list/special_proj = list()
		//var/obj/projectile/handle = projectiles[special_counter]
		special_proj["proj_name"] = projectiles[special_counter]
		special_proj["proj_id"] = special_counter - 1
		special_proj["proj_emag"] = FALSE
		if(selected_projtype == projectiles[special_counter - 1])
			special_proj["proj_color"] = "green"
		else
			special_proj["proj_color"] = "blue"
		data["projectiles"] += list(special_proj)
		special_counter-= 2
	if(module.emagged)
		while(emag_counter)
			var/list/emag_proj = list()
			emag_proj["proj_name"] = emag_projectiles[emag_counter]
			emag_proj["proj_id"] = emag_counter - 1
			emag_proj["proj_emag"] = TRUE
			if(selected_projtype == emag_projectiles[emag_counter - 1])
				emag_proj["proj_color"] = "green"
			else
				emag_proj["proj_color"] = "red"
			data["projectiles"] += list(emag_proj)
			emag_counter-= 2

	return data

	/*counter = emag_projectiles.len
	while(counter)
		var/obj/projectile/proj_emag = emag_projectiles[counter]
		counter++
		var/list/emag_proj = list()
		emag_proj["name"] = proj_emag.name
		emag_proj["id"] = counter
		emag_proj["emagged"] = TRUE
		data["emag_projectiles"] += list(emag_proj)
		counter--*/

/datum/action/rig_module/targeted/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("pick")
			var/counter = params["identifier"]
			var/magged = params["emagged"]
			if(magged)
				selected_projtype = emag_projectiles[counter]
			else
				selected_projtype = projectiles[counter]

/datum/action/rig_module/targeted/ui_state()
	if(!rig.powered || module.fried || module.PAI_control)
		return UI_UPDATE
	if(!rig.wearer)
		return UI_CLOSE
	return UI_INTERACTIVE

/datum/action/rig_module/targeted/custom_trigger()
	. = ..()
	if(module.active)
		UnregisterSignal(rig.wearer, COMSIG_MOB_MIDDLECLICKON)
		name = "Toggle targetting on"
		module.active = FALSE
	else
		RegisterSignal(rig.wearer, COMSIG_MOB_MIDDLECLICKON, .proc/on_middle_click_rig)
		name = "Toggle targetting off"
		module.active = TRUE


/datum/action/rig_module/targeted/proc/on_middle_click_rig(mob/user, atom/target)
	SIGNAL_HANDLER
	if(!ispAI(user) || !user.stat == CONSCIOUS)
		return NONE
	rig.wearer.swap_hand()
	if(selected_projtype)
		if(emag_projectiles.Find(selected_projtype))
			if(!rig.use_power(emagged_firecost))
				return NONE
		if(projectiles.Find(selected_projtype))
			if(!rig.use_power(normal_firecost))
				return NONE
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

/obj/item/rig_module/targeted_ballistic
	name = "Ballistic targetting system"
	desc = "Put ammo in this shitty module and shoot it at the captain."
	var/ammo_calibers = list(CALIBER_712X82MM,CALIBER_10MM,CALIBER_357)
	var/ammo_amount = list()
	var/selected_projtype = null
	actions_to_add = list(/datum/action/rig_module/targeted_ballistic)

/obj/item/rig_module/targeted_ballistic/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete)
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 40
	STR.max_items = 10
	STR.insert_preposition = "in"
	STR.set_holdable(list(
		/obj/item/ammo_box,
		/obj/item/ammo_casing))

/obj/item/rig_module/targeted_ballistic/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_STORAGE_ITEM_INSERTED, .proc/ammo_calculate)

/obj/item/rig_module/targeted_ballistic/proc/ammo_calculate()
	var/obj/item/rig_module/targeted_ballistic/module_handle = src
	for(var/obj/item/potential_box in contents)
		if(istype(potential_box, /obj/item/ammo_box))
			var/obj/item/ammo_box/box = potential_box
			var/counter = module_handle.ammo_calibers.len
			while(counter)
				if(box.ammo_type == module_handle.ammo_calibers[counter])
					for(var/obj/item/ammo_casing/bullet in box.stored_ammo)
						if(!(bullet.loaded_projectile))
							return FALSE
						if(module_handle.ammo_amount.Find(bullet,1,0))
							var/spot = module_handle.ammo_amount.Find(bullet,1,0)
							module_handle.ammo_amount[spot+1] = module_handle.ammo_amount[spot+1] + 1
							return
						module_handle.ammo_amount += bullet
						module_handle.ammo_amount += bullet.caliber
					box.update_appearance()
			counter--

/datum/action/rig_module/targeted_ballistic
	name = "Toggle ballistic annihilation"
	desc = "Merge before balance checks"

/datum/action/rig_module/targeted_ballistic/custom_trigger()
	. = ..()
	if(module.active)
		UnregisterSignal(rig.wearer, COMSIG_MOB_MIDDLECLICKON)
		name = "Toggle targetting on"
		module.active = FALSE
	else
		RegisterSignal(rig.wearer, COMSIG_MOB_MIDDLECLICKON, .proc/on_middle_click_rig)
		name = "Toggle targetting off"
		module.active = TRUE

/datum/action/rig_module/targeted_ballistic/proc/on_middle_click_rig(mob/user, atom/target)
	SIGNAL_HANDLER
	var/obj/item/rig_module/targeted_ballistic/module_handle = module
	if(!ispAI(user) || !user.stat == CONSCIOUS)
		return NONE
	rig.wearer.swap_hand()
	if(module_handle.selected_projtype)
		var/spot = module_handle.ammo_amount.Find(selected_projtype,1,0)
		var/ammo_count = module_handle.ammo_amount[spot+1]
		if(!ammo_count)
			return FALSE
		var/obj/projectile/P = new module_handle.selected_projtype(rig.wearer)
		module_handle.ammo_amount[spot+1] = ammo_count - 1
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
	var/tool_to_deploy = /obj/item/analyzer
	var/active = FALSE
	var/obj/item/tool_reference = null

/datum/action/rig_module/deploy_tool/custom_trigger()
	. = ..()
	if(!active)
		if(!tool_reference)
			var/obj/item/item_to_place = new tool_to_deploy(src)
			ADD_TRAIT(item_to_place, TRAIT_NODROP, "RIG Module")
			tool_reference = item_to_place
		active = TRUE
		rig.wearer.put_in_hands(tool_reference)
	else
		tool_reference.moveToNullspace()
		active = FALSE

/*
Laser Modules!
*/
/obj/item/rig_module/targeted/laser
	name = "All-star C4 Laser module"
	desc = "A very compact module installed with a high-performance compact laser"
	actions_to_add = list(/datum/action/rig_module/targeted/laser)
	cooldown = 1 SECONDS

/datum/action/rig_module/targeted/laser
	name = "Toggle All-star C4 carbine module"
	desc = "An extremly powerfull module , being capable of firing lasers of extreme power at low costs."
	projectiles = list(/obj/projectile/beam/laser, "Laser", /obj/projectile/beam/disabler, "Disabler", /obj/projectile/beam/laser/heavylaser , "Overcharged Laser")
	emag_projectiles = list(/obj/projectile/beam/laser/accelerator, "Acceletor Cannon", /obj/projectile/beam/laser/hellfire, "Hellfire laser")
	normal_firecost = 100
	emagged_firecost = 200

/obj/item/rig_module/targeted/laser_weak
	name = "All-star C5 Laser module"
	desc = "A very compact module installed with a a low performance laser"
	actions_to_add = list(/datum/action/rig_module/targeted/laser_weak)
	cooldown = 1  SECONDS * 1.25

/datum/action/rig_module/targeted/laser_weak
	name = "Toggle All-star C5 carbine module"
	desc = "Laser go brr"
	projectiles = list(/obj/projectile/beam/disabler, "Disabler")
	emag_projectiles = list(/obj/projectile/beam/laser, "Laser")
	normal_firecost = 200
	emagged_firecost = 250

/obj/item/rig_module/targeted/disabler_minigun
	name = "KER-6 Disabler module"
	desc = "A experimental disabler laser minigun."
	cooldown = 1 SECONDS * 0.25
/datum/action/rig_module/targeted/disabler
	name = "Toggle KER-6 Disabler module"
	desc = "Laser go brr"
	projectiles = list(/obj/projectile/beam/disabler, "Disabler")
	emag_projectiles = list(/obj/projectile/beam/laser, "Laser")
	normal_firecost = 150
	emagged_firecost = 250
/*
Ballistic modules
*/






/*
Reagent modules
*/

/*
Melle modules
*/
