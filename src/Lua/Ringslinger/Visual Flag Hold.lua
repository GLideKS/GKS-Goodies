local GoodiesHook = GoodiesHook

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