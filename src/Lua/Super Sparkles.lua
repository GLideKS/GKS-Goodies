local sparkle_scale = FU * 3 / 2

COM_AddCommand("toggle_supersparkles", function(p)
    if p.gd_supersparkles then
        p.gd_supersparkles = false
        CONS_Printf(p, "Super sparkles has been disabled for you")
    else
        p.gd_supersparkles = true
        CONS_Printf(p, "Super sparkles has been enabled for you")
    end
end)

local function SuperCheck(p)
    if p.powers[pw_super] then return true end --Vanilla Super Form
    if (p.solchar and p.solchar.istransformed) then return true end --Sol Forms
    if (p.powers[pw_carry] == CR_NIGHTSMODE) then return true end --NiGHTS Mode
    return false
end

local function Sparkles_Func(p)
    if p.gd_supersparkles == nil then
        p.gd_supersparkles = true
    end

    if not p.gd_supersparkles then return end
    if (leveltime % 6) != 0 then return end
    if not SuperCheck(p) then return end
    local pmo = p.mo

    if not (pmo and pmo.valid and pmo.health) then return end

    local rad = FixedDiv(pmo.radius * 5 / 4, pmo.scale)/FU
    local hei = FixedDiv(pmo.height, pmo.scale)/FU
    local scale = P_RandomRange(sparkle_scale / 2, sparkle_scale)

    local sparkle = P_SpawnMobjFromMobj(pmo,
        P_RandomRange(-rad,rad)*FU,
        P_RandomRange(-rad,rad)*FU,
        P_RandomRange(0,hei)*FU,
        MT_BOXSPARKLE
    )

    sparkle.colorized = true
    sparkle.color = pmo.color
    sparkle.spritexscale = scale
    sparkle.spriteyscale = scale
    sparkle.renderflags = $|RF_FULLBRIGHT
    P_SetObjectMomZ(sparkle, P_RandomRange(1, 2) * FU)
end

gBundleHook("PlayerThink", "SuperSparkles", Sparkles_Func)