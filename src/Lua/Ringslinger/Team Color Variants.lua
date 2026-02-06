local GoodiesHook = GoodiesHook

--List of blue color variants for the Blue Team
local blue_variants = {
	SKINCOLOR_WAVE,
	SKINCOLOR_COBALT,
	SKINCOLOR_SAPPHIRE,
	SKINCOLOR_CORNFLOWER,
	SKINCOLOR_BLUE,
	SKINCOLOR_GALAXY,
	SKINCOLOR_DAYBREAK,
	SKINCOLOR_CERULEAN,
	SKINCOLOR_MARINE,
	SKINCOLOR_SKY,
	SKINCOLOR_OCEAN
}

--List of red color variants for the Red Team
local red_variants = {
	SKINCOLOR_RUBY,
	SKINCOLOR_CHERRY,
	SKINCOLOR_SALMON,
	SKINCOLOR_PEPPER,
	SKINCOLOR_RED,
	SKINCOLOR_CRIMSON,
	SKINCOLOR_GARNET,
	SKINCOLOR_KETCHUP
}

--Change the colors on player spawn
--TODO: Do not reset colors after death.
--maybe use MapLoad instead and store colors in a player variable?
GoodiesHook.PlayerSpawn.TeamColorVariant = function(p)
	if not (p and p.mo and p.mo.valid) then return end
	if not (gametyperules & GTR_TEAMS) then return end
	if p.ctfteam == 1 then
		p.mo.color = red_variants[P_RandomRange(1, #red_variants)]
	elseif p.ctfteam == 2 then
		p.mo.color = blue_variants[P_RandomRange(1, #blue_variants)]
	end
end