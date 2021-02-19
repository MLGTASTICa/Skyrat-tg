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

/obj/item/rig_suit/proc/use_power(var/amount)
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
