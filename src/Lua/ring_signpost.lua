// Inspired by the goal ring that Soashi's Modded Planet has.
// Thanks to Romoney5 and Medii/ip._x for the sign sprite stretching math

local function notice()
    if consoleplayer then
        print("Changes will be made in the next map load.")
    end
end

CV_RegisterVar({
	name = "goalring",
	defaultvalue = 1,
	PossibleValue = CV_TrueFalse,
	flags = CV_NETVAR|CV_CALL,
    func = notice
})

-- [[ Main Object ]] --

SafeFreeslot("MT_RINGEXIT")
local MT_RINGEXIT = MT_RINGEXIT
local flags = MF_NOGRAVITY|MF_NOBLOCKMAP|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOCLIPTHING
local ring_height = 20 * FU
local ring_yoffset = 35 * FU
local sign_scale = FU / 3

mobjinfo[MT_RINGEXIT] = {
    doomednum = -1,
    spawnstate = S_TEAMRING,
    radius = mobjinfo[MT_RING].radius,
    height = 32 * FU,
    painchance = 40 * FU,
    flags = flags
}

-- [[ Replace ]] --

local function RingSpawn(mo, thing)
    if not CV_FindVar("goalring").value then return end

    local ring = P_SpawnMobjFromMobj(mo, 0, 0, ring_height, MT_RINGEXIT)
    ring.color = SKINCOLOR_GOLDENROD -- Replaced by the finishing player's color
    ring.renderflags = $|RF_SEMIBRIGHT
    ring.scale = $ * 4

    -- Overlay, used to show the Character's sign icon. 
    ring.overlay = P_SpawnMobjFromMobj(ring, 0, 0, 0, MT_OVERLAY)
    ring.overlay.target = ring
    ring.overlay.state = S_THOK
    ring.overlay.sprite = SPR_SIGN -- Replaced by the finishing player's sign sprite.
    ring.overlay.frame = S
    ring.overlay.renderflags = $|RF_SEMIBRIGHT
    ring.overlay.spriteyscale = sign_scale
    ring.overlay.spriteyoffset = ring_yoffset
    ring.overlay.translation = "Grayscale"
    ring.overlay.tics = -1
    P_RemoveMobj(mo)
    return true
end

-- [[ Ring Behavior ]] --

local function RingThinker(mo)
    if not mo.valid then return end

    local ov = mo.overlay
    local frame = mo.frame & FF_FRAMEMASK
    local t = mo.target

    if not mo.target then -- Search a player who finished first
        for p in players.iterate do
            if not (p.pflags & PF_FINISHED) then continue end
            mo.target = p.mo
        end
    elseif not mo.completed then -- Player found! let's set the corresponding sign icon and color.
        ov.translation = nil
        ov.skin = t.skin
        ov.sprite = SPR_PLAY
        ov.spriteyoffset = FixedDiv($, skins[ov.skin].highresscale) -- Offset fix for highres characters
        ov.sprite2 = SPR2_SIGN -- TODO: Make the "Clear!" stay if the character doesn't have it.
        ov.frame = A
        mo.color = t.color
        ov.color = mo.color
        S_StartSound(mo, sfx_s243)
        for i = 0, 15 do
	        P_SpawnParaloop(mo.x, mo.y, mo.z + mo.height / 2, FixedMul(mo.info.painchance, mo.scale), 7, MT_BOXSPARKLE, i*ANGLE_22h, S_NULL, true)
        end
        mo.completed = true
    end

    if ov and ov.valid then -- scales according to the ring's frame
        ov.spritexscale = abs(FixedMul(sign_scale, cos(FixedAngle(frame * ((FU * 15) / 2)))))
    end

    -- Spawn sparkles around the ring
    if (leveltime % 6) != 0 then return end
    local rad = FixedDiv(mo.radius * 5 / 4, mo.scale)/FU
    local hei = FixedDiv(mo.height, mo.scale)/FU

    local sparkle = P_SpawnMobjFromMobj(mo,
        P_RandomRange(-rad,rad)*FU,
        P_RandomRange(-rad,rad)*FU,
        P_RandomRange(0,hei)*FU,
        MT_BOXSPARKLE
    )

    if P_RandomChance(FU * 5 / 7) then
        sparkle.colorized = true
        sparkle.color = mo.color
    end
    sparkle.renderflags = $|RF_FULLBRIGHT
end

-- [[ Hook ]] --
gBundleHook("MapThingSpawn", "ExitRing Spawn", RingSpawn, MT_SIGN)
gBundleHook("MobjThinker", "ExitRing Thinker", RingThinker, MT_RINGEXIT)