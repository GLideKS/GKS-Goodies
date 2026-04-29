local MT_SUPERSPARK = MT_SUPERSPARK
local MT_EFIREWORK = MT_EFIREWORK
local S_EFIREWORK0 = S_EFIREWORK0

--Firework to the player who captured the flag
--Borrowed from BattleMod, all credits to it.

local old = {
	bluescore = 0,
	redscore = 0
}

BundleHook("NetVars", "Old Score", function(net)
	old = net($)
end)
BundleHook("MapLoad", "Set Old Score", function()
	old.bluescore = bluescore
	old.redscore = redscore
end)

local DoFirework = function(mo)
	local spark = P_SpawnMobj(mo.x,mo.y,mo.z,MT_SUPERSPARK)
	if spark and spark.valid then
		spark.momz = mo.scale*4
	end
	local fw = P_SpawnMobj(mo.x,mo.y,mo.z+(mo.scale*96),MT_EFIREWORK)
	if fw and fw.valid then
		fw.speed = mo.scale
		fw.state = S_EFIREWORK0
		fw.skin = mo.skin
		fw.color = mo.color
		fw.scale = mo.scale
		fw.destscale = mo.scale*2
	end
end

BundleHook("PlayerThink", "Captured Flag FireWork", function(p)
	if not (gametyperules & GTR_TEAMFLAGS) then return end
	if CBW_Battle then return end --BattleMod already has this

	local pmo = p.mo
	local fteam = p.ctfteam

	if not (pmo and pmo.valid and pmo.health) then return end
	if not P_IsObjectOnGround(pmo) then return end

	--secondary gotflag check since p.gotflag turns 0 before the playerthink
	if p.gotflag
	and not pmo.isholdingflag then
		pmo.isholdingflag = true
	end

	if not pmo.isholdingflag then return end

	local sec = (pmo.floorrover and pmo.floorrover.sector) or pmo.subsector.sector

	--Make sure is touching the base
	local redcaptured = (fteam == 1 and (sec.specialflags & SSF_REDTEAMBASE))
	local bluecaptured = (fteam == 2 and (sec.specialflags & SSF_BLUETEAMBASE))

	--Do BattleMod's firework
	if (redcaptured or bluecaptured)
	and pmo.isholdingflag
	and ((redscore > old.redscore) or (bluescore > old.bluescore)) then
		DoFirework(pmo)
		old.redscore = redscore
		old.bluescore = bluescore
		if not p.gotflag then pmo.isholdingflag = false end
	end
end)