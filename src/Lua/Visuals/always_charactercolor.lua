-- Makes the player always use the default skincolor of their selected skin, even if they change skins mid-game.
-- Similar to my NoChangeSkinMove lua script

-- Allow the player to do this?
-- The reason of this cvar is there's gamemodes that will not like this at all. So just in case.
local allowcharcolor = CV_RegisterVar({
	name = "allowcharcolor",
	defaultvalue = 1,
	PossibleValue = CV_TrueFalse,
    flags = CV_NETVAR,
})

local user_color = CV_FindVar("color").value

local function SetSkinPrefColor(p)
    if not allowcharcolor.value then return end -- The server disabled this, don't run it.

    local pmo = p.mo
    local skin = skins[p.skin].name
    local issolchar = (p.solchar and p.solchar.istransformed)
    local isteamed = G_GametypeHasTeams()

    p.skincolor = p.gd_alwayscharcolor and skins[skin].prefcolor or user_color
    if (p.mo and p.mo.valid) and not (issolchar or isteamed) then -- Sol Forms doesn't use pw_super so better exclude them from this check. UNTESTED.
        pmo.color = p.skincolor
    end
end

COM_AddCommand("alwayscharcolor", function(p)
    if not p.gd_alwayscharcolor then
        p.gd_alwayscharcolor = true
        SetSkinPrefColor(p)
        CONS_Printf(p, "Now you will always carry the default skincolor.")
    else
        p.gd_alwayscharcolor = false
        SetSkinPrefColor(p)
        CONS_Printf(p, "You will no longer always carry the default skincolor.")
    end
end)

local function compare_and_update() -- PreThinkFrame
    if gamestate != GS_LEVEL then return end

    for p in players.iterate() do
        if not p.gd_alwayscharcolor then continue end
        local pmo = p.mo
        local skin = skins[p.skin].name

        if not (pmo and pmo.valid) then continue end

        if (pmo.oldskin and pmo.oldskin != skin) then -- Only change it if the skin just changed
            SetSkinPrefColor(p)
        end
    end
end

local function saveskin(p) --PlayerThink runs AFTER PreThinkFrame
    if not p.gd_alwayscharcolor then return end
    local mo = p.mo
    if not (mo and mo.valid) then return end
    mo.oldskin = skins[p.skin].name --Save the old skin to compare
end

addHook("PreThinkFrame", compare_and_update)
addHook("PlayerThink", saveskin)
addHook("PlayerSpawn", function(p)
    if p.gd_alwayscharcolor then SetSkinPrefColor(p) end -- Set it when respawning as well.
end, MT_PLAYER)
