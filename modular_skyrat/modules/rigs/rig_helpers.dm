/mob/living/carbon/human/proc/equip_to_slot_forcefully(obj/item/clothing/rig_suit_holder/clothing, slot, rig)
	if(!clothing) /// Its deleted , bruh!
		return
	var/obj/item/trash = get_item_by_slot(slot)
	if(trash)
		doUnEquip(trash, TRUE, loc, FALSE, TRUE, FALSE)
		trash.forceMove(rig)
	equip_to_slot_if_possible(clothing, slot, FALSE, FALSE)
	clothing.deployed = TRUE
	switch(slot)
		if(ITEM_SLOT_GLOVES)
			update_inv_gloves()
		if(ITEM_SLOT_OCLOTHING)
			update_inv_wear_suit()
		if(ITEM_SLOT_HEAD)
			update_inv_head()
		if(ITEM_SLOT_FEET)
			update_inv_shoes()

/obj/item/rig_suit/proc/use_power(amount)
	if(!cell)
		if(powered)
			unpower_suit()
		return FALSE
	if(cell.charge < amount)
		return FALSE
	cell.charge -= amount
	return TRUE

/obj/item/rig_suit/proc/calculate_power()
	if(!cell)
		return FALSE
	calculated_power_use = 0
	for(var/obj/item/rig_module/module_target in modules)
		if(module_target.active)
			calculated_power_use += module_target.use_power
		else
			calculated_power_use += module_target.idle_power_use
	calculated_power_use += rig_power_use
	return TRUE

/obj/item/rig_suit/proc/power_suit()
	if(calculate_power())
		to_chat(wearer, text = "Succesfully calculated power")
		powered = 1
		START_PROCESSING(SSfastprocess,src)
	else
		return FALSE
	for(var/obj/item/rig_module/item in modules)
		item.add_ability(src)

/obj/item/rig_suit/proc/unpower_suit()
	for(var/obj/item/rig_module/item in modules)
		item.remove_ability(src)
	powered = 0
	STOP_PROCESSING(SSfastprocess,src)

/obj/item/rig_suit/proc/handle_module_insertion(obj/item/rig_module/module, mob/inserter)
	if(modules.len >= module_limit)
		return to_chat(inserter , text = "There are no empty module sockets to insert this module onto")
	if(module.weight > (module_weight_limit - module_weight_current))
		return to_chat(inserter , text = "This module is far too heavy to attack to the rig!")
	to_chat(inserter , text = "You insert the [module] into the [src]")
	visible_message("[inserter] inserts the [module] into [src]")
	module.moveToNullspace()
	modules.Add(module)

/obj/item/rig_suit/proc/handle_clothing_drop(obj/item/clothing/rig_suit_holder/clothing)
	wearer.dropItemToGround(clothing, force = TRUE, silent = FALSE, invdrop = TRUE)
	clothing.deployed = FALSE // This is guaranteed to have it , but to avoid redefining the object we just use a prototype acces.
	clothing.moveToNullspace()

// This things only purpose is to allow me to easily acces the deployed var
/obj/item/clothing/rig_suit_holder
	var/deployed = FALSE


