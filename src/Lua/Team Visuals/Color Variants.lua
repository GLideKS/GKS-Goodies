GKSGoodies.TeamColors = {
	--List of blue color variants for the Blue Team
	blue = {
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
	},
	--List of red color variants for the Red Team
	red = {
		SKINCOLOR_RUBY,
		SKINCOLOR_CHERRY,
		SKINCOLOR_SALMON,
		SKINCOLOR_PEPPER,
		SKINCOLOR_RED,
		SKINCOLOR_CRIMSON,
		SKINCOLOR_GARNET,
		SKINCOLOR_KETCHUP
	}
}

--Change the colors on player spawn

local t = GKSGoodies.TeamColors

BundleHook("PlayerSpawn", "Set Team Color", function(p)
	if not (gametyperules & GTR_TEAMS) then return end

	if p.ctfteam == 1 then p.mo.color = t.red[P_RandomRange(1, #t.red)] --Red team
	elseif p.ctfteam == 2 then p.mo.color = t.blue[P_RandomRange(1, #t.blue)] end --Blue team
end)