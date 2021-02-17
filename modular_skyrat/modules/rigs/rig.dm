/obj/item/rig_suit
	icon = 'modular_skyrat/modules/rigs/rig_sprites.dmi'
	icon_state = "rig_back_default"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK // Replaces the backpack , a fair trade-off for a mecha armour
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
	var/mob/living/wearer
	/// Is it locked ?
	var/locked = FALSE
	/// Var to check if maintenance panel is open or not
	var/panel = TRUE
	/// if its currently powered or not
	var/powered = FALSE
	/// Are we deployed on the user currently?
	var/deployed = FALSE
	/// Can the installed PAI control it anymore?
	var/AIcontrol = TRUE
	/// The refence for the cell
	var/obj/item/stock_parts/cell/cell
	/// The datum to deploy the suit
	var/datum/action/item_action/rig_suit/deploy
	/// The datum to remove the suit after  we are finished wrecking nukies in it
	var/datum/action/item_action/rig_suit/undeploy

/// We add the individual suit components and the wires datum.
/obj/item/rig_suit/New()
	wires = new /datum/wires/rig_suit(src)
	suit_pieces[RIG_HELMET] = new helmet
	suit_pieces[RIG_VEST] = new vest
	suit_pieces[RIG_GLOVES] = new gloves
	suit_pieces[RIG_SHOES] = new boots
	deploy = new(src)

/// Called when they put it on the back
/obj/item/rig_suit/equipped(mob/living/owner)
	. = ..()
	wearer = owner
	deploy.Grant(wearer)
	undeploy.Grant(wearer)
	ADD_TRAIT(src, TRAIT_NODROP, src) /// No proc for when we remove something from our backpack slot , so we make it no_Drop and add a ability to remove it so we can handle it properly

/datum/action/item_action/rig_suit
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = null

/datum/action/item_action/rig_suit/deploy
	name = "Deploy RIG"
	button_icon_state = ""

/datum/action/item_action/rig_suit/undeploy
	name = "Undeploy RIG"
	button_icon_state = ""

/obj/item/rig_suit/ui_action_click(mob/user, actiontype)
	if(istype(actiontype, deploy))
		deploy()
		return TRUE
	if(istype(actiontype, undeploy))
		undeploy()
		return TRUE
	..()

/obj/item/rig_suit/proc/deploy()

/obj/item/rig_suit/proc/undeploy()

/obj/item/rig_suit/proc/take_control(mob/living/M)

/obj/item/rig_suit/proc/remove_control(mob/living/M)

/obj/item/rig_suit/screwdriver_act(mob/living/user, obj/item/I)
	panel = !panel
	if(panel)
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
			qdel(I)
		else
			to_chat(user,text = "There is already a battery in the [src]")


/obj/item/rig_suit/ComponentInitialize() // Some storage for this rig , so they can still store a few mags or supplies
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 5
	STR.max_w_class = WEIGHT_CLASS_SMALL
	STR.max_items = 5


