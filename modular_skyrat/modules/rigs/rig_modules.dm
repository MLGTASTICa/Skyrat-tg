/obj/item/rig_module
	icon = ''
	icon_state = ""

/obj/item/rig_module/proc/add_ability(obj/item/rig_suit/target)

/obj/item/rig_module/proc/remove_ability(obj/item/rig_suit/target)

/obj/item/rig_module/emp_act(severity)
	. = ..()

/obj/item/rig_module/emag_act(mob/user, obj/item/card/emag/E)
	. = ..()

/obj/item/rig_module/attackby(obj/item/I, mob/living/user, params)
	. = ..()

