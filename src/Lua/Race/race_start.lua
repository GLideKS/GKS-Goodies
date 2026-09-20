-- [[ Race Start Music ]] --

local P_RandomRange = P_RandomRange
local S_ChangeMusic = S_ChangeMusic
local addHook = addHook
local GTR_RACE = GTR_RACE

local racestartmusic = CV_RegisterVar({
	name = "race_startmusic",
	defaultvalue = 1,
	PossibleValue = CV_TrueFalse,
	flags = CV_NETVAR,
})

addHook("MapLoad", function()
	if not racestartmusic.value then return end
	if not (gametyperules & GTR_RACE) then return end
	if mapheaderinfo[gamemap].noracestartmusic then return end

	local racestartmus = GKSGoodies.racestart_musics[P_RandomRange(1, #GKSGoodies.racestart_musics)]
	S_ChangeMusic(racestartmus, false, player)
end)

-- [[ Restore the map's music if start countdown is over ]] --

addHook("ThinkFrame", function()
	if not racestartmusic.value then return end
	if not (gametyperules & GTR_RACE) then return end
	if mapheaderinfo[gamemap].noracestartmusic then return end

	if leveltime == 140 then
		S_ChangeMusic(mapmusname, true, player)
	end
end)