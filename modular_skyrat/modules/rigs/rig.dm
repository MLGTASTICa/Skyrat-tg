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
	/// if its currently powered or not
	var/powered = 0
	/// Are we deployed on the user currently?
	var/deployed = 0
	/// Can the installed PAI control it anymore?
	var/AIcontrol = 1
	/// The refence for the cell
	var/obj/item/stock_parts/cell/cell

/// We add the individual suit components and the wires datum.
/obj/item/rig_suit/New()
	wires = new /datum/wires/rig_suit(src)
	suit_pieces[RIG_HELMET] = new helmet
	suit_pieces[RIG_VEST] = new vest
	suit_pieces[RIG_GLOVES] = new gloves
	suit_pieces[RIG_SHOES] = new boots

/obj/item/rig_suit/equipped(mob/living/owner)
	. = ..()

/obj/item/rig_suit/proc/deploy()

/obj/item/rig_suit/proc/undeploy()

/obj/item/rig_suit/proc/take_control(mob/living/M)

/obj/item/rig_suit/proc/remove_control(mob/living/M)

/obj/item/rig_suit/attackby

/obj/item/rig_suit/ComponentInitialize() // Some storage for this rig , so they can still store a few mags or supplies
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 5
	STR.max_w_class = WEIGHT_CLASS_SMALL
	STR.max_items = 5


