local GoodiesHook = GoodiesHook

SafeFreeslot(
"MT_GKS_FLAGHOLD",
"S_GKS_FLAGHOLD"
)

--Localize for optimization
local P_RandomRange = P_RandomRange
local P_RemoveMobj = P_RemoveMobj
local P_MobjFlip = P_MobjFlip
local P_MoveOrigin = P_MoveOrigin
local P_SpawnVisualFlag = P_SpawnVisualFlag
local P_SpawnMobj = P_SpawnMobj
local P_IsObjectOnGround = P_IsObjectOnGround
local GTR_TEAMS = GTR_TEAMS
local GTR_TEAMFLAGS = GTR_TEAMFLAGS
local MT_GKS_FLAGHOLD = MT_GKS_FLAGHOLD
local MT_SUPERSPARK = MT_SUPERSPARK
local MT_EFIREWORK = MT_EFIREWORK
local MT_PLAYER = MT_PLAYER
local S_GKS_FLAGHOLD = S_GKS_FLAGHOLD
local S_EFIREWORK0 = S_EFIREWORK0
local MFE_VERTICALFLIP = MFE_VERTICALFLIP
local FU = FU

local SKINCOLOR_WAVE = SKINCOLOR_WAVE
local SKINCOLOR_COBALT = SKINCOLOR_COBALT
local SKINCOLOR_SAPPHIRE = SKINCOLOR_SAPPHIRE
local SKINCOLOR_CORNFLOWER = SKINCOLOR_CORNFLOWER
local SKINCOLOR_BLUE = SKINCOLOR_BLUE
local SKINCOLOR_GALAXY = SKINCOLOR_GALAXY
local SKINCOLOR_DAYBREAK = SKINCOLOR_DAYBREAK
local SKINCOLOR_CERULEAN = SKINCOLOR_CERULEAN
local SKINCOLOR_MARINE = SKINCOLOR_MARINE
local SKINCOLOR_SKY = SKINCOLOR_SKY
local SKINCOLOR_OCEAN = SKINCOLOR_OCEAN

local SKINCOLOR_RUBY = SKINCOLOR_RUBY
local SKINCOLOR_CHERRY = SKINCOLOR_CHERRY
local SKINCOLOR_SALMON = SKINCOLOR_SALMON
local SKINCOLOR_PEPPER = SKINCOLOR_PEPPER
local SKINCOLOR_RED = SKINCOLOR_RED
local SKINCOLOR_CRIMSON = SKINCOLOR_CRIMSON
local SKINCOLOR_GARNET = SKINCOLOR_GARNET
local SKINCOLOR_KETCHUP = SKINCOLOR_KETCHUP

GKSGoodies.TeamColors = {
	--List of blue color variants for the Blue Team
	blue = {
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
	},
	--List of red color variants for the Red Team
	red = {
		SKINCOLOR_RUBY,
		SKINCOLOR_CHERRY,
		SKINCOLOR_SALMON,
		SKINCOLOR_PEPPER,
		SKINCOLOR_RED,
		SKINCOLOR_CRIMSON,
		SKINCOLOR_GARNET,
		SKINCOLOR_KETCHUP
	}
}

--Change the colors on player spawn
GoodiesHook.PlayerSpawn.TeamColorVariant = function(p)
	if not (gametyperules & GTR_TEAMS) then return end
	local t = GKSGoodies.TeamColors
	if p.ctfteam == 1 then
		p.gd_redvariant = t.red[P_RandomRange(1, #t.red)]
	elseif p.ctfteam == 2 then
		p.gd_bluevariant = t.blue[P_RandomRange(1, #t.blue)]
	end
end

local function AssignColor(mo)
	if not (gametyperules & GTR_TEAMS) then return end
	local p = mo.player
	if not (p and mo and mo.valid) then return end

	if p.ctfteam == 1 then
		if p.gd_redvariant and mo.color != p.gd_redvariant then mo.color = p.gd_redvariant end
	elseif p.ctfteam == 2 then
		if p.gd_bluevariant and mo.color != p.gd_bluevariant then mo.color = p.gd_bluevariant end
	end
end

--Main visual flag hold object

states[S_GKS_FLAGHOLD] = {SPR_NULL, FF_PAPERSPRITE|A, -1, nil, nil, nil, S_GKS_FLAGHOLD}
mobjinfo[MT_GKS_FLAGHOLD] = {
    doomednum = -1,
    spawnstate = S_GKS_FLAGHOLD,
    radius = 10*FU,
    height = 40*FU,
    flags = MF_NOCLIPTHING|MF_NOCLIPHEIGHT|MF_NOGRAVITY|MF_NOBLOCKMAP
}

--Chase always the player
local function flaghold_behavior(mo)
    local t = mo.target
    local p = t.player
    if not (t and p and p.gotflag) then
        P_RemoveMobj(mo)
        return
    end

	--Cache target's stuff
    local x, y = cos(p.drawangle),sin(p.drawangle) --position relative to angle
	local tx, ty, tz = (25*-x), (25*-y), t.height/3 --position

	--Follow the player
	GD_FollowMobj(mo, tx, ty, tz, t.scale, true)
end

--Spawn the flag if the player got the flag
GoodiesHook.PlayerThink.FlagHold = function (p)
	if not (gametyperules & GTR_TEAMFLAGS) then return end
    if not (p and p.mo and p.mo.valid) then return end
    if not p.gotflag then return end
	if p.mo.flagmobj then return end
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
	if not (gametyperules & GTR_TEAMFLAGS) then return end
	if CBW_Battle then return end --BattleMod already has this

	local pmo = p.mo
	local fteam = p.ctfteam

	if not (p and pmo and pmo.valid and pmo.health) then return end
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