rawset(_G, "GKSGoodies", {
    overtime = false,
    lowtime = false,
    currentmusicplaying = mapmusname,
	racestart_musics = {"SNCR"},
	overtime_musics = {"_OVRTM"},
	lowtime_musics = {"_PINCH"},
	serversettings = {
		overtime_sky,
		overtime_weather
	},
	serverprefix = { --For Tips
		text = "Server",
		color = "red"
	},
	tips = {
		sound = sfx_radio,
		messages = {}
	},
	welcome = {
		sound = sfx_strpst,
		message = "Welcome to the server!"
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
	GKSGoodies.currentmusicplaying = network($)
	GKSGoodies.serversettings = network($)
	GKSGoodies.overtime = network($)
	GKSGoodies.lowtime = network($)
	GKSGoodies.serverprefix = network($)
	GKSGoodies.tips = network($)
	GKSGoodies.welcome = network($)
end