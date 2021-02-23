
/obj/item/clothing/gloves/rig_suit
	icon = 'modular_skyrat/modules/rigs/rig_sprites.dmi'
	icon_state = "rig_gloves"
	worn_icon = 'modular_skyrat/modules/rigs/rig_sprites.dmi'
	worn_icon_state = "rig_gloves_wear"
	armor = list(MELEE = 20, BULLET = 20, LASER = 20, ENERGY = 20, BOMB = 85, BIO = 100, RAD = 25, FIRE = 95, ACID = 95)
	var/deployed = FALSE
/obj/item/clothing/suit/armor/rig_suit
	icon = 'modular_skyrat/modules/rigs/rig_sprites.dmi'
	icon_state = "rig_vest"
	worn_icon = 'modular_skyrat/modules/rigs/rig_sprites.dmi'
	worn_icon_state = "rig_vest_wear"
	inhand_icon_state ="rig_vest_inhand"
	armor = list(MELEE = 20, BULLET = 20, LASER = 20, ENERGY = 20, BOMB = 85, BIO = 100, RAD = 25, FIRE = 95, ACID = 95)
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL | SNUG_FIT
	permeability_coefficient = 0.01
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals)
	slowdown = 1
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	cold_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT_OFF
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	var/deployed = FALSE

/obj/item/clothing/head/helmet/rig_suit
	icon = 'modular_skyrat/modules/rigs/rig_sprites.dmi'
	icon_state = "rig_helmet"
	worn_icon = 'modular_skyrat/modules/rigs/rig_sprites.dmi'
	worn_icon_state = "rig_helmet_wear"
	inhand_icon_state ="rig_helmet_inhand"
	armor = list(MELEE = 20, BULLET = 20, LASER = 20, ENERGY = 20, BOMB = 85, BIO = 100, RAD = 25, FIRE = 95, ACID = 95)
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH | PEPPERPROOF
	clothing_flags = STOPSPRESSUREDAMAGE | THICKMATERIAL | SNUG_FIT
	permeability_coefficient = 0.01
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELM_MIN_TEMP_PROTECT
	heat_protection = HEAD
	max_heat_protection_temperature = SPACE_HELM_MAX_TEMP_PROTECT
	flash_protect = FLASH_PROTECTION_WELDER
	var/deployed = FALSE

/obj/item/clothing/shoes/rig_suit
	icon = 'modular_skyrat/modules/rigs/rig_sprites.dmi'
	icon_state = "rig_boots"
	worn_icon = 'modular_skyrat/modules/rigs/rig_sprites.dmi'
	worn_icon_state = "rig_boots_wear"
	inhand_icon_state ="rig_boots_inhand"
	armor = list(MELEE = 20, BULLET = 20, LASER = 20, ENERGY = 20, BOMB = 85, BIO = 100, RAD = 25, FIRE = 95, ACID = 95)
	var/deployed = FALSE


/obj/item/clothing/gloves/rig_suit/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, src)

/obj/item/clothing/suit/armor/rig_suit/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, src)

/obj/item/clothing/head/helmet/rig_suit/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, src)

/obj/item/clothing/shoes/rig_suit/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, src)





