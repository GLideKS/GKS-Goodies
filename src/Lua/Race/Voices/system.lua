SafeFreeslot("sfx_defred", "sfx_defset", "sfx_defgo")

local countdown_voice = {
    [35] = true,
    [105] = true,
    [140] = true
}

local function GetVoice(skin, vctype)
    if not GKSR_Voices[skin] then return end

    local vc_type =
    (vctype == 1 and GKSR_Voices[skin].ready)
    or (vctype == 2 and GKSR_Voices[skin].go)
    or (vctype == 3 and GKSR_Voices[skin].victory)
    or (vctype == 4 and GKSR_Voices[skin].hurry)

    return type(vc_type) == "table" and vc_type[P_RandomRange(1, #vc_type)] or vc_type
end

gBundleHook("PlayerThink", "Race_Voices", function(p)
    local mo = p.mo
    if not (gametyperules & GTR_RACE) then return end
    if not (mo and mo.valid and mo.health) then return end
    local skin = mo.skin

    -- Countdown

    if countdown_voice[leveltime] then
        if leveltime == 35 then -- READY
            S_StartSound(nil, GetVoice(skin, 1) or sfx_defred, p)
        elseif leveltime == 105 then -- SET
            if not GKSR_Voices[skin] then
                S_StartSound(nil, sfx_defset, p)
            end
        elseif leveltime == 140 then -- GO!
            S_StartSound(nil, GetVoice(skin, 2) or sfx_defgo)
        end
    end

    -- Finished victory sound

    if (p.pflags & PF_FINISHED) and not mo.racevictory then
        S_StartSound(mo, GetVoice(skin, 3) or skins[skin].soundsid[SKSPLVCT1 + P_RandomKey(4)] or sfx_none)
        mo.racevictory = true
    end
end)
