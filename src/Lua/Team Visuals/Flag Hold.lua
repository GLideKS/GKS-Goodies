local pos_offset = 25 * FU -- How much will be far from the player.

SafeFreeslot("MT_GKS_FLAGHOLD")

--Localize for optimization
local MT_GKS_FLAGHOLD = MT_GKS_FLAGHOLD
local S_THOK = S_THOK

---Spawns a flag for the player
---@param p player_t
local function P_SpawnVisualFlag(p)
	local mo = p.mo

	--Cache target's stuff
    local ang = p.drawangle
    local tx = P_ReturnThrustX(mo, ang, FixedMul(- pos_offset, mo.scale))
    local ty = P_ReturnThrustY(mo, ang, FixedMul(- pos_offset, mo.scale))
    local tz = skins[mo.skin].height / 3
	mo.flagmobj = P_SpawnMobjFromMobj(mo, tx, ty, tz, MT_GKS_FLAGHOLD)

    local fmobj = mo.flagmobj
	fmobj.target = mo
	fmobj.angle = mo.angle
    fmobj.tics = -1
	fmobj.sprite = (p.ctfteam == 1 and SPR_BFLG) or SPR_RFLG
    fmobj.frame = FF_PAPERSPRITE|B
end

--Main visual flag hold object

mobjinfo[MT_GKS_FLAGHOLD] = {
    doomednum = -1,
    spawnstate = S_THOK,
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
    local tx = P_ReturnThrustX(mo, ang, FixedMul(- pos_offset, mo.scale))
    local ty = P_ReturnThrustY(mo, ang, FixedMul(- pos_offset, mo.scale))
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