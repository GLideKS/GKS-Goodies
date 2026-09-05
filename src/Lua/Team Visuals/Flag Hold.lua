local pos_offset = 25 * FU -- How much will be far from the player.

SafeFreeslot(
"MT_GKS_FLAGHOLD",
"S_GKS_FLAGHOLD"
)

--Localize for optimization
local MT_GKS_FLAGHOLD = MT_GKS_FLAGHOLD
local S_GKS_FLAGHOLD = S_GKS_FLAGHOLD
local FU = FU

---Spawns a flag for the player
---@param p player_t
local function P_SpawnVisualFlag(p)
	local mo = p.mo

	--Cache target's stuff
    local ang = p.drawangle
    local tx =  P_ReturnThrustX(mo, ang, FixedMul(- pos_offset, mo.scale))
    local ty =  P_ReturnThrustY(mo, ang, FixedMul(- pos_offset, mo.scale))
    local tz = skins[mo.skin].height / 3
	mo.flagmobj = P_SpawnMobjFromMobj(mo, tx, ty, tz, MT_GKS_FLAGHOLD)
	mo.flagmobj.target = mo
	mo.flagmobj.angle = mo.angle

	if p.ctfteam == 1 then --Red Team
		mo.flagmobj.sprite = SPR_BFLG
	elseif p.ctfteam == 2 then --Blue Team
		mo.flagmobj.sprite = SPR_RFLG
	end

    mo.flagmobj.frame = FF_PAPERSPRITE|B
end

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
    local ang = p.drawangle
    local tx =  P_ReturnThrustX(mo, ang, FixedMul(- pos_offset, mo.scale))
    local ty =  P_ReturnThrustY(mo, ang, FixedMul(- pos_offset, mo.scale))
    local tz = skins[t.skin].height / 3

	--Follow the player
	GD_FollowMobj(mo, tx, ty, tz)
    mo.scale = t.scale
end

--Spawn the flag if the player got the flag
gBundleHook("PlayerThink", "Spawn Player Team Flag", function(p)
    if p.spectator then return end
    if not p.gotflag then return end
    local pmo = p.mo
	if not (gametyperules & GTR_TEAMFLAGS) then return end
    if not (pmo and pmo.valid) then return end
	if (pmo.flagmobj and pmo.flagmobj.valid) then return end

    P_SpawnVisualFlag(p)
end)

gBundleHook("MobjThinker", "Flag Hold Behavior", flaghold_behavior, MT_GKS_FLAGHOLD)