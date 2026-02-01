--TODO: Refactor

local GoodiesHook = GoodiesHook
local racestartmus = "RCSTR"..P_RandomRange(1,4)

GoodiesHook.MapLoad.RaceStartMus = function()
	if leveltime <= 139 and (gametyperules & GTR_RACE)
	and not mapheaderinfo[gamemap].riders then
		S_ChangeMusic(racestartmus, false, player)
	end
end

GoodiesHook.ThinkFrame.RaceRestoreMusic = function()
	if leveltime == 140 and (gametyperules & GTR_RACE)
	and not mapheaderinfo[gamemap].riders then
		S_ChangeMusic(mapmusname, true, player)
	end
end