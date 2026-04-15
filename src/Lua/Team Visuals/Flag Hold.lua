SafeFreeslot(
"MT_GKS_FLAGHOLD",
"S_GKS_FLAGHOLD"
)

--Localize for optimization
local MT_GKS_FLAGHOLD = MT_GKS_FLAGHOLD
local S_GKS_FLAGHOLD = S_GKS_FLAGHOLD
local FU = FU

--Main visual flag hold object

states[S_GKS_FLAGHOLD] = {SPR_NULL, FF_PAPERSPRITE|A, -1, nil, nil, nil, S_GKS_FLAGHOLD}
mobjinfo[MT_GKS_FLAGHOLD] = {
    doomednum = -1,
    spawnstate = S_GKS_FLAGHOLD,
    radius = 10*FU,
    height = 40*FU,
    flags = MF_NOCLIPTHING|MF_NOCLIPHEIGHT|MF_NOGRAVITY|MF_NOBLOCKMAP|MF_SCENERY
}

--Chase always the player
local function flaghold_behavior(mo)
    local t = mo.target
    local p = t.player
    if not (t and p and p.gotflag) then
        P_RemoveMobj(mo)
		t.flagmobj = nil
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

addHook("MobjThinker", flaghold_behavior, MT_GKS_FLAGHOLD)