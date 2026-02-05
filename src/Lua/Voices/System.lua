--Script by GLide KS
--TODO: Add command to switch this

if not GKSR_Voices then
	rawset(_G, "GKSR_Voices", {})
end

local GKSR_Voices = GKSR_Voices
local GoodiesHook = GoodiesHook

local voicesdir = "Voices/"

dofile(voicesdir.. "Freeslots")
dofile(voicesdir.. "Definition")

local sfx_defset = sfx_defset
local sfx_defgo = sfx_defgo
local sfx_defred = sfx_defred

GoodiesHook.PlayerThink.VoicesSys = function(p)
	local check_lapcount = (CV_FindVar("numlaps").value) or (mapheaderinfo[gamemap].numlaps) or 4
	local voices_toggle = CV_FindVar("race_charactervoices") and CV_FindVar("race_charactervoices").value

	if not (p.mo and p.mo.valid and (gametyperules & GTR_RACE)) then return end --previous checks
	if voices_toggle and GKSR_Voices[p.mo.skin] then
/*--------------GOAL SOUNDS---------------*/
		if p.laps >= check_lapcount or p.pflags & PF_FINISHED then
			if GKSR_Voices[p.mo.skin].victory
			and not p.mo.victorysoundplayed then
				S_PlayCharVoice(p.mo, p.mo.skin, "victory")
				p.mo.victorysoundplayed = true
			end
		elseif p.mo.victorysoundplayed then
			p.mo.victorysoundplayed = false
		end
/*--------------HURRY SOUNDS---------------*/
		if p.mo.hurry_voice and not p.mo.hurryplayedsound
		and GKSR_Voices[p.mo.skin].hurry
		and not (p.laps >= check_lapcount or p.pflags & PF_FINISHED) then
			S_PlayCharVoice(p.mo, p.mo.skin, "hurry")
			p.mo.hurryplayedsound = true
		end
/*--------------READY SOUNDS---------------*/
		if leveltime == 25
		and GKSR_Voices[p.mo.skin].ready then
			S_PlayCharVoice(p.mo, p.mo.skin, "ready", p)
		end
/*--------------GO SOUNDS---------------*/
		if leveltime == 140
		and GKSR_Voices[p.mo.skin].go then
			S_PlayCharVoice(p.mo, p.mo.skin, "go", p)
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