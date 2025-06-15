--Script by GLide KS

if not GKSR_Voices
	rawset(_G, "GKSR_Voices", {})
end

--Default Voices (SONIC R)
freeslot("sfx_defset", "sfx_defgo", "sfx_defred")

--Amy Freeslot Voices
freeslot("sfx_amyvc1", "sfx_amyvc2", "sfx_amyrd", "sfx_amyhur")

--Sonic Freeslot Voices
freeslot("sfx_sncvc1", "sfx_sncvc2",  "sfx_sncrd1", "sfx_sncrd2", "sfx_sncgo",
		 "sfx_snchur")
		 
--Knuckles Freeslot Voices
freeslot("sfx_knxvc1", "sfx_knxvc2", "sfx_knxvc3", "sfx_knxvc4", "sfx_knxrd1",
		 "sfx_knxgo", "sfx_knxhr1", "sfx_knxhr2", "sfx_knxhr3")
		 
--Tails Freeslot Voices
freeslot("sfx_tlsvc1", "sfx_tlsvc2", "sfx_tlsrd1", "sfx_tlsgo", "sfx_tlshr1",
		 "sfx_tlshr2", "sfx_tlshr3")
		 
--Metal Sonic Freeslot Voices
freeslot("sfx_mtlvc1", "sfx_mtlvc2", "sfx_mtlvc3", "sfx_mtlrd1", "sfx_mtlrd2",
		 "sfx_mtlrd3", "sfx_mtlgo", "sfx_mtlhur")
		 
//-------------------Character Definitions------------------

GKSR_Voices["sonic"] = {
	ready = {sfx_sncrd1, sfx_sncrd2},
	hurry = sfx_snchur,
	go = sfx_sncgo,
	victory = {sfx_sncvc1, sfx_sncvc2}
}

GKSR_Voices["tails"] = {
	ready = sfx_tlsrd1,
	hurry = {sfx_tlshr1, sfx_tlshr2, sfx_tlshr3},
	go = sfx_tlsgo,
	victory = {sfx_tlsvc1, sfx_tlsvc2}
}

GKSR_Voices["knuckles"] = {
	ready = sfx_knxrd1,
	hurry = {sfx_knxhr1, sfx_knxhr2, sfx_knxhr3},
	go = sfx_knxgo,
	victory = {sfx_knxvc1, sfx_knxvc2, sfx_knxvc3, sfx_knxvc4}
}

GKSR_Voices["amy"] = {
	ready = sfx_amyrd,
	hurry = sfx_amyhur,
	victory = {sfx_amyvc1, sfx_amyvc2}
}

GKSR_Voices["metalsonic"] = {
	ready = {sfx_mtlrd1, sfx_mtlrd2, sfx_mtlrd3, sfx_mtlrd4},
	hurry = sfx_mtlhur,
	go = sfx_mtlgo,
	victory = {sfx_mtlvc1, sfx_mtlvc2, sfx_mtlvc3}
}

GKSR_Voices["fang"] = {
	ready = {sfx_mtlrd1, sfx_mtlrd2, sfx_mtlrd3, sfx_mtlrd4},
	hurry = sfx_mtlhur,
	go = sfx_mtlgo,
	victory = {sfx_mtlvc1, sfx_mtlvc2, sfx_mtlvc3}
}

--Play character voice function

local function PlayCharacterVoice(origin, charname, voiceType, playeronly)
    local charVoiceTable = GKSR_Voices[charname]
    if not charVoiceTable then
        return
    end

    local soundEntry = charVoiceTable[voiceType]

    if soundEntry then
        if type(soundEntry) == "table" then
            local numSounds = #soundEntry
            if numSounds > 0 then
                local randomIndex = P_RandomRange(1, numSounds)
                local soundToPlay = soundEntry[randomIndex]
                if soundToPlay then
                    S_StartSound(origin, soundToPlay, playeronly)
                end
            end
        else
            S_StartSound(origin, soundEntry, playeronly)
        end
    end
end

addHook("PlayerThink", function(player)
	local p = player
	local check_lapcount = (CV_FindVar("numlaps").value) or (mapheaderinfo[gamemap].numlaps) or 4
	if not p.victorysoundplayed
		p.victorysoundplayed = false
	end
	if p.mo and p.mo.valid and (gametyperules & GTR_RACE) --previous checks
		if GKSR_Voices[p.mo.skin]
/*--------------GOAL SOUNDS---------------*/
			if p.laps >= check_lapcount or p.pflags & PF_FINISHED
				if GKSR_Voices[p.mo.skin].victory
					if not p.victorysoundplayed then
						PlayCharacterVoice(p.mo, p.mo.skin, "victory")
						p.victorysoundplayed = true
					end
				end
			else
				p.victorysoundplayed = false
			end
/*--------------HURRY SOUNDS---------------*/

			if p.hurry_voice and not p.hurryplayedsound then
				if GKSR_Voices[p.mo.skin].hurry
					PlayCharacterVoice(p.mo, p.mo.skin, "hurry")
					player.hurryplayedsound = true
				end
			end
/*--------------READY SOUNDS---------------*/
			if leveltime == 25 then --Ready Sound
				if GKSR_Voices[p.mo.skin].ready
					PlayCharacterVoice(p.mo, p.mo.skin, "ready", p)
				end
			end
/*--------------GO SOUNDS---------------*/
			if leveltime == 140 then
				if GKSR_Voices[p.mo.skin].go
					PlayCharacterVoice(p.mo, p.mo.skin, "go", p)
				end
			end
/*--------------DEFAULT VOICE---------------*/
		else
			if leveltime == 35 then --READY
				S_StartSound(p.mo, sfx_defred, p)
			end
			if leveltime == 105 then --SET
				S_StartSound(p.mo, sfx_defset, p)
			end
			if leveltime == 140 then --GO
				S_StartSound(p.mo, sfx_defgo, p)
			end
		end
	end
end)

