-- [[ Set up the map to be a lobby map, the code behavior will rely on this. ]] --

local lobbytime = CV_RegisterVar({
	name = "lobby_time",
	defaultvalue = 2,
	PossibleValue = CV_Natural,
    flags = CV_NETVAR
})

rawset(_G, "GD_Lobby", {
    maps = {},
    maplist = {},
    commands = nil,
    commands_onexit = nil
})

--Get how many time is left
local function getRemainingTics()
    local totalTics = (lobbytime.value * 60) * TICRATE
    local elapsedTics = leveltime
    local remainingTics = totalTics - elapsedTics
    return remainingTics
end

local function TicsToMTIME(tics, hascents) -- Copied from Zombie Escape 2
	if (tics == nil) then return "???" end

	if not hascents then
		return string.format("%02d:%02d", G_TicsToMinutes(tics), G_TicsToSeconds(tics))
	end
	return string.format("%02d:%02d.%02d", G_TicsToMinutes(tics), G_TicsToSeconds(tics), G_TicsToCentiseconds(tics))
end

addHook("NetVars", function(net) -- Should be synched in the netgames
    GD_Lobby = net($)
end)

local function IDAndName(map) -- Return a string of the map's name and the map id
    return G_BuildMapTitle(map).." ["..G_BuildMapName(map).."]"
end

-- [[ Lobby Map Commands ]] --

COM_AddCommand("lobbymap", function(p, map)
    map = tonumber(map)

    if map == nil then
        CONS_Printf(p, "\nSets the specific <map> as a lobby map. These maps can be played for a specific time before going to the next level. (Unless all players completes the map before the time runs out)\n")
        CONS_Printf(p, "NOTE: Map IDs must be in extended map numbers\n")
        CONS_Printf(p, "EXAMPLE: lobbymap <map>")
        CONS_Printf(p, "EXAMPLE: lobbymap 01\n")
        return
    elseif not G_FindMapByNameOrCode(map) then -- Is a valid map?
        CONS_Printf(p, "\x85".."Invalid map.")
        return
    elseif GD_Lobby.maps[map] then -- Is already a lobby map?
        CONS_Printf(p, "\x87".."This map is already assigned to be a lobby map")
    end

    GD_Lobby.maps[map] = true

    CONS_Printf(p, "\x83"..IDAndName(map).." has been setted up to be a lobby map sucessfully.")
end, COM_ADMIN)

COM_AddCommand("lobbymap_remove", function(p, map)
    map = tonumber(map)

    if map == nil then -- Find the map in the list
        CONS_Printf(p, "\nRemoves the lobby <map> assigned to no longer be a lobby map, setted up with lobbymap command.\n")
        CONS_Printf(p, "NOTE: Map IDs must be in extended map numbers\n")
        CONS_Printf(p, "EXAMPLE: lobbymap_remove <map>")
        CONS_Printf(p, "EXAMPLE: lobbymap_remove 01\n")
        return
    elseif not GD_Lobby.maps[map] then
        CONS_Printf(p, "\x87".."This map is not a lobby map.")
        return
    end

    GD_Lobby.maps[map] = nil  -- Remove it from the list

    CONS_Printf(p, "\x83"..IDAndName(map).." will not be a lobby map anymore.")
end, COM_ADMIN)

COM_AddCommand("lobbymap_clear", function(p)
    for i,v in pairs(GD_Lobby.maps) do -- According to Jisk, net synched tables should be removed like this.
        GD_Lobby.maps[i] = nil
    end
    CONS_Printf(p, "\x83".."All lobby maps configuration has been removed.")
end, COM_ADMIN)

COM_AddCommand("lobbymap_list", function(p)
    CONS_Printf(p, "\x82".."List of lobby maps:\n")

    for map in pairs(GD_Lobby.maps) do
        local string = IDAndName(map)

        CONS_Printf(p, string)
    end
end, COM_ADMIN)

-- [[ Lobby Commands set up ]] --

COM_AddCommand("lobby_setcommands", function(p, commands)
    if commands == nil then
        CONS_Printf(p, "\nExecutes a string of <commands> when a lobby map is loaded.\n")
        CONS_Printf(p, "EXAMPLE: lobbymap_setcommands <commands>")
        CONS_Printf(p, "EXAMPLE: lobbymap_setcommands 'ringslinger on;friendlyfire on'\n")
        return
    end

    GD_Lobby.commands = commands -- string of commands given

    CONS_Printf(p, "\x83".."These commands will be executed when a lobby map is loaded now.")
end, COM_ADMIN)

COM_AddCommand("lobby_setcommands_onexit", function(p, commands)
    if commands == nil then
        CONS_Printf(p, "\nExecutes a string of <commands> when leaving from a lobby map.\n")
        CONS_Printf(p, "EXAMPLE: lobbymap_setcommands_onexit <commands>")
        CONS_Printf(p, "EXAMPLE: lobbymap_setcommands_onexit 'ringslinger off;friendlyfire off'\n")
        return
    end

    GD_Lobby.commands_onexit = commands -- string of commands given

    CONS_Printf(p, "\x83".."These commands will be executed when leaving from a lobby map now.")
end, COM_ADMIN)

-- [[ Main behavior ]] --

addHook("MapChange", function(map)
    if not (isserver or IsPlayerAdmin(consoleplayer)) then return end

    if GD_Lobby.maps[map] and GD_Lobby.commands then -- Execute the commands on lobby map load
        COM_BufInsertText(consoleplayer, GD_Lobby.commands)
    elseif GD_Lobby.commands_onexit and GD_Lobby.maps[gamemap] then -- Only execute commands on exit if the previous map WAS a lobby map. This is why we need MapChange hook.
        COM_BufInsertText(consoleplayer, GD_Lobby.commands_onexit)
    end
end)

addHook("HUD", function (v)
    if gamestate != GS_LEVEL then return end
    if not GD_Lobby.maps[gamemap] then return end
    if not getRemainingTics() then return end

    v.drawString(160, 5, "\x82".."Break time!".."\x80".."\nExiting in "..TicsToMTIME(getRemainingTics()), V_ALLOWLOWERCASE|V_HUDTRANS, "thin-center")
end)

addHook("PostThinkFrame", function()
    if gamestate != GS_LEVEL then return end
    if not GD_Lobby.maps[gamemap] then return end
    local time = getRemainingTics()

    if time and (time <= 10 * TICRATE) and (time % TICRATE) == 0 then
        S_StartSound(nil, sfx_s1ba)
    end

    if leveltime == (lobbytime.value * 60) * TICRATE then
        if not custom_exits[gamemap] then
            G_SetCustomExitVars(nil, 2)
        end
        G_ExitLevel()
    end
end)
