local addHook = addHook

--Spawn an object
COM_AddCommand("gd_spawnobject", function(p, object) --Spawn object
	if not object then
		CONS_Printf(p, "Spawns an object in front of the player")
		CONS_Printf(p, "See https://wiki.srb2.org/wiki/List_of_Object_types for a list of valid object types")
		CONS_Printf(p, "")
		CONS_Printf(p, "Example: ")
		CONS_Printf(p, "gd_spawnobject MT_REDCRAWLA")
	else
		local x, y = cos(p.realmo.angle),sin(p.realmo.angle)
		local obj = P_SpawnMobjFromMobj(p.realmo, (90*x), (90*y), 0, _G[object])
		obj.angle = p.realmo.angle
	end
end, COM_ADMIN)

-- Speed Cap
CV_RegisterVar({
	name = "gd_speedcap",
	defaultvalue = 0,
	PossibleValue = {MIN = 0, MAX = FU * 50},
	flags = CV_NETVAR|CV_FLOAT
})

addHook("PlayerThink", function(p)
	local mo = p.mo
	if not CV_FindVar("gd_speedcap").value then return end
	if not (mo and mo.valid and mo.health) then return end

	L_SpeedCapXY(mo, FixedMul(CV_FindVar("gd_speedcap").value, mo.scale))
end)