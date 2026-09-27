-- Firework to the player who captured the flag
-- Borrowed from BattleMod, all credits to it.

SafeFreeslot("MT_EFIREWORK","S_EFIREWORK0","S_EFIREWORK1","S_EFIREWORK2","S_EFIREWORK3")
local MT_EFIREWORK = MT_EFIREWORK
local S_EFIREWORK0 = S_EFIREWORK0
local S_EFIREWORK1 = S_EFIREWORK1
local S_EFIREWORK2 = S_EFIREWORK2
local MT_SUPERSPARK = MT_SUPERSPARK
local P_SpawnMobj = P_SpawnMobj
local P_IsObjectOnGround = P_IsObjectOnGround
local addHook = addHook

function A_SetSkinFirework(fw)
	S_StartSound(fw, sfx_s227)
	fw.skin = "sonic"
end

function A_AdvFireworkFrame1(fw)
	S_StartSound(fw, sfx_s3kb3)
	-- Without the below, the object is an MT_NULL (and the object errors)
	fw.sprite = SPR_PLAY
    fw.sprite2 = SPR2_XTRA
	fw.frame = D|FF_FULLBRIGHT
	fw.momz = fw.speed*2
end

function A_AdvFireworkFrame2(fw)
	fw.sprite = SPR_PLAY
    fw.sprite2 = SPR2_XTRA
	fw.frame = E|FF_FULLBRIGHT
	fw.momz = 1+fw.speed/2
end

function A_AdvFireworkFrame3(fw)
	fw.sprite = SPR_PLAY
    fw.sprite2 = SPR2_XTRA
	fw.frame = E|FF_FULLBRIGHT
	fw.momz = fw.speed
	fw.scalespeed = 1+$/4
	fw.destscale = $*2
end

mobjinfo[MT_EFIREWORK].flags = mobjinfo[MT_THOK].flags

states[S_EFIREWORK0] = {
	tics = 21, --Time before the firework actually "explodes"
	action = A_SetSkinFirework,
	flags2 = MF2_DONTDRAW,
	nextstate = S_EFIREWORK1
}

states[S_EFIREWORK1] = {
	tics = 21,
	action = A_AdvFireworkFrame1,
	nextstate = S_EFIREWORK2
}

states[S_EFIREWORK2] = {
	tics = 21,
	action = A_AdvFireworkFrame2,
	nextstate = S_NULL
}

states[S_EFIREWORK2] = {
	tics = 21,
	action = A_AdvFireworkFrame3,
	nextstate = S_NULL
}

local old = {
	bluescore = 0,
	redscore = 0
}

addHook("NetVars", function(net)
	old = net($)
end)
addHook("MapLoad", function()
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

addHook("PlayerThink", function(p)
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