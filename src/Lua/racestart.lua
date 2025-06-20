--TODO: Refactor

local racestartmus = "RCSTR"..P_RandomRange(1,4)

addHook("MapLoad", function()
	if leveltime <= 139 and (gametyperules & GTR_RACE)
	and not mapheaderinfo[gamemap].riders then
		S_ChangeMusic(racestartmus, false, player)
	end
end)

addHook("ThinkFrame", function()
	if leveltime == 140 and (gametyperules & GTR_RACE)
	and not mapheaderinfo[gamemap].riders then
		S_ChangeMusic(mapmusname, true, player)
	end
end)