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
GoodiesHook.PlayerSpawn.TeamColorVariant = function(p)
	if not (gametyperules & GTR_TEAMS) then return end
	local t = GKSGoodies.TeamColors
	if p.ctfteam == 1 then
		p.gd_redvariant = t.red[P_RandomRange(1, #t.red)]
	elseif p.ctfteam == 2 then
		p.gd_bluevariant = t.blue[P_RandomRange(1, #t.blue)]
	end
end

local function AssignColor(mo)
	if not (gametyperules & GTR_TEAMS) then return end
	local p = mo.player
	if not (p and mo and mo.valid) then return end

	if p.ctfteam == 1 then
		if p.gd_redvariant and mo.color != p.gd_redvariant then mo.color = p.gd_redvariant end
	elseif p.ctfteam == 2 then
		if p.gd_bluevariant and mo.color != p.gd_bluevariant then mo.color = p.gd_bluevariant end
	end
end

addHook("MobjThinker", AssignColor, MT_PLAYER)