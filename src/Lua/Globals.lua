rawset(_G, "GKSGoodies", {
    overtime = false,
    lowtime = false,
    currentmusicplaying = mapmusname,
	serversettings = {
		ctf_config = {
			timelimit = 0,
			pointlimit = 0
		},
		match_config = {
			timelimit = 0,
			pointlimit = 0
		},
		tag_config = {
			timelimit = 0,
			pointlimit = 0
		},
		hs_config = {
			timelimit = 0,
			pointlimit = 0
		},
		overtime_sky,
		overtime_weather
	}
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