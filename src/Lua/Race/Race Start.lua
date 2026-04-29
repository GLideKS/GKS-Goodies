--Race Start music
BundleHook("MapLoad", "RaceStartMus", function()
	if not (gametyperules & GTR_RACE) then return end
	if mapheaderinfo[gamemap].noracestartmusic then return end

	local racestartmus = GKSGoodies.racestart_musics[P_RandomRange(1, #GKSGoodies.racestart_musics)]
	S_ChangeMusic(racestartmus, false, player)
end)

--Restore the map's music if start countdown is over
BundleHook("ThinkFrame", "RestoreMapMusic", function()
	if not (gametyperules & GTR_RACE) then return end
	if mapheaderinfo[gamemap].noracestartmusic then return end

	if leveltime == 140 then
		S_ChangeMusic(mapmusname, true, player)
	end
end)