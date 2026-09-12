local gd = GKSGoodies
local settings = GKSGoodies.serversettings
rawset(_G, "race_finished", false)

gBundleHook("NetVars", "Race Finish", function(net)
	race_finished = net($)
end)

-- [[ Main Hurry Up trigger ]] --

gBundleHook("ThinkFrame", "HurryUp", function()
	if not (gametyperules & GTR_RACE) then return end
	if not (gamestate & GS_LEVEL) then return end
	if race_finished then return end

	for p in players.iterate do
		if (p.pflags & PF_FINISHED) then
			local hurrymusic = gd.overtime_musics[P_RandomRange(1, #gd.overtime_musics)]

			S_ChangeGlobalMusic(hurrymusic, settings.overtime_weather, settings.overtime_sky)
			S_StartSound(nil, 43)
			P_StartQuake(3*FRACUNIT, -1)
			race_finished = true
		end
	end
end)

gBundleHook("MapLoad", "ResetRaceFinish", function()
	race_finished = false
end)

-- [[ HUD ]] --

local drawString
gBundleHook("HUD", "HurryUp HUD", function(v)
	if not (gametyperules & GTR_RACE) then return end
	if not (gamestate & GS_LEVEL) then return end
	if not race_finished then return end

	if drawString == nil then drawString = v.drawString end

	drawString(160, 170, "HURRY UP!", nil, "center") --TO-DO: Replace for a better looking hurry up graphic
end,"game")