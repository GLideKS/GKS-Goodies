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
	if not (p and p.mo and p.mo.valid) then return end
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
freeslot(
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

addHook("MobjThinker", flaghold_behavior, MT_GKS_FLAGHOLD)
addHook("MobjThinker", AssignColor, MT_PLAYER)