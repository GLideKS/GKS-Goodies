local GoodiesHook = GoodiesHook

--List of blue color variants for the Blue Team
local blue_variants = {
	SKINCOLOR_WAVE,
	SKINCOLOR_COBALT,
	SKINCOLOR_SAPPHIRE,
	SKINCOLOR_CORNFLOWER,
	SKINCOLOR_BLUE,
	SKINCOLOR_GALAXY,
	SKINCOLOR_DAYBREAK,
	SKINCOLOR_CERULEAN,
	SKINCOLOR_MARINE,
	SKINCOLOR_SKY,
	SKINCOLOR_OCEAN
}

--List of red color variants for the Red Team
local red_variants = {
	SKINCOLOR_RUBY,
	SKINCOLOR_CHERRY,
	SKINCOLOR_SALMON,
	SKINCOLOR_PEPPER,
	SKINCOLOR_RED,
	SKINCOLOR_CRIMSON,
	SKINCOLOR_GARNET,
	SKINCOLOR_KETCHUP
}

--Change the colors on player spawn
GoodiesHook.PlayerSpawn.TeamColorVariant = function(p)
	if not (gametyperules & GTR_TEAMS) then return end
	if p.ctfteam == 1 then
		p.gd_redvariant = red_variants[P_RandomRange(1, #red_variants)]
	elseif p.ctfteam == 2 then
		p.gd_bluevariant = blue_variants[P_RandomRange(1, #blue_variants)]
	end
end

local function AssignColor(mo)
	local p = mo.player
	if not (p and mo and mo.valid) then return end
	if not (gametyperules & GTR_TEAMS) then return end

	if p.ctfteam == 1 then
		if p.gd_redvariant and mo.color != p.gd_redvariant then mo.color = p.gd_redvariant end
	elseif p.ctfteam == 2 then
		if p.gd_bluevariant and mo.color != p.gd_bluevariant then mo.color = p.gd_bluevariant end
	end
end

--Main visual flag hold object
SafeFreeslot(
"MT_GKS_FLAGHOLD",
"S_GKS_FLAGHOLD"
)

states[S_GKS_FLAGHOLD] = {SPR_NULL, FF_PAPERSPRITE|A, -1, nil, nil, nil, S_GKS_FLAGHOLD}
mobjinfo[MT_GKS_FLAGHOLD] = {
    doomednum = -1,
    spawnstate = S_GKS_FLAGHOLD,
    radius = 10*FU,
    height = 40*FU,
    flags = MF_NOCLIPTHING|MF_NOCLIPHEIGHT|MF_NOGRAVITY|MF_NOBLOCKMAP
}

local MT_GKS_FLAGHOLD = MT_GKS_FLAGHOLD

--Chase always the player
local function flaghold_behavior(mo)
    local target = mo.target
    local p = target.player
    if not (target and p and p.gotflag) then
        P_RemoveMobj(mo)
        return
    end

    local f = P_MobjFlip(target)
    local x, y = cos(p.drawangle),sin(p.drawangle)

    mo.dontdrawforviewmobj = target --Don't draw in first person
	P_MoveOrigin(mo, target.x+(25*-x), target.y+(25*-y), target.z+(f*(target.height/3)))
	mo.angle = target.player.drawangle
	mo.spriteroll = target.spriteroll
	mo.scale = target.scale

	--Flip Checks
	if P_MobjFlip(target) == -1 then
		if not (mo.eflags & MFE_VERTICALFLIP) then
			mo.eflags = $|MFE_VERTICALFLIP
		end
	elseif (mo.eflags & MFE_VERTICALFLIP) then
		mo.eflags = $ & ~MFE_VERTICALFLIP
	end
end

--Spawn the flag if the player got the flag
GoodiesHook.PlayerThink.FlagHold = function (p)
    if not (p and p.mo and p.mo.valid) then return end
    if not p.gotflag then return end
    P_SpawnVisualFlag(p)
end

--Firework to the player who captured the flag
--Borrowed from BattleMod, all credits to it.

local old = {
	bluescore = 0,
	redscore = 0
}

GoodiesHook.NetVars.CTFScore = function(net)
	old = net($)
end
GoodiesHook.MapLoad.CTFScore = function()
	old.bluescore = bluescore
	old.redscore = redscore
end

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

GoodiesHook.PlayerThink.CapturedFlag = function(p)
	local pmo = p.mo
	local pstate = p.playerstate
	local fteam = p.ctfteam

	if CBW_Battle then return end --BattleMod already has this
	if not (gametyperules & GTR_TEAMFLAGS) then return end
	if not (p and pmo and pmo.valid) then return end
	if (pstate & PST_DEAD) then return end
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
end

addHook("MobjThinker", flaghold_behavior, MT_GKS_FLAGHOLD)
addHook("MobjThinker", AssignColor, MT_PLAYER)