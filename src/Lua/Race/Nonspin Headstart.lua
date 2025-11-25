local maxcharge = 25

local function TapToCharge()
    if gamestate != GS_LEVEL then return end
    for p in players.iterate do
        if not (p.mo and p.mo.valid) then continue end
        if gametype != GT_RACE then continue end
        if p.charability2 == CA2_SPINDASH then continue end

        local cmd = p.cmd
        if p.race_charge == nil then p.race_charge = 0 end

        if not (cmd.buttons & BT_ATTACK) and p.attackhold then
            p.attackhold = false
        end

        if (leveltime < 4*TICRATE) --do it only during the countdown
            if (cmd.buttons & BT_ATTACK) and not p.attackhold and p.race_charge != maxcharge then
                p.race_charge = $+1
                if p.race_charge == maxcharge then
                    S_StartSound(p.mo, sfx_s1c3)
                end
                print(p.race_charge)
                p.attackhold = true
            end
        end
    end
end
addHook("PreThinkFrame", TapToCharge)

local function ResetCharge()
    for p in players.iterate do
        p.race_charge = 0
    end
end
addHook("MapLoad", ResetCharge)

local function GOThrustCharge(p)
    if not (p.mo and p.mo.valid) then return end
    if not p.race_charge then return end
    if p.charability2 == CA2_SPINDASH then return end
    
    if leveltime == 4*TICRATE then
        P_InstaThrust(p.mo, p.mo.angle, FixedMul(p.race_charge * FRACUNIT, 4 * FRACUNIT))
        S_StartSound(p.mo, sfx_cdfm62)
    end
end
addHook("PlayerThink", GOThrustCharge)