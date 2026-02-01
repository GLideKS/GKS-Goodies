local maxcharge = 20

--Tap to charge mechanic
GoodiesHook.PreThinkFrame.TapToCharge = function()
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

        if (leveltime < 4*TICRATE) then --do it only during the countdown
            if (cmd.buttons & BT_ATTACK) and not p.attackhold and p.race_charge ~= maxcharge then
                p.race_charge = $+1
                S_StartSound(p.mo, sfx_thok)
                if p.race_charge == maxcharge then
                    S_StartSound(p.mo, sfx_s1c3)
                end
                print(p.race_charge)
                p.attackhold = true
            end
        end
    end
end

GoodiesHook.MapLoad.ResetCharge = function()
    for p in players.iterate do
        p.race_charge = 0
    end
end

GoodiesHook.PlayerThink.GOThrustCharge = function(p)
    if not (p.mo and p.mo.valid) then return end
    if not p.race_charge then return end
    if p.charability2 == CA2_SPINDASH then return end

    if leveltime == 4*TICRATE then
        P_InstaThrust(p.mo, p.mo.angle, FixedMul(p.race_charge * FRACUNIT, 3 * FRACUNIT))
        P_SpawnSkidDust(p, 10*p.mo.scale, false)
        P_SpawnSkidDust(p, 10*p.mo.scale, false)
        P_SpawnSkidDust(p, 10*p.mo.scale, false)
        P_SpawnSkidDust(p, 10*p.mo.scale, false)
        S_StartSound(p.mo, sfx_cdfm62)
        P_MovePlayer(p)
    end
end

--HUD
local function DrawChargeHUD(v, p)
    if p.charability2 == CA2_SPINDASH then return end
    if gametype != GT_RACE then return end
    if leveltime >= 4*TICRATE then return end

    local chargehudx, chargehudy = 276,31
    local charge_flags = V_SNAPTORIGHT
    local charge_width = 13
    local charge_height = 140
    local charge_color

    if p.race_charge == maxcharge then
        charge_color = 73
    else
        charge_color = 0
    end

    local showcharge

    v.drawString(chargehudx+(charge_width/2), chargehudy-10, "Charge!" , charge_flags, "center")

    local fill_height = FixedMul(p.race_charge * FRACUNIT, charge_height * FRACUNIT) / (maxcharge * FRACUNIT)
    v.drawFill(chargehudx, chargehudy, charge_width, charge_height, 31|charge_flags)
    v.drawFill(chargehudx+2, chargehudy+((charge_height+2)-fill_height), charge_width-4, fill_height-4, charge_color|charge_flags)
end
addHook("HUD", DrawChargeHUD)