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