local LowTime_Trigger = 30*TICRATE
local GoodiesHook = GoodiesHook
local gd = GKSGoodies
local settings = GKSGoodies.serversettings

local function getRemainingTics()
    local totalTics = timelimit * 60 * TICRATE
    local elapsedTics = leveltime
    local remainingTics = totalTics - elapsedTics
    return remainingTics
end

GoodiesHook.ThinkFrame.timelimitchanges = function()
	if gamestate != GS_LEVEL then return end
	if CBW_Battle then return end -- BattleMod has already this kind of stuff
	if not gamemap then return end
	local ptsr_chance = P_RandomChance(FU/7) --around 14% chance. very low
	--Low Time
	if ((timelimit and (getRemainingTics() > 0 and (getRemainingTics() <= LowTime_Trigger)))
	or (((redscore == pointlimit-1) or (bluescore == pointlimit-1)) and (gametyperules & GTR_TEAMFLAGS)))
	and not gd.lowtime then
		local lowtmmus = gd.lowtime_musics[P_RandomRange(1, #gd.lowtime_musics)]
		S_ChangeGlobalMusic(lowtmmus)
		gd.lowtime = true
	end
	--Overtime
	if ((timelimit and getRemainingTics() == 0)
	or ((redscore == pointlimit-1 and bluescore == pointlimit-1) and (gametyperules & GTR_TEAMFLAGS)))
	and not gd.overtime then
		if not ptsr_chance then
			local ovtmmus = gd.overtime_musics[P_RandomRange(1, #gd.overtime_musics)]
			S_ChangeGlobalMusic(ovtmmus, settings.overtime_weather, settings.overtime_sky)
		else --hehe
			S_StartSound(nil, sfx_litng2)
			S_ChangeGlobalMusic("OTPTSR", nil, 34)
		end
		gd.overtime = true
	end
	--Did the player joined mid game? play the current music and weather going on
	for p in players.iterate do
		if gd.lowtime and S_MusicName(p) != gd.currentmusicplaying then
			S_ChangeGlobalMusic(gd.currentmusicplaying)
		end
		if gd.overtime and S_MusicName(p) != gd.currentmusicplaying then
			S_ChangeGlobalMusic(gd.currentmusicplaying, globalweather, globallevelskynum)
		end
	end
end

--reset the music checks
local resetmus = function()
	gd.overtime = false
	gd.lowtime = false
	gd.currentmusicplaying = mapmusname
end
GoodiesHook.MapChange.ResetMus = resetmus
GoodiesHook.MapLoad.ResetMus = resetmus