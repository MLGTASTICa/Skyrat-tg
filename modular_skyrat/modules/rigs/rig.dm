/obj/item/rig_suit
	name = "RIG Suit"
	icon = 'modular_skyrat/modules/rigs/rig_sprites.dmi'
	icon_state = "rig_back_default"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK// Replaces the backpack , a fair trade-off for a mecha armour
	resistance_flags = NONE
	max_integrity = 500 // Rigs are tough
	armor = list(MELEE = 20, BULLET = 20, LASER = 20, ENERGY = 20, BOMB = 85, BIO = 100, RAD = 25, FIRE = 95, ACID = 95)
	/// The rig clothing , stored in a list so we can track them easily.
	var/list/suit_pieces = list()
	/// The rig parts,  used when a new rig suit is created to fill up suit pieces
	var/vest = /obj/item/clothing/suit/armor/rig_suit
	var/helmet = /obj/item/clothing/head/helmet/rig_suit
	var/gloves = /obj/item/clothing/gloves/rig_suit
	var/boots = /obj/item/clothing/shoes/rig_suit
	/// The AI this rig is currently hosting if any
	var/mob/living/AI
	/// If the AI can use its linked abilities
	var/AIcontrol = FALSE
	/// The modules that this rig currently has installed
	var/list/obj/item/rig_module/modules = list()
	/// A limit on how many modules we can have
	var/module_limit = 5
	/// A limit on the total module weight
	var/module_weight_limit = 15
	/// The sum of all module weights
	var/module_weight_current = 0
	/// The required acces
	req_access = 0
	/// The owner who may deploy this rigsuit if chosen
	var/mob/living/carbon/human/owner_suit = null
	/// Whoever is currently wearing the rigsuit
	var/mob/living/carbon/human/wearer
	/// Is it locked ?
	var/locked = FALSE
	/// Var to check if maintenance panel is open or not
	var/panel = FALSE
	/// if its currently powered or not
	var/powered = FALSE
	/// Are we deployed on the user currently?
	var/deployed = FALSE
	/// The refence for the cell
	var/obj/item/stock_parts/cell/cell
	/// The amount of power we use per process , calculated!
	var/calculated_power_use = 0
	/// The amount of power rig uses by itself
	var/rig_power_use = 25
	/// The rig suit pieces go here , the list ontop only holds references.
	var/list/datum/action/rig_suit/actions_to_add_rig = list(/datum/action/rig_suit/deploy_undeploy)
	var/list/datum/action/rig_suit/action_storage_rig = list()

/// We add the individual suit components and the wires datum.
/obj/item/rig_suit/Initialize()
	. = ..()
	wires = new /datum/wires/rig_suit(src)
	suit_pieces.Add(new helmet) // 1
	suit_pieces.Add(new vest) // 2
	suit_pieces.Add(new gloves) // 3
	suit_pieces.Add(new boots) // 4
	var/special_counter = actions_to_add_rig.len
	while(special_counter>0)
		var/datum/action/rig_suit/to_add = actions_to_add_rig[special_counter]
		var/datum/action/rig_suit/handle = new to_add(src)
		action_storage_rig.Add(handle)
		special_counter--

//***
///obj/item/rig_suit/New()
//	wires = new /datum/wires/rig_suit(src)
//	suit_pieces[RIG_HELMET] += new helmet
//	suit_pieces[RIG_VEST] += new vest
//	suit_pieces[RIG_GLOVES] += new gloves
//	suit_pieces[RIG_SHOES] += new boots
//	deploy = new(src)
//	/undeploy = new(src)
//	/

/// Called when they put it on the back
/obj/item/rig_suit/equipped(mob/living/owner, slot)
	. = ..()
	if(slot == ITEM_SLOT_BACK)
		wearer = owner
		action_storage_rig[1].Grant(wearer)

/obj/item/rig_suit/dropped(mob/user, silent)
	. = ..()
	wearer = null
	action_storage_rig[1].Remove(user)

/datum/action/rig_suit
	name = "Deploy RIG"
	var/obj/item/rig_suit/rig
	var/mob/living/wearer

/// Links it properly , DO NOT FUCKING use this when the rig is not being WORN, it will FUCK UP.
/datum/action/rig_suit/link_to(Target)
	. = ..()
	rig = target
	wearer = rig.wearer
/datum/action/rig_suit/deploy_undeploy
	name = "Deploy RIG"

/// Same as below desc
/datum/action/rig_suit/deploy_undeploy/Trigger()
	rig.deploy_undeploy()

/// The datum for undeploying , we remove it from displaying on use and replace it with the deploy one , or make a new deploy one if it magically disspears

///  Deploys the rig , making the backpack undroppable and forcefully equipping the gear. Make sure to return TRUE or FALSE because we use this to  handle some button changes
/obj/item/rig_suit/proc/deploy_undeploy()
	if(!deployed)
		if(owner_suit && wearer != owner_suit)
			to_chat(wearer, text = "DNA Sequence not matching with registered RIG Owner. Aborting")
			return FALSE
		if(req_access)
			var/obj/item/id = wearer.get_idcard()
			if(req_access != id)
				to_chat(wearer, text = "ID Acces codes are missing . Acces denied")
				return FALSE
		if(!cell)
			return FALSE
		ADD_TRAIT(src, TRAIT_NODROP, src)
		to_chat(wearer,text = "Deploying rig")
		wearer.equip_to_slot_forcefully(suit_pieces[1],ITEM_SLOT_HEAD, src)
		wearer.equip_to_slot_forcefully(suit_pieces[2],ITEM_SLOT_OCLOTHING, src)
		wearer.equip_to_slot_forcefully(suit_pieces[3],ITEM_SLOT_GLOVES, src)
		wearer.equip_to_slot_forcefully(suit_pieces[4],ITEM_SLOT_FEET, src)
		deployed = TRUE
		power_suit()
		return TRUE
	else
		deployed = FALSE
		powered = FALSE
		REMOVE_TRAIT(src, TRAIT_NODROP, src)
		unpower_suit()
		var/obj/item/clothing/cloth1 = wearer.get_item_by_slot(ITEM_SLOT_HEAD)
		var/obj/item/clothing/cloth2 = wearer.get_item_by_slot(ITEM_SLOT_OCLOTHING)
		var/obj/item/clothing/cloth3 = wearer.get_item_by_slot(ITEM_SLOT_GLOVES)
		var/obj/item/clothing/cloth4 = wearer.get_item_by_slot(ITEM_SLOT_FEET)
		if(istype(cloth1, /obj/item/clothing/head/helmet/rig_suit))
			handle_clothing_drop(cloth1, ITEM_SLOT_HEAD)
		if(istype(cloth2, /obj/item/clothing/suit/armor/rig_suit))
			handle_clothing_drop(cloth2, ITEM_SLOT_OCLOTHING)
		if(istype(cloth3, /obj/item/clothing/gloves/rig_suit))
			handle_clothing_drop(cloth3, ITEM_SLOT_GLOVES)
		if(istype(cloth4, /obj/item/clothing/shoes/rig_suit))
			handle_clothing_drop(cloth4, ITEM_SLOT_FEET)
		for(var/obj/item/clothing/cloth in contents)
			wearer.equip_to_appropriate_slot(cloth, FALSE, FALSE, FALSE)

/// Screwdirver act
/obj/item/rig_suit/screwdriver_act(mob/living/user, obj/item/I)
	panel = !panel
	if(!panel)
		visible_message("[user] opens the maintenance panel on the [src]")
		to_chat(user,text = "You open the maintenance panel on the [src]")
	else
		visible_message("[user] closes the maintenance panel on the [src]")
		to_chat(user,text = "You close the maintenance panel on the [src]")

/// Wirecutter act , handles displaying the wires
/obj/item/rig_suit/wirecutter_act(mob/living/user, obj/item/I)
	ui_interact(wearer)
	if(!panel)
		wires.interact(user)

/// The crowbar act
/obj/item/rig_suit/crowbar_act(mob/living/user, obj/item/I)
	if(!panel)
		if(cell)
			cell.forceMove(loc)
			cell = null

/// Handles the RIG Cell or module insertion , parent is called at bottom because the storage component overrides it
/obj/item/rig_suit/attackby(obj/item/I, mob/living/user, params)
	if(istype(I,/obj/item/stock_parts/cell))
		if(!cell)
			cell = I
			I.moveToNullspace()
			to_chat(user, text = "You insert the [I] into the [src]")
		else
			to_chat(user,text = "There is already a battery in the [src]")
		return TRUE
	if(istype(I,/obj/item/rig_module))
		handle_module_insertion(I, user)
		return TRUE
	..()

/// Some storage for the rig! all the clothes that get stored in contents show here.
/obj/item/rig_suit/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete)
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 1
	STR.max_w_class = WEIGHT_CLASS_SMALL
	STR.max_items = 4

/obj/item/rig_suit/process()
	if(!cell && powered)
		unpower_suit()
		return
	if(cell.charge < calculated_power_use)
		unpower_suit()
		return
	cell.charge -= calculated_power_use

/obj/item/rig_suit/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RIGSuit", name)
		ui.open()

/obj/item/rig_suit/ui_data(mob/user)
	var/list/data = list()
	data["cell"] = cell
	data["cellcharge"] = cell.charge
	data["power_use"] = calculated_power_use
	data["module_count"] = modules.len
	data["maximum_modules"] = module_limit
	data["maximum_modules_weight"] = module_weight_limit
	data["module_weight"] = module_weight_current
	data["ai"] = AI
	var/special_counter = 0
	for(var/obj/item/rig_module/module in modules)
		var/list/handle = list()
		special_counter++
		handle["id"] = special_counter
		handle["name"] = module.name
		data["modules"] += list(handle)

	return data

/obj/item/rig_suit/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("power")
			to_chat(wearer, text = "Powering suit")
			power_suit()
		if("unpower")
			to_chat(wearer, text= "Powering down suit")
			unpower_suit()
		if("eject_module")
			if(modules)
				var/obj/item/rig_module/fugitive = pick(modules)
				fugitive.forceMove(wearer.loc)
				modules -= fugitive
				fugitive.remove_ability(src)
		if("become_owner")
			owner_suit = wearer
		if("purge_owner")
			owner_suit = null
		if("lock_to_id")
			var/obj/item/id = wearer.get_idcard()
			req_access = id.GetAccess()
		if("purge_acces")
			req_access = null
		if("toggle_lock")
			if(locked)
				to_chat(wearer, text = "RIG Unlocked")
			else
				to_chat(wearer, text = "You feel the RIG clamp itself onto your chest!")
			locked = !locked
		if("eject_specific_module")
			var/id = params["identifier"]
			to_chat(wearer, text = "Identifier is [id]")
			var/obj/item/rig_module/module = modules[id]
			to_chat(wearer, text = "Module is [module]")
			modules -= modules[id]
			module.forceMove(wearer.loc)
		if("configure_specific_module")
			var/id = params["identifier"]
			var/obj/item/rig_module/module = modules[id]
			module.action_storage[1].ui_interact(wearer)

