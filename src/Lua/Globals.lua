rawset(_G, "GKSGoodies", {
    overtime = false,
    lowtime = false,
    currentmusicplaying = mapmusname,
})

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

--Sync for everyone
GoodiesHook.NetVars.SyncValues = function(network)
	GKSGoodies = network($)
end