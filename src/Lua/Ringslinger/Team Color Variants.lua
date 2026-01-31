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

local teamcolorvariants = function(p)
	if not (p and p.mo and p.mo.valid) then return end
	if not (gametyperules & GTR_TEAMS) then return end
	if p.ctfteam == 1 then
		p.mo.color = red_variants[P_RandomRange(1, #red_variants)]
	elseif p.ctfteam == 2 then
		p.mo.color = blue_variants[P_RandomRange(1, #blue_variants)]
	end
end

addHook("PlayerSpawn", teamcolorvariants)