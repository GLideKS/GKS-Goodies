-- Code by GLide KS

-- [[ Set up the map's next level, the code behavior will rely on this. ]] --

local custom_exits = {} -- sets a custom exit on map load
local force_customexit = {} -- sets a custom exit when there's enough players. Useful to override map's custom exit as well.

addHook("NetVars", function (net) -- Should be synched in the netgames
    custom_exits = net($)
    force_customexit = net($)
end)

local function SetCustomExitFromMap(map, skipstats)
    if not custom_exits[map] then return end
    local newexit = custom_exits[map]
    G_SetCustomExitVars(newexit, skipstats)
end

local function IDAndName(map)
    return G_BuildMapTitle(map).." ["..G_BuildMapName(map).."]"
end

-- [[ Commands ]] --

COM_AddCommand("custommapexit", function(p, map, nextmap, force)
    local yes = "yes" or "1" or "true" or "on"
    if force == yes then force = true end
    map = tonumber(map)
    nextmap = tonumber(nextmap)

    if map == nil then -- Find the map
        CONS_Printf(p, "\nChanges the <map>'s next level. Once completion, the map changes to the <nextmap>'s.")
        CONS_Printf(p, "if <force> is on, will override the custom next level in the map if any.\n")
        CONS_Printf(p, "NOTE: Map IDs must be in extended map numbers\n")
        CONS_Printf(p, "EXAMPLE: custommapexit <map> <nextmap> <force>")
        CONS_Printf(p, "EXAMPLE: custommapexit 01 05 true\n")
        return
    elseif not G_FindMapByNameOrCode(map) then -- Is a valid map?
        CONS_Printf(p, "\x85".."Invalid map.")
        return
    elseif custom_exits[map] then -- Does it have a custom exit already?
        if (nextmap == nil or not G_FindMapByNameOrCode(nextmap)) or custom_exits[map] == nextmap then
            CONS_Printf(p, "\x87".."This map already contains a custom exit : "..IDAndName(custom_exits[map]))
            return
        else
            CONS_Printf(p, "\x82".."Overriding exising custom exit...")
        end
    end

    if nextmap == nil or not G_FindMapByNameOrCode(nextmap) then -- Find the next map
        CONS_Printf(p, "Invalid nextmap to override.")
        return
    end

    custom_exits[map] = nextmap -- If both of these are found, do the changes
    CONS_Printf(p, "\x83"..IDAndName(map).." next level is now: "..IDAndName(nextmap))

    if gamemap == map then -- If the map given is the same one we're in, apply directly.
        SetCustomExitFromMap(map)
    end

    if force then -- If force, will override the custom next level in the map if any
        force_customexit[map] = true
    end
end, COM_ADMIN)

COM_AddCommand("custommapexit_remove", function(p, map) -- Seems weird when trying to remove a custom exit from the list so betet
    map = tonumber(map)

    if map == nil then -- Find the map in the list
        CONS_Printf(p, "\nRemoves the <map>'s custom exit setted up with custommapexit command.\n")
        CONS_Printf(p, "NOTE: Map IDs must be in extended map numbers\n")
        CONS_Printf(p, "EXAMPLE: custommapexit_remove <map>")
        CONS_Printf(p, "EXAMPLE: custommapexit_remove 01\n")
        return
    elseif not custom_exits[map] then
        CONS_Printf(p, "\x87".."This map doesn't have a custom exit set to be removed.")
        return
    end

    custom_exits[map] = nil  -- Remove it from the list

    if force_customexit[map] then
        force_customexit[map] = nil -- Remove it from the forced list if available
    end

    if gamemap == map then -- If the map given is the same one we're in, apply directly.
        G_SetCustomExitVars(mapheaderinfo[gamemap].nextlevel)
    end

    CONS_Printf(p, "\x83"..IDAndName(map).." custom exit has been removed sucessfully.")
end, COM_ADMIN)

COM_AddCommand("custommapexit_clear", function(p) -- Seems weird when trying to remove a custom exit from the list so better comment this.
    for i,v in pairs(custom_exits) do -- According to Jisk, net synched tables should be removed like this.
        custom_exits[i] = nil
    end

    for i,v in pairs(force_customexit) do
        force_customexit[i] = nil
    end
    CONS_Printf(p, "\x83".."Custom exits has been cleared sucessfully.")
end, COM_ADMIN)

COM_AddCommand("custommapexit_list", function(p)
    CONS_Printf(p, "\x82".."List of maps with custom exits:\n")

    for map, nextmap in pairs(custom_exits) do
        local string = IDAndName(map).." --> "..IDAndName(nextmap)
        local forced = force_customexit[map] and "\x83".." (Forced: Yes)" or "\x85".." (Forced: No)"

        CONS_Printf(p, string..forced)
    end
end, COM_ADMIN)

-- [[ Main behavior ]] --

local function CustomExitOverride()
    if gamestate != GS_LEVEL then return end
    if not force_customexit[gamemap] then return end
    if not custom_exits[gamemap] then return end
    if not G_EnoughPlayersFinished() then return end

    SetCustomExitFromMap(gamemap)
end

addHook("MapLoad", SetCustomExitFromMap)
addHook("ThinkFrame", CustomExitOverride)
