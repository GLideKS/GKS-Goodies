--Script by GLide KS

if not GKSR_Voices
	rawset(_G, "GKSR_Voices", {})
end

local voicesdir = "Voices/"

dofile(voicesdir.. "Freeslots")
dofile(voicesdir.. "Definition")

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

