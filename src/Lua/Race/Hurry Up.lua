local gd = GKSGoodies
local GoodiesHook = GoodiesHook
local settings = GKSGoodies.serversettings
local finished = false

GoodiesHook.NetVars.Finished = function(net)
	finished = net($)
end

--Main hurry up trigger
GoodiesHook.ThinkFrame.HurryUp = function()
	if not (gametyperules & GTR_RACE) then return end
	if not (gamestate & GS_LEVEL) then return end

	local lapcount = (CV_FindVar("numlaps").value) or (mapheaderinfo[gamemap].numlaps) or 4

	for p in players.iterate do
		if (p.laps >= lapcount or p.pflags & PF_FINISHED)
		and not finished then
			local hurrymusic = gd.overtime_musics[P_RandomRange(1, #gd.overtime_musics)]

			S_ChangeGlobalMusic(hurrymusic, settings.overtime_weather, settings.overtime_sky)
			S_StartSound(nil,43)
			P_StartQuake(3*FRACUNIT, -1)
			if not p.hurryplayedsound then p.hurryplayedsound = false end
			p.mo.hurry_voice = true
			finished = true
		end
	end
end

--Show up "Hurry up!"
local drawString
addHook("HUD", function(v,p)
	if not (gametyperules & GTR_RACE) then return end
	if not (gamestate & GS_LEVEL) then return end
	if not finished then return end

	if drawString == nil then drawString = v.drawString end

	drawString(160, 170, "HURRY UP!", videoFlags, "center") --TO-DO: Replace for a better looking hurry up graphic
end,"game")

--Reset voices on Map Load/Change
GoodiesHook.MapLoad.ResetRaceFinish = function()
	finished = false
end