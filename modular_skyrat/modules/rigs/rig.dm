/obj/item/rig_suit
	icon = ''
	icon_state = ""
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK // Replaces the backpack , a fair trade-off
	resistance_flags = NONE
	max_integrity = 500 // Rigs are tough
	armor = list(MELEE = 20, BULLET = 20, LASER = 20, ENERGY = 20, BOMB = 85, BIO = 100, RAD = 25, FIRE = 95, ACID = 95)
	/// The rig clothing
	var/list/clothing/suit_pieces = list()
	suit_pieces["GLOVES"] = /obj/item/clothing/gloves/rig_suit
	suit_pieces["VEST"] = /obj/item/clothing/suit/armor/rig_suit
	suit_pieces["HELMET"] = /obj/item/clothing/head/helmet/rig_suit
	suit_pieces["BOOTS"] =  /obj/item/clothing/shoes/rig_suit
	/// The AI this rig is currently hosting if any
	var/mob/living/AI
	/// The modules that this rig currently has installed
	var/list/obj/item/rig_module/modules
	/// The acces that this rig requires
	req_access = list()
	/// the only mob that may unlock this armour , if chosen
	var/mob/living/acces_owner
	/// if its currently powered or not
	var/powered = 0
	/// Are we deployed on the user currently?
	var/deployed = 0
	/// Can the installed PAI control it anymore?
	var/AIcontrol = 1
	/// The refence for the cell
	var/obj/item/stock_parts/cell/cell

/obj/item/rig_suit/proc/deploy(mob/living/M)

/obj/item/rig_suit/proc/undeploy(mob/living/M)

/obj/item/rig_suit/proc/take_control(mob/living/M)

/obj/item/rig_suit/proc/remove_control(mob/living/M)

/obj/item/rig_suit/attackby

/obj/item/rig_suit/ComponentInitialize()
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_combined_w_class = 5
	STR.max_w_class = WEIGHT_CLASS_SMALL
	STR.max_items = 5


