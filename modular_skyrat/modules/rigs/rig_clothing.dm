/obj/item/clothing/gloves/rig_suit
	icon = 'modular_skyrat/modules/rigs/rig_sprites.dmi'
	icon_state = "rig_gloves"
	worn_icon = 'modular_skyrat/modules/rigs/rig_sprites.dmi'
	worn_icon_state = "rig_gloves_wear"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'

/obj/item/clothing/suit/armor/rig_suit
	icon = 'modular_skyrat/modules/rigs/rig_sprites.dmi'
	icon_state = "rig_vest"
	worn_icon = 'modular_skyrat/modules/rigs/rig_sprites.dmi'
	worn_icon_state = "rig_vest_wear"
	inhand_icon_state ="rig_vest_inhand"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'

/obj/item/clothing/head/helmet/rig_suit
	icon = 'modular_skyrat/modules/rigs/rig_sprites.dmi'
	icon_state = "rig_helmet"
	worn_icon = 'modular_skyrat/modules/rigs/rig_sprites.dmi'
	worn_icon_state = "rig_helmet_wear"
	inhand_icon_state ="rig_helmet_inhand"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'

/obj/item/clothing/shoes/rig_suit
	icon = 'modular_skyrat/modules/rigs/rig_sprites.dmi'
	icon_state = "rig_boots"
	worn_icon = 'modular_skyrat/modules/rigs/rig_sprites.dmi'
	worn_icon_state = "rig_boots_wear"
	inhand_icon_state ="rig_boots_inhand"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'

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





