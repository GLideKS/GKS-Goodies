-- Code by GLide KS

local mapstoclear_emeralds = {} -- List of maps that will contain a custom exit.

addHook("NetVars", function(net) -- Should be synched in the netgames
    mapstoclear_emeralds = net($)
end)

local function IDAndName(map) -- Return a string of the map's name and the map id
    return G_BuildMapTitle(map).." ["..G_BuildMapName(map).."]"
end

-- [[ Commands ]] --

COM_AddCommand("mapclearemeralds", function(p, map)
    map = tonumber(map)

    if map == nil then
        CONS_Printf(p, "\nClears the Chaos Emeralds on the specific <map> given when it loads.\n")
        CONS_Printf(p, "NOTE: Map IDs must be in extended map numbers\n")
        CONS_Printf(p, "EXAMPLE: mapclearemeralds <map>")
        CONS_Printf(p, "EXAMPLE: mapclearemeralds 01\n")
        return
    elseif not G_FindMapByNameOrCode(map) then -- Is a valid map?
        CONS_Printf(p, "\x85".."Invalid map.")
        return
    elseif mapstoclear_emeralds[map] then -- Does it have a custom exit already?
        CONS_Printf(p, "\x87".."This map is already assigned to clear the emeralds")
    end

    mapstoclear_emeralds[map] = true -- If both of these are found, do the changes
    CONS_Printf(p, "\x83"..IDAndName(map).." will clear the Chaos Emeralds the next time it loads.")
end, COM_ADMIN)

COM_AddCommand("mapclearemeralds_remove", function(p, map)
    map = tonumber(map)

    if map == nil then -- Find the map in the list
        CONS_Printf(p, "\nRemoves the <map> assigned to clear the Chaos Emeralds, setted up with mapclearemeralds command.\n")
        CONS_Printf(p, "NOTE: Map IDs must be in extended map numbers\n")
        CONS_Printf(p, "EXAMPLE: mapclearemeralds_remove <map>")
        CONS_Printf(p, "EXAMPLE: mapclearemeralds_remove 01\n")
        return
    elseif not mapstoclear_emeralds[map] then
        CONS_Printf(p, "\x87".."This map doesn't have a custom exit set to be removed.")
        return
    end

    mapstoclear_emeralds[map] = nil  -- Remove it from the list

    CONS_Printf(p, "\x83"..IDAndName(map).." will not clear Chaos Emeralds")
end, COM_ADMIN)

COM_AddCommand("mapclearemeralds_clear", function(p)
    for i,v in pairs(mapstoclear_emeralds) do -- According to Jisk, net synched tables should be removed like this.
        mapstoclear_emeralds[i] = nil
    end
    CONS_Printf(p, "\x83".."Maps to clear emeralds has been cleared sucessfully.")
end, COM_ADMIN)

COM_AddCommand("mapclearemeralds_list", function(p)
    CONS_Printf(p, "\x82".."List of maps that will clear the emeralds:\n")

    for map in pairs(mapstoclear_emeralds) do
        local string = IDAndName(map)

        CONS_Printf(p, string)
    end
end, COM_ADMIN)

-- [[ Main behavior ]] --

local function DipEmeralds(map)
    if not emeralds then return end
    if not mapstoclear_emeralds[map] then return end

    emeralds = 0
    S_StartSound(nil, sfx_antiri)
    chatprint("\x82".."Chaos Emeralds has been cleared!")
end

addHook("MapLoad", DipEmeralds)