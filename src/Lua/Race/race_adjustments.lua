-- [[ No damage on countdown ]] --

local addHook = addHook

local nodmgracecd = CV_RegisterVar({
	name = "race_nocountdowndamage",
	defaultvalue = 1,
	PossibleValue = CV_TrueFalse,
	flags = CV_NETVAR,
})

local function RaceCountdownNoDMG(mo, mo2)
	if not nodmgracecd.value then return end
	if not (gametyperules & GTR_RACE) then return end
	if not (mo and mo.valid) then return end
	if (leveltime < 4*TICRATE) or (mo.player.realtime == 0) then
		return false
	end

	if not (mo2 and mo2.valid) then return end

	if mo2.type == MT_SPINFIRE --from elemental shield
	and not mo.player.powers[pw_flashing] then
		return true
	end
end

addHook("ShouldDamage", RaceCountdownNoDMG, MT_PLAYER)
