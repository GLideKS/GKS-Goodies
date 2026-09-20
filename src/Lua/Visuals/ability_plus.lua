-- NOTE: This doesn't add extra moveset, just visuals

SafeFreeslot("SPR_GD_SWEAT", "S_GD_SWEAT")
local SPR_GD_SWEAT = SPR_GD_SWEAT
local S_GD_SWEAT = S_GD_SWEAT

states[S_GD_SWEAT] = {SPR_GD_SWEAT, FF_ANIMATE, 6, nil, 1, 3, S_NULL}

local addHook = addHook
local S_StartSound = S_StartSound
local P_RandomRange = P_RandomRange
local P_SpawnMobjFromMobj = P_SpawnMobjFromMobj
local sfx_s3k6d = sfx_s3k6d
local CA_FLY = CA_FLY
local MT_THOK = MT_THOK
local PF_THOKKED = PF_THOKKED
local FU = FU
local tired_incoming = TICRATE * 3 / 2

addHook("PlayerThink", function(p)
    if not (p.pflags & PF_THOKKED) then return end
    local mo = p.mo
    local charability = p.charability
    if not (mo and mo.valid) then return end
    if not mo.health then return end

    if charability == CA_FLY then -- For now is just... CA_FLY
        local flight = p.powers[pw_tailsfly]

        if flight and (flight <= tired_incoming) and (flight % 15) == 0 then -- Sweating
            S_StartSound(mo, sfx_s3k6d)
            local watr = P_SpawnMobjFromMobj(mo, x, y, mo.height, MT_THOK)
            watr.state = S_GD_SWEAT
            watr.flags = $ & ~MF_NOGRAVITY
        end
    end
end)