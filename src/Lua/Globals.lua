rawset(_G, "GKSGoodies", {
    overtime = false,
    lowtime = false,
    currentmusicplaying = mapmusname,
	racestart_musics = {"RCSTR1", "RCSTR2", "RCSTR3", "RCSTR4"},
	overtime_musics = {"_OVRTM", "OVTM1", "OVTM2", "HURRY1", "HURRY2", "HURRY3"},
	lowtime_musics = {"_PINCH", "LWTM1", "LWTM2", "LWTM3", "LWTM4", "LWTM5"},
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
	GKSGoodies = network($)
end