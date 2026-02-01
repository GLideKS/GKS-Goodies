rawset(_G, "GKSGoodies", {
    overtime = false,
    lowtime = false,
    currentmusicplaying = mapmusname,
})
local gd = GKSGoodies
--Sync for everyone
addHook("NetVars", function(network)
	gd.overtime = network($)
	gd.lowtime = network($)
	gd.currentmusicplaying = network($)
end)

--Hook functions to pack everything in a single addHook for each
local GoodiesHook = {
    PreThinkFrame = {},
	ThinkFrame = {},
	PlayerSpawn = {},
    PlayerThink = {},
	MapLoad = {},
	MapChange = {},
	NetVars = {},
}
rawset(_G, "GoodiesHook", GoodiesHook)