--Race Start music
GoodiesHook.MapLoad.RaceStartMus = function()
	if leveltime <= 139 and (gametyperules & GTR_RACE)
	and not mapheaderinfo[gamemap].riders then
		local racestartmus = GKSGoodies.racestart_musics[P_RandomRange(1, #GKSGoodies.racestart_musics)]
		S_ChangeMusic(racestartmus, false, player)
	end
end

--Restore the map's music if start countdown is over
GoodiesHook.ThinkFrame.RaceRestoreMusic = function()
	if leveltime == 140 and (gametyperules & GTR_RACE)
	and not mapheaderinfo[gamemap].riders then
		S_ChangeMusic(mapmusname, true, player)
	end
end