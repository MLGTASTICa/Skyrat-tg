/obj/item/rig_module
	name = "Rig module"
	desc = "a motherfucking module"
	icon = 'modular_skyrat/modules/rigs/icons/rig_sprites.dmi'
	icon_state = "rig_back_default"
	obj_integrity = 250
	w_class = WEIGHT_CLASS_SMALL
	/// This module requires a part of the suit to be deployed, 1-head 2-suit 3-gloves 4-boots
	var/linked_to = 2
	/// How much does this module weight ? used as a balance factor in how many modules one can have
	var/weight = 1
	/// Is it active????????
	var/active = FALSE
	/// Another var , but if its firing
	var/firing = FALSE
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
	/// Can be PAI cntrolled?
	var/PAI_control = FALSE
	/// is the Pai currently coltrolling this?
	var/PAI_active = FALSE
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
		action_remove.HandleRemoval(target.wearer)

/datum/action/rig_module/proc/HandleRemoval(mob/living/user)
	return FALSE

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
	button_icon = 'modular_skyrat/modules/rigs/icons/rig_actions.dmi'
	background_icon_state = "rig_bg_default"
	icon_icon = 'modular_skyrat/modules/rigs/icons/rig_actions.dmi'
	button_icon_state = "rig_inject"
	var/obj/item/rig_suit/rig
	var/obj/item/rig_module/module
	var/linked_to

/// So we can freely parent call this proc for all the checks AND not have to deal with the trigger runtimes afterwards from the other parents
/datum/action/rig_module/Trigger()
	var/obj/item/clothing/rig_suit_holder/holder = rig.suit_pieces[linked_to]
	if(!(holder.deployed))
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
	custom_trigger()

/datum/action/rig_module/proc/custom_trigger()
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
	var/spread = 1

/datum/action/rig_module/targeted
	name = "Toggle a targeted ability"
	desc = "Blast the fucking clown off."
	/// What kind of projectile do we make ? its typepath.
	var/selected_projtype = null
	var/emagged_firecost = 500
	var/normal_firecost = 200
	var/list/projectiles = list(/obj/projectile/beam/laser, "Laser", /obj/projectile/beam/disabler, "Disabler")
	var/list/emag_projectiles = list(/obj/projectile/beam/laser/heavylaser, "Overcharged Laser")
	var/list/firemodes = list(1,3,5)
	var/firemode = 1
	var/fire_rate = 0.25 SECONDS

/datum/action/rig_module/targeted/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	to_chat(user, text = "called ui interact")
	if(!ui)
		ui = new(user, src, "RIGModuleTargeted", name)
		ui.open()

/datum/action/rig_module/targeted/ui_data(mob/user)
	var/list/data = list()
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
	special_counter = emag_projectiles.len
	if(module.emagged)
		while(special_counter)
			var/list/emag_proj = list()
			emag_proj["proj_name"] = emag_projectiles[special_counter]
			emag_proj["proj_id"] = special_counter - 1
			emag_proj["proj_emag"] = TRUE
			if(selected_projtype == emag_projectiles[special_counter - 1])
				emag_proj["proj_color"] = "green"
			else
				emag_proj["proj_color"] = "red"
			data["projectiles"] += list(emag_proj)
			special_counter -= 2
	special_counter = firemodes.len
	while(special_counter)
		var/list/firemode_handle = list()
		firemode_handle["shots"] = firemodes[special_counter]
		firemode_handle["firemode_ident"] = special_counter
		if(firemode == firemodes[special_counter])
			firemode_handle["color"] = "green"
		else
			firemode_handle["color"] = "blue"
		data["firemodes"] += list(firemode_handle)
		special_counter--

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
		if("pick_firemode")
			var/target = params["firemode_id"]
			firemode = firemodes[target]

/datum/action/rig_module/targeted/ui_state()
	return GLOB.always_state

/datum/action/rig_module/targeted/custom_trigger()
	. = ..()
	if(module.active)
		UnregisterSignal(rig.wearer, COMSIG_MOB_MIDDLECLICKON)
		name = "Toggle targetting on"
		module.active = FALSE
		background_icon_state = "rig_bg_default"
	else
		RegisterSignal(rig.wearer, COMSIG_MOB_MIDDLECLICKON, .proc/on_middle_click_rig)
		name = "Toggle targetting off"
		module.active = TRUE
		background_icon_state = "rig_bg_active"
	UpdateButtonIcon()
	to_chat(rig.wearer, text = "We tried 3 ")

/datum/action/rig_module/targeted/HandleRemoval(user)
	if(module.active)
		UnregisterSignal(user, COMSIG_MOB_MIDDLECLICKON)
		module.active = FALSE
		background_icon_state = "rig_bg_default"
		name = "Toggle targetting off"
		UpdateButtonIcon()

