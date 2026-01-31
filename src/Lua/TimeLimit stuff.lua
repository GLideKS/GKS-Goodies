local LowTime_Trigger = 30*TICRATE

local function getRemainingTics()
    local totalTics = timelimit * 60 * TICRATE
    local elapsedTics = leveltime
    local remainingTics = totalTics - elapsedTics
    return remainingTics
end

local overtime
local lowtime
local currentmusicplaying = mapmusname
local ptsr_chance = P_RandomChance(FU/7) --around 14% chance. very low

local lowtime_musics = {
	"_PINCH", "LWTM1", "LWTM2", "LWTM3", "LWTM4", "LWTM5"
}
local overtime_musics = {
	"_OVRTM", "OVTM1", "OVTM2"
}

local S_ChangeGlobalMusic = function(music, weather, sky)
	S_ChangeMusic(music, true, nil, 128)
	mapmusname = music
	currentmusicplaying = music
	if weather and globalweather != weather then
		P_SwitchWeather(weather)
	end
	if sky then
		P_SetSkyboxMobj(nil)
		P_SetupLevelSky(sky)
	end
end

local timelimitchanges = function()
	if gamestate != GS_LEVEL then return end
	if not gamemap then return end
	if (gametyperules & GTR_RINGSLINGER|GTR_TIMELIMIT) and timelimit then
		--Low Time
		if getRemainingTics() > 0 and (getRemainingTics() <= LowTime_Trigger
		or ((redscore == pointlimit-1) or (bluescore == pointlimit-1)))
		and not lowtime then
			local lowtmmus = lowtime_musics[P_RandomRange(1, #lowtime_musics)]
			S_ChangeGlobalMusic(lowtmmus)
			lowtime = true
		end
		--Overtime
		if ((getRemainingTics() == 0)
		or ((redscore == pointlimit-1 and bluescore == pointlimit-1) and gametype == (GT_RSRCTF or GT_CTF)))
		and not overtime then
			local ovtmmus
			if not ptsr_chance then
				ovtmmus = overtime_musics[P_RandomRange(1, #overtime_musics)]
				S_ChangeGlobalMusic(ovtmmus, PRECIP_STORM, 12)
			else --hehe
				S_StartSound(nil, sfx_litng2)
				S_ChangeGlobalMusic("OTPTSR", nil, 34)
			end
			overtime = true
		end
		
		--Did the player joined mid game? play the current music and weather going on
		for p in players.iterate do
			if lowtime and S_MusicName(p) != currentmusicplaying then
				S_ChangeGlobalMusic(currentmusicplaying)
			end
			if overtime and S_MusicName(p) != currentmusicplaying then
				S_ChangeGlobalMusic(currentmusicplaying, globalweather, globallevelskynum)
			end
		end
	end
end
addHook("ThinkFrame", timelimitchanges)

--Sync for everyone
addHook("NetVars", function(network)
	overtime = network($)
	lowtime = network($)
	currentmusicplaying = network($)
end)

--reset the music checks
local resetmus = function()
	overtime = false
	lowtime = false
	currentmusicplaying = mapmusname
end
addHook("MapChange", resetmus)
addHook("MapLoad", resetmus)