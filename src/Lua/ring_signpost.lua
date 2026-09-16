// Inspired by the goal ring that Soashi's Modded Planet has.
// Thanks to Romoney5 and Medii/ip._x for the sign sprite stretching math

local function notice()
    if consoleplayer then
        print("Changes will be made in the next map load.")
    end
end

local goalring = CV_RegisterVar({
	name = "goalring",
	defaultvalue = 1,
	PossibleValue = CV_TrueFalse,
	flags = CV_NETVAR|CV_CALL,
    func = notice
})

local gr_clientsided = CV_RegisterVar({
	name = "goalring_clientsided",
	defaultvalue = 0,
	PossibleValue = CV_TrueFalse,
	flags = CV_NETVAR
})

-- [[ Main Object ]] --

SafeFreeslot("MT_RINGEXIT", "SPR_GKS_GOALRING")

-- Super Optimization
local MT_RINGEXIT = MT_RINGEXIT
local SPR_GKS_GOALRING = SPR_GKS_GOALRING
local MT_OVERLAY = MT_OVERLAY
local S_THOK = S_THOK
local S_TEAMRING = S_TEAMRING
local S_NULL = S_NULL
local RF_SEMIBRIGHT = RF_SEMIBRIGHT
local FF_FRAMEMASK = FF_FRAMEMASK
local SPR_SIGN = SPR_SIGN
local PF_FINISHED = PF_FINISHED
local MT_RING = MT_RING
local MT_BOXSPARKLE = MT_BOXSPARKLE
local MT_SIGN = MT_SIGN
local SKINCOLOR_GOLDENROD = SKINCOLOR_GOLDENROD
local addHook = addHook
local S_StartSound = S_StartSound
local P_SpawnMobjFromMobj = P_SpawnMobjFromMobj
local P_RemoveMobj = P_RemoveMobj
local P_RandomRange = P_RandomRange
local P_RandomChance = P_RandomChance
local abs = abs
local cos = cos
local FixedMul = FixedMul
local FixedDiv = FixedDiv
local FixedAngle = FixedAngle
local FU = FU

-- Ring Properties
local clear_translation = "Grayscale"
local flags = MF_NOGRAVITY|MF_NOBLOCKMAP|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOCLIPTHING|MF_SCENERY
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
    if not goalring.value then return end

    local ring = P_SpawnMobjFromMobj(mo, 0, 0, ring_height, MT_RINGEXIT)
    ring.color = SKINCOLOR_GOLDENROD -- Replaced by the finishing player's color
    ring.renderflags = $|RF_SEMIBRIGHT
	ring.spritexscale = $/2 -- Sprite scale
	ring.spriteyscale = $/2 -- Sprite scale
    ring.sprite = SPR_GKS_GOALRING
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
    ring.overlay.translation = clear_translation
    ring.overlay.dispoffset = 60
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
        local local_finished = (consoleplayer.pflags & PF_FINISHED)
        if not gr_clientsided.value then -- If not, it will search for any player
            for p in players.iterate do
                local finished = (p.pflags & PF_FINISHED)
                if not finished then continue end
                mo.target = p.mo
            end
        elseif (consoleplayer and local_finished) then -- Otherwise only for you in your screen.
            mo.target = consoleplayer.mo
        end
    elseif not mo.completed then -- Player found! let's set the corresponding sign icon and color.
        ov.translation = nil
        ov.skin = t.skin
        ov.sprite = SPR_PLAY
        ov.spriteyoffset = FixedDiv($, skins[ov.skin].highresscale) -- Offset fix for highres characters
        ov.sprite2 = SPR2_SIGN -- TODO: Make the "Clear!" stay if the character doesn't have it.
        ov.frame = A
        mo.color = t.player.skincolor
        ov.color = mo.color
        S_StartSound(mo, sfx_s243)

        local x, y, z = mo.x, mo.y, mo.z + mo.height / 2
        local radius = FixedMul(mo.info.painchance, mo.scale)
        for i = 0, 15 do
	        P_SpawnParaloop(x, y, z, radius, 7, MT_BOXSPARKLE, i*ANGLE_22h, S_NULL, true)
        end
        mo.completed = true
    end

    ov.spritexscale = abs(FixedMul(sign_scale, cos(FixedAngle(frame * ((FU * 15) / 2)))))

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
addHook("MapThingSpawn", RingSpawn, MT_SIGN)
addHook("MobjThinker", RingThinker, MT_RINGEXIT)

-- [[ Lighting System Support ]] --

if not LightObjects then rawset(_G, "LightObjects", {}) end
LightObjects[MT_RINGEXIT] = {
    scale = FU/2,
    alpha = FU/2,
    centered_offset = true,
    zoffset = 3,
    floorlight = true
}
