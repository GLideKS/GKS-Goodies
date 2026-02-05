local gd = GKSGoodies

---Spawns a flag for the player
---@param p player_t
local function P_SpawnVisualFlag(p)
if (p.flagmobj and p.flagmobj.valid) then return end
	p.flagmobj = P_SpawnMobjFromMobj(p.mo, 0,0,0, MT_GKS_FLAGHOLD)
	p.flagmobj.target = p.mo
	if p.ctfteam == 1 then --Red Team
		p.flagmobj.sprite = SPR_BFLG
	elseif p.ctfteam == 2 then --Blue Team
		p.flagmobj.sprite = SPR_RFLG
	end
    p.flagmobj.frame = FF_PAPERSPRITE|B
end

--Changes the music for everyone. also you can set weather and sky for everyone if desired
---@param music string
---@param weather any
---@param sky any
local S_ChangeGlobalMusic = function(music, weather, sky)
	S_ChangeMusic(music, true, nil, 128)
	mapmusname = music
	gd.currentmusicplaying = music
	if weather and globalweather != weather then
		P_SwitchWeather(weather)
	end
	if sky then
		P_SetSkyboxMobj(nil)
		P_SetupLevelSky(sky)
	end
end

--Plays a selected character voice
local function S_PlayCharVoice(origin, charname, voiceType, playeronly)
	if not GKSR_Voices[charname] then
		error("The skin: "..charname.. " doesn't have any defined voices", 1)
	end

	local voice = GKSR_Voices[charname][voiceType]
	local randomvoice = type(voice) != "table" and voice or voice[P_RandomRange(1, #voice)]
	S_StartSound(origin, randomvoice, playeronly)
end

rawset(_G, "P_SpawnVisualFlag", P_SpawnVisualFlag)
rawset(_G, "S_ChangeGlobalMusic", S_ChangeGlobalMusic)
rawset(_G, "S_PlayCharVoice", S_PlayCharVoice)