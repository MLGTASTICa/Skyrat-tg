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
	/// The modules that this rig currently has installed
	var/list/obj/item/rig_module/modules
	/// The acces that this rig requires
	req_access = list()
	/// the only mob that may unlock this armour , if chosen
	var/mob/living/acces_owner
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
	/// Can the installed PAI control it anymore?
	var/AIcontrol = TRUE
	/// The refence for the cell
	var/obj/item/stock_parts/cell/cell
	/// The rig suit pieces go here , the list ontop only holds references.

/// We add the individual suit components and the wires datum.
/obj/item/rig_suit/Initialize()
	. = ..()
	wires = new /datum/wires/rig_suit(src)
	suit_pieces.Add(new helmet)
	suit_pieces.Add(new vest)
	suit_pieces.Add(new gloves)
	suit_pieces.Add(new boots)

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
		var/datum/action/rig_suit/deploy/deplot = new /datum/action/rig_suit/deploy(src)
		deplot.Grant(wearer)

/datum/action/item_action/rig_suit
	name = "Test 1 2 3 4 5"
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = null

/datum/action/rig_suit
	name = "Deploy RIG"
	var/obj/item/rig_suit/rig
	var/mob/living/wearer

/datum/action/rig_suit/link_to(Target)
	. = ..()
	rig = target
	wearer = rig.wearer
/datum/action/rig_suit/deploy
	name = "Deploy RIG"

/datum/action/rig_suit/deploy/Trigger()
	rig.deploy()
	Remove(wearer)
	var/datum/action/rig_suit/undeploy/additive
	if(rig.actions)
		additive = rig.actions.Find(/datum/action/rig_suit/undeploy,1,0)
	if(!additive)
		additive = new /datum/action/rig_suit/undeploy(rig)
	additive.Grant(wearer)
/datum/action/rig_suit/undeploy
	name = "Undeploy RIG"

/datum/action/rig_suit/undeploy/Trigger()
	rig.undeploy()
	Remove(wearer)
	var/datum/action/rig_suit/undeploy/additive
	if(rig.actions)
		additive = rig.actions.Find(/datum/action/rig_suit/deploy,1,0)
	if(!additive)
		additive = new /datum/action/rig_suit/deploy(rig)
	additive.Grant(wearer)

/obj/item/rig_suit/ui_action_click(mob/user, actiontype)
	if(istype(actiontype, /datum/action/rig_suit/deploy))
		deploy()
	if(istype(actiontype, /datum/action/rig_suit/undeploy))
		undeploy()
	..()

/obj/item/rig_suit/proc/power_modules()
	for(var/obj/item/rig_module/item in modules)
		item.add_ability(src)

/obj/item/rig_suit/proc/deploy()
	ADD_TRAIT(src, TRAIT_NODROP, src)
	to_chat(wearer,text = "Deploying rig")
	wearer.equip_to_slot_forcefully(suit_pieces[2],ITEM_SLOT_OCLOTHING, src)
	wearer.equip_to_slot_forcefully(suit_pieces[3],ITEM_SLOT_GLOVES, src)
	wearer.equip_to_slot_forcefully(suit_pieces[4],ITEM_SLOT_FEET, src)
	wearer.equip_to_slot_forcefully(suit_pieces[1],ITEM_SLOT_HEAD, src)
	deployed = TRUE
	powered = TRUE
	power_modules()
	START_PROCESSING(SSobj,src)


/obj/item/rig_suit/proc/undeploy()
	STOP_PROCESSING(SSobj,src)
	deployed = FALSE
	powered = FALSE
	REMOVE_TRAIT(src, TRAIT_NODROP, src)
	var/obj/item/clothing/cloth1 = wearer.get_item_by_slot(ITEM_SLOT_FEET)
	var/obj/item/clothing/cloth2 = wearer.get_item_by_slot(ITEM_SLOT_GLOVES)
	var/obj/item/clothing/cloth3 = wearer.get_item_by_slot(ITEM_SLOT_OCLOTHING)
	var/obj/item/clothing/cloth4 = wearer.get_item_by_slot(ITEM_SLOT_HEAD)
	if(istype(cloth1, /obj/item/clothing/shoes/rig_suit))
		wearer.dropItemToGround(cloth1, force = TRUE, silent = FALSE, invdrop = TRUE)
		cloth1.moveToNullspace()
	if(istype(cloth2, /obj/item/clothing/gloves/rig_suit))
		wearer.dropItemToGround(cloth2, force = TRUE, silent = FALSE, invdrop = TRUE)
		cloth2.moveToNullspace()
	if(istype(cloth3, /obj/item/clothing/suit/armor/rig_suit))
		wearer.dropItemToGround(cloth3, force = TRUE, silent = FALSE, invdrop = TRUE)
		cloth3.moveToNullspace()
	if(istype(cloth4, /obj/item/clothing/head/helmet/rig_suit))
		wearer.dropItemToGround(cloth4, force = TRUE, silent = FALSE, invdrop = TRUE)
		cloth4.moveToNullspace()
	for(var/obj/item/clothing/cloth in contents)
		wearer.equip_to_appropriate_slot(cloth, FALSE, FALSE, FALSE)


/mob/living/carbon/human/proc/equip_to_slot_forcefully(clothing, slot, rig)
	if(!clothing) /// Its deleted , bruh!
		return
	var/obj/item/trash = get_item_by_slot(slot)
	if(trash)
		doUnEquip(trash, TRUE, loc, FALSE, TRUE, FALSE)
		trash.forceMove(rig)
	equip_to_slot_if_possible(clothing, slot, FALSE, FALSE)
	switch(slot)
		if(ITEM_SLOT_GLOVES)
			update_inv_gloves()
		if(ITEM_SLOT_OCLOTHING)
			update_inv_wear_suit()
		if(ITEM_SLOT_HEAD)
			update_inv_head()
		if(ITEM_SLOT_FEET)
			update_inv_shoes()

/obj/item/rig_suit/screwdriver_act(mob/living/user, obj/item/I)
	panel = !panel
	if(!panel)
		visible_message("[user] opens the maintenance panel on the [src]")
		to_chat(user,text = "You open the maintenance panel on the [src]")
	else
		visible_message("[user] closes the maintenance panel on the [src]")
		to_chat(user,text = "You close the maintenance panel on the [src]")

/obj/item/rig_suit/wirecutter_act(mob/living/user, obj/item/I)
	if(!panel)
		wires.interact(user)

/obj/item/rig_suit/crowbar_act(mob/living/user, obj/item/I)
	if(!panel)
		if(cell)
			cell.forceMove(loc)
			cell = null

/obj/item/rig_suit/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(istype(I,/obj/item/stock_parts/cell))
		if(!cell)
			cell = I
			I.moveToNullspace()
		else
			to_chat(user,text = "There is already a battery in the [src]")
	if(istype(I,/obj/item/rig_module))
		modules.Add(I)
		I.moveToNullspace()

/obj/item/rig_suit/ComponentInitialize() // Some storage for this rig , so they can still store a few mags or supplies. Clothing goes here automatically if we deploy the rig while its on and we also pull it from here!
	. = ..()
	AddComponent(/datum/component/storage/concrete)
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 1
	STR.max_w_class = WEIGHT_CLASS_SMALL
	STR.max_items = 4

/obj/item/rig_suit/process(delta_time)
	. = ..()




