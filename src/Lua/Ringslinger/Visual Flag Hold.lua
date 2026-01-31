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

local function flaghold_behavior(mo)
    local target = mo.target
    local p = target.player
    if not (target and p and p.gotflag) then
        P_RemoveMobj(mo)
        return
    end

    local x, y = cos(p.drawangle),sin(p.drawangle)
    P_FollowMobj(mo, 25*-x, 25*-y, target.height/2, nil, true)
end

local function flaghold(p)
    if not (p and p.mo and p.mo.valid) then return end
    if not p.gotflag then return end

    P_SpawnVisualFlag(p)

end

addHook("MobjThinker", flaghold_behavior, MT_GKS_FLAGHOLD)
addHook("PlayerThink", flaghold)