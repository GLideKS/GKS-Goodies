local GoodiesHook = GoodiesHook

--Prevent damage on countdown
local function RaceCountdownNoDMG(mo)
	if not (gametyperules & GTR_RACE) then return end
	if not (mo and mo.valid) then return end
	if (leveltime < 4*TICRATE) or (mo.player.realtime == 0) then
		return false
	end
end
addHook("ShouldDamage", RaceCountdownNoDMG, MT_PLAYER)