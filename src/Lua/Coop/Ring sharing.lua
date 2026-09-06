// Inspired by Chaos Mode ring sharing.

local rshare = CV_RegisterVar({ -- Global command
	name = "ring_sharing",
	defaultvalue = 1,
	PossibleValue = CV_TrueFalse,
	flags = CV_NETVAR
})

-- [[ Object Definition ]] --

SafeFreeslot("MT_RINGHOLD", "MT_RINGSHARE")
local MT_RINGHOLD = MT_RINGHOLD -- Let's apply some optimization here...
local MT_RINGSHARE = MT_RINGSHARE
local ringhold_flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOBLOCKMAP|MF_SCENERY|MF_NOGRAVITY
local ringshare_mobj_flags = MF_SLIDEME|MF_SPECIAL
local share_button = BT_ATTACK

mobjinfo[MT_RINGHOLD] = { -- Object when the player is holding the ring
    doomednum = -1,
    spawnstate = S_THOK,
    flags = ringhold_flags,
    radius = 15*FU,
    height = 15*FU
}

mobjinfo[MT_RINGSHARE] = { -- The Ring to share with players.
    doomednum = -1,
    spawnstate = S_RRNG1, -- We will disable the effect of A_ThrownRing below.
    deathstate = S_SPRK1,
    flags = ringshare_mobj_flags,
    radius = 16*FU,
    height = 24*FU
}

function A_ThrownRing(actor, var1, var2) -- I don't want to make extra states just for the collectible ring.
    if actor.type == MT_RINGSHARE then return end
    super(actor, var1, var2)
end

-- [[ Main Function ]] --

local function RingShare(p) -- Player's ring sharing functionality
    if not rshare.value then return end
    if not G_CoopGametype() then return end -- Only Co-Op
    if p.spectator then return end -- I saw cases...
    if not p.rings then return end
    local mo = p.mo
    if not (mo and mo.valid and mo.health) then return end

    local button = p.cmd.buttons
    local lastbuttons = p.lastbuttons

    -- Main activation and giving rings
    if (button & share_button) and not (lastbuttons & share_button) then
        if (button & BT_TOSSFLAG) then -- Hold Toss Flag to toggle ring sharing.
            if not mo.giveringsmode then
                local ang = p.drawangle - ANGLE_90
                local dist = mo.radius * 3 / 2
                local x = P_ReturnThrustX(mo, ang, dist)
                local y = P_ReturnThrustY(mo, ang, dist)
                local z = (mo.height / 2)
                local ring_hand = P_SpawnMobjFromMobj(mo, x, y, z, MT_RINGHOLD)
                ring_hand.target = mo
                ring_hand.tics = -1
                ring_hand.frame = FF_SEMIBRIGHT|A
                ring_hand.sprite = SPR_RING
                ring_hand.spriteyoffset = - (7 * FU)
                S_StartSound(mo, sfx_cdfm24)
                mo.giveringsmode = true
            else
                S_StartSound(mo, sfx_antiri)
                mo.giveringsmode = false
            end
        elseif mo.giveringsmode then -- If not, then just drop the ring.
            local x = P_ReturnThrustX(mo, mo.angle, 3 * FU)
            local y = P_ReturnThrustY(mo, mo.angle, 3 * FU)
            local z = (skins[mo.skin].height / 2)

            local ring = P_SpawnMobjFromMobj(mo, x, y, z, MT_RINGSHARE)
            ring.target = mo
            ring.fuse = 5 * TICRATE
            ring.scale = $ * 3 / 2
            ring.color = mo.color
            P_GivePlayerRings(p, -1)
            S_StartSound(mo, sfx_ngjump)
            P_InstaThrust(ring, mo.angle, FixedMul(20 * FU, mo.scale))
            P_SetObjectMomZ(ring, 2 * FU)
        end
    end
end

local function RingHand(mo) -- Ring on hand for the player
    local t = mo.target

    if not (t and t.valid and t.health) then
        P_RemoveMobj(mo)
        return
    end

    if not t.giveringsmode or not rshare.value or not t.player.rings then
        t.giveringsmode = false
        P_RemoveMobj(mo)
        return
    end

    local ang = t.player.drawangle - ANGLE_90
    local dist = t.radius * 3 / 2
    local x = P_ReturnThrustX(t, ang, dist)
    local y = P_ReturnThrustY(t, ang, dist)
    local z = (skins[t.skin].height / 2)

    mo.scale = t.scale
    GD_FollowMobj(mo, x, y, z)
end

local function RingMobj_Touch(mo, toucher) -- Shared ring on touch
    if mo.target == toucher then return true end -- Don't collect our own ring
    P_GivePlayerRings(toucher.player, 1)
    S_StartSound(toucher, sfx_itemup)
end

-- Hook everything
gBundleHook("PlayerThink", "Ring_Sharing", RingShare)
gBundleHook("MobjThinker", "RingHand", RingHand, MT_RINGHOLD)
gBundleHook("TouchSpecial", "ShareRing_Mobj", RingMobj_Touch, MT_RINGSHARE)