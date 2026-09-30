SafeFreeslot("sfx_defred", "sfx_defset", "sfx_defgo")

-- Super Optimize
local S_StartSound = S_StartSound
local P_RandomRange = P_RandomRange
local P_RandomKey = P_RandomKey
local PF_FINISHED = PF_FINISHED
local addHook = addHook
local GTR_RACE = GTR_RACE

local countdown_voice = {
    [35] = true,
    [105] = true,
    [140] = true
}

local voices = CV_RegisterVar({
	name = "race_voices",
	defaultvalue = 1,
	PossibleValue = CV_TrueFalse
})

local function GetVoice(skin, vctype)
    if not GKSR_Voices[skin] then return end

    local vc_type =
    (vctype == 1 and GKSR_Voices[skin].ready)
    or (vctype == 2 and GKSR_Voices[skin].go)
    or (vctype == 3 and GKSR_Voices[skin].victory)
    or (vctype == 4 and GKSR_Voices[skin].hurry)

    return type(vc_type) == "table" and vc_type[P_RandomRange(1, #vc_type)] or vc_type
end

addHook("PlayerThink", function(p)
    if not (gametyperules & GTR_RACE) then return end
    local mo = p.mo
    if not (mo and mo.valid and mo.health) then return end

    -- Randomize before the cvar check so we should not desync when turning it on or off client side.
    local skin = mo.skin
    local v_ready = GetVoice(skin, 1)
    local v_go = GetVoice(skin, 2)
    local v_victory = GetVoice(skin, 3)
    local v_victory_alt = skins[skin].soundsid[SKSPLVCT1 + P_RandomKey(4)]
    local v_hurry = GetVoice(skin, 4)
    if not voices.value then return end

    -- Countdown

    if countdown_voice[leveltime] then
        if leveltime == 35 then -- READY
            S_StartSound(nil, v_ready or sfx_defred, p)
        elseif leveltime == 105 then -- SET
            if not GKSR_Voices[skin] then
                S_StartSound(nil, sfx_defset, p)
            end
        elseif leveltime == 140 then -- GO!
            S_StartSound(nil, v_go or sfx_defgo, p)
        end
    end

    -- Finished victory sound

    if (p.pflags & PF_FINISHED) and not mo.racevictory then
        S_StartSound(mo, v_victory or v_victory_alt or sfx_none)
        mo.racevictory = true
    end

    -- Hurry Up voice

    for otherp in players.iterate() do -- Not the optimal way, but this is for a single thing.
        if not (otherp.pflags & PF_FINISHED) then continue end
        if not (p.pflags & PF_FINISHED) and not mo.racehurry then
            S_StartSound(nil, v_hurry or sfx_none, p)
            mo.racehurry = true
        end
    end
end)