/datum/action/rig_module/targeted/proc/on_middle_click_rig(mob/user, atom/target)
	SIGNAL_HANDLER
	to_chat(rig.wearer, text = "We tried 2")
/*	if(!ispAI(user) || user.stat != CONSCIOUS)
		return NONE */
	if(!(rig.use_power(module.emagged ? normal_firecost : emagged_firecost)))
		return NONE
	rig.wearer.swap_hand()
	to_chat(rig.wearer, text = "We tried")
	if(selected_projtype)
		if(firemode < 2)
			handle_projectile_firing(target)
		else
			for(var/counter = 1 to firemode)
				addtimer(CALLBACK(src, .proc/handle_projectile_firing, target), fire_rate * counter)

/datum/action/rig_module/targeted/proc/handle_projectile_firing(atom/target)
	SIGNAL_HANDLER
	var/obj/item/rig_module/targeted/module_handle = module
	var/obj/projectile/P = new selected_projtype(rig.wearer)
	P.starting = rig.wearer.loc
	P.firer = rig.wearer
	P.fired_from = rig
	P.yo = target.y - rig.wearer.loc.y
	P.xo = target.x - rig.wearer.loc.x
	P.original = target
	P.preparePixelProjectile(target, rig.wearer, spread = module_handle.spread)
	INVOKE_ASYNC(P, /obj/projectile.proc/fire)
	return NONE

// You might be asking , what the fuck is this ? list in lists in lists ?!?!? well , we need it to store a reference of each individual bullet
/obj/item/rig_module/targeted_ballistic
	name = "Ballistic targetting system"
	desc = "Put ammo in this shitty module and shoot it at the captain."
	var/list/ammo_calibers = list(CALIBER_712X82MM,CALIBER_10MM,CALIBER_357)
	var/list/ammo_amount = list(list(),list(),list())
	var/list/ammo_capacity = list(100,100,100)
	var/fire_rate = 1 SECONDS
	var/spread = 1
	actions_to_add = list(/datum/action/rig_module/targeted_ballistic)

/obj/item/rig_module/targeted_ballistic/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete)
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 40
	STR.max_items = 10
	STR.insert_preposition = "in"
	STR.set_holdable(list(
		/obj/item/ammo_box
	))

/obj/item/rig_module/targeted_ballistic/attackby(obj/item/I, mob/living/user, params)
	addtimer(CALLBACK(src,.proc/ammo_calculate), 1 SECONDS)
	..()

/obj/item/rig_module/targeted_ballistic/proc/ammo_calculate()
	for(var/obj/item/ammo_box/box in contents)
		for(var/obj/item/ammo_casing/bullet in box.stored_ammo)
			if(!bullet.projectile_type)
				return FALSE
			if(!(ammo_calibers.Find(bullet.caliber,1,0)))
				return FALSE
			var/spot_to_add = ammo_calibers.Find(bullet.caliber,1,0)
			ammo_amount[spot_to_add] += bullet
			box.stored_ammo -= bullet
			bullet.moveToNullspace()
		box.update_ammo_count()
	return TRUE

/datum/action/rig_module/targeted_ballistic
	name = "Toggle ballistic annihilation"
	desc = "Merge before balance checks"
	var/selected_caliber = null
	var/slot_to_target = null
	var/list/available_firemodes = list(1,3,5)
	var/firemode = 1

/datum/action/rig_module/targeted_ballistic/custom_trigger()
	. = ..()
	if(!selected_caliber)
		return FALSE
	if(module.active)
		UnregisterSignal(rig.wearer, COMSIG_MOB_MIDDLECLICKON)
		name = "Toggle targetting on"
		module.active = FALSE
		background_icon_state = "rig_bg_default"
	else
		RegisterSignal(rig.wearer, COMSIG_MOB_MIDDLECLICKON, .proc/on_middle_click_rig)
		name = "Toggle targetting off"
		module.active = TRUE
		background_icon_state = "rig_bg_active"
	UpdateButtonIcon()

/datum/action/rig_module/targeted_ballistic/HandleRemoval(user)
	if(module.active)
		UnregisterSignal(user, COMSIG_MOB_MIDDLECLICKON)
		module.active = FALSE
		background_icon_state = "rig_bg_default"
		name = "Toggle targetting off"
		UpdateButtonIcon()

/datum/action/rig_module/targeted_ballistic/proc/on_middle_click_rig(mob/user, atom/target)
	SIGNAL_HANDLER
	var/obj/item/rig_module/targeted_ballistic/module_handle = module
	//if(!ispAI(user) || !user.stat)
	//	return NONE
	rig.wearer.swap_hand()
	if(selected_caliber)
		slot_to_target = module_handle.ammo_calibers.Find(selected_caliber, 1, 0)
		if(firemode < 2)
			handle_projectile_firing(target)
		else
			handle_projectile_firing(target)
			for(var/counter = 1 to firemode-1)
				addtimer(CALLBACK(src, .proc/handle_projectile_firing, target), module_handle.fire_rate * counter)

/datum/action/rig_module/targeted_ballistic/proc/handle_projectile_firing(atom/target)
	SIGNAL_HANDLER
	var/obj/item/rig_module/targeted_ballistic/module_handle = module
	var/list/to_acces = module_handle.ammo_amount[slot_to_target]
	if(!to_acces.len)
		return FALSE
	var/obj/projectile/bullet = to_acces[1]
	module_handle.ammo_amount[slot_to_target] -= bullet
	var/obj/projectile/P = new bullet.projectile_type(rig.wearer)
	qdel(bullet)
	P.starting = rig.wearer.loc
	P.firer = rig.wearer
	P.fired_from = rig
	P.yo = target.y - rig.wearer.loc.y
	P.xo = target.x - rig.wearer.loc.x
	P.original = target
	P.preparePixelProjectile(target, rig.wearer, spread = module_handle.spread)
	INVOKE_ASYNC(P, /obj/projectile.proc/fire)
	return NONE

/datum/action/rig_module/targeted_ballistic/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	to_chat(user, text = "called ui interact")
	if(!ui)
		ui = new(user, src, "RIGModuleTargetedBallistic", name)
		ui.open()

/datum/action/rig_module/targeted_ballistic/ui_data(mob/user)
	var/list/data = list()
	var/obj/item/rig_module/targeted_ballistic/module_handle = module
	var/counter = module_handle.ammo_amount.len
	while(counter)
		var/list/bullet_data = list()
		bullet_data["bullet_count"] = module_handle.ammo_amount[counter].len
		bullet_data["bullet_caliber"] = module_handle.ammo_calibers[counter]
		if(selected_caliber == module_handle.ammo_calibers[counter])
			bullet_data["bullet_color"] = "green"
		else
			bullet_data["bullet_color"] = "blue"
		data["bullets"] += list(bullet_data)
		counter--
	counter = available_firemodes.len
	while(counter)
		var/list/firemode_handle = list()
		firemode_handle["shots"] = available_firemodes[counter]
		if(firemode == available_firemodes[counter])
			firemode_handle["color"] = "green"
		else
			firemode_handle["color"] = "blue"
		data["firemodes"] += list(firemode_handle)
		counter--

	return data

/datum/action/rig_module/targeted_ballistic/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("pick")
			selected_caliber = params["bulletcaliber"]
		if("pick_firemode")
			firemode = params["firemode_id"]

/datum/action/rig_module/targeted_ballistic/ui_state()
	return GLOB.always_state

/obj/item/rig_module/tool_deploy
	name = "XS-7 Tactical analyzing module"
	desc = "What do the numbers mean"
	var/list/tools = list(/obj/item/analyzer)
	var/single = FALSE // Used to determine wheter we allow a UI act for this , since we can have multiple or just 1 tool. Changed in initialize.
	actions_to_add = list(/datum/action/rig_module/deploy_tool)
	active = FALSE

/obj/item/rig_module/tool_deploy/Initialize()
	. = ..()
	var/counter = tools.len
	while(counter)
		var/obj/item/replacement = new tools[counter]
		replacement.moveToNullspace()
		tools[counter] = replacement
		counter--
	if(tools.len < 2)
		var/datum/action/rig_module/deploy_tool/handle = actions.Find(actions_to_add[1])
		handle = actions[handle]
		handle.tool_reference = tools[1]
		single = TRUE

/datum/action/rig_module/deploy_tool
	name = "Deploy a tool"
	desc = "Deploys a tol"
	var/obj/item/tool_reference = null

/datum/action/rig_module/deploy_tool/custom_trigger()
	. = ..()
	if(!(module.active))
		module.active = TRUE
		rig.wearer.put_in_hands(tool_reference)
	else
		tool_reference.moveToNullspace()
		module.active = FALSE

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
	cooldown = 1 SECONDS * 1.25

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
	spread = 2

/datum/action/rig_module/targeted/disabler
	name = "Toggle KER-6 Disabler module"
	desc = "Laser go brr"
	projectiles = list(/obj/projectile/beam/disabler, "Disabler")
	emag_projectiles = list(/obj/projectile/beam/laser, "Laser")
	normal_firecost = 75
	emagged_firecost = 150
	firemodes = list(5,10,15,20,25,30)
	normal_firecost = 75
/*
Ballistic modules
*/






/*
Reagent modules
*/

/*
Melle modules
*/
