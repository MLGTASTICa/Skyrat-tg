/datum/wires/rig_suit
	holder_type = /obj/item/rig_suit
	proper_name = "R.I.G Chassis"

/datum/wires/rig_suit/New(atom/holder)
	wires = list(
		WIRE_POWER1, WIRE_POWER2,
		WIRE_IDSCAN, WIRE_AI,
		WIRE_EJECTAI, WIRE_EJECTMODULE,
		WIRE_RESETOWNER,WIRE_UNLOCK,
	)
	..()

/datum/wires/rig_suit/on_pulse(wire)
	var/obj/item/rig_suit/RIG = holder
	switch(wire)
		if(WIRE_POWER1, WIRE_POWER2) // Short for a long while.
			if(RIG.cell)
				RIG.cell.charge -= rand(100,500)
		if(WIRE_AI) // Disable or enable AI control
			RIG.AIcontrol = !RIG.AIcontrol
		if(WIRE_EJECTAI)
			RIG.AI.forceMove(RIG.loc)
			RIG.AI = null
		if(WIRE_EJECTMODULE)
			var/obj/item/rig_module/module = pick(RIG.modules)
			module.forceMove(RIG.loc)
			RIG.modules -= module
			module.remove_ability(RIG)
		if(WIRE_RESETOWNER)
			RIG.owner_suit = null
		if(WIRE_UNLOCK)
			RIG.locked = 0
		if(WIRE_IDSCAN)
			RIG.req_access = null

/datum/wires/rig_suit/on_cut(wire, mend)
	var/obj/item/rig_suit/RIG = holder
	switch(wire)
		if(WIRE_POWER1, WIRE_POWER2) // Short out.
			if(mend && !is_cut(WIRE_POWER1) && !is_cut(WIRE_POWER2))
				RIG.powered = TRUE
			else
				RIG.powered = FALSE
		if(WIRE_AI) // Disable AI control.
			if(mend)
				RIG.AIcontrol = FALSE
			else
				RIG.AIcontrol = TRUE
		if(WIRE_UNLOCK)
			RIG.locked = 1

