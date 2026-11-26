
if not established_bosses then
    rawset(_G, "established_bosses", {})
end

local bosses_list = {}

-- Toggle
local bosshud = CV_RegisterVar({
	name = "bosshud",
	defaultvalue = 1,
	PossibleValue = CV_TrueFalse
})

-- Adjust as many as you like!

local bhud_x = CV_RegisterVar({
	name = "bosshud_x",
	defaultvalue = 300,
	PossibleValue = {MIN=1, MAX=320}
})

local bhud_y = CV_RegisterVar({
	name = "bosshud_y",
	defaultvalue = 15,
	PossibleValue = {MIN=1, MAX=200}
})

local bhud_w = CV_RegisterVar({
	name = "bosshud_width",
	defaultvalue = 80,
	PossibleValue = {MIN=50, MAX=150}
})

local bhud_h = CV_RegisterVar({
	name = "bosshud_height",
	defaultvalue = 8,
	PossibleValue = {MIN=6, MAX=10}
})

-- Command to add names to be shown for desired Boss Object Types.

local textcolor = {
	["white"] = "\x80",
	["magenta"] = "\x81",
	["yellow"] = "\x82",
	["green"] = "\x83",
	["blue"] = "\x84",
	["red"] = "\x85",
	["gray"] = "\x86",
	["orange"] = "\x87",
	["sky"] = "\x88",
	["purple"] = "\x89",
	["aqua"] = "\x8A",
	["peridot"] = "\x8B",
	["azure"] = "\x8C",
	["brown"] = "\x8D",
	["rosy"] = "\x8E",
	["inverted"] = "\x8F"
}

local function P_GetObjectName(name)
    local object = "MT_"..string.upper(name)

    if mobjinfo[_G[object]] then return _G[object]
    else return false
    end
end

COM_AddCommand("bosshud_setname", function(p, mobjtype, bossname, namecolor)
    local use = "bosshud_setname <object_type> <name> [<text_color>]"
    local example = "bosshud_setname eggmobile 'Eggman' yellow"

    if not mobjtype then
        CONS_Printf(p, "\n\nAdds a name for the Boss Object Type to be shown in the boss health bar HUD.\n..\n"..
                        "Usage: "..use.."\n"..
                        "Example: "..example.."\n\n"
                    )
        CONS_Printf(p, "Available colors for <text_color>:\n\n")

        for colorname, hex in pairs(textcolor) do
            CONS_Printf(p, hex..colorname)
        end

        return
    end

    if not (mobjinfo[P_GetObjectName(mobjtype)].flags & MF_BOSS) then
        CONS_Printf(p, "\x85".."This Object Type is not a Boss.")
        return
    end

    local motype = P_GetObjectName(mobjtype)

    if bossname then
        established_bosses[motype].name = bossname
    else
        CONS_Printf(p, "Please Insert a name after.\n\n".."Example: "..example)
        return
    end

    established_bosses[motype].textcolor = textcolor[string.lower(namecolor or "white")]

    local result = established_bosses[motype].textcolor..established_bosses[motype].name
    CONS_Printf(p, "\x83".."Object Type "..P_GetObjectName(mobjtype).." name has been set to "..result)
end, COM_ADMIN)

-- [[ We should sync it. ]] --
addHook("NetVars", function(net)
    bosses_list = net($)
    established_bosses = net($)
end)

-- [[ Clear the boss list hud on each map change before setting everything up. ]] --
addHook("MapChange", function()
    for i, _ in pairs(bosses_list) do -- According to Jisk, net synched tables should be removed like this.
        bosses_list[i] = nil
    end
end)

-- [[ Establish the bosses to be appeared in the HUD. ]] --
local function Establish_Bosses()
    for i = 0, #mobjinfo - 1 do
        if established_bosses[i] then continue end
        if not (mobjinfo[i].flags & MF_BOSS) then continue end

        -- We should use MapThingSpawn for this...
        addHook("MapThingSpawn", function(mo)
            if mapheaderinfo[gamemap].bonustype != 1 then return end -- Should be in a Boss Stage

            bosses_list[#bosses_list + 1] = mo  -- Add it to show in the HUD!
        end, i)

        -- Remove it from the list on death.
        addHook("MobjDeath", function(mo)
            if mapheaderinfo[gamemap].bonustype != 1 then return end -- Should be in a Boss Stage

            for index in pairs(bosses_list) do
                if bosses_list[index] != mo then continue end
                bosses_list[index] = nil
            end
        end, i)

        established_bosses[i] = {}
    end
end

Establish_Bosses()
addHook("AddonLoaded", Establish_Bosses) -- In case we found more Bosses in the addons loaded.

-- [[ HUD ]] --

local spacing = 3

addHook("HUD", function(v)
    if not G_CoopGametype() then return end -- Of course Co-op only.
    if not bosshud.value then return end

    -- Bar
    local flags = V_SNAPTORIGHT|V_SNAPTOTOP|V_HUDTRANS
    local bar_w = bhud_w.value
    local bar_h = bhud_h.value
    local bar_x = bhud_x.value - bar_w
    local bar_y = bhud_y.value
    -- Fill
    local fill_w = bar_w - 8
    local fill_h = bar_h - 2
    local fill_x = bar_x + 4
    local fill_y = bar_y + 1

    for i in pairs(bosses_list) do
        if i > 9 then continue end -- Could happen that there's more than 9 bosses. Don't draw more bars please...
        local gap = i > 1 and (((bar_h + 8) + spacing) * (i - 1)) or 0
        local mo = bosses_list[i]

        if not mo.health then continue end

        -- Header

        local boss_name = established_bosses[mo.type].name or "Boss"
        local boss_namecolor = established_bosses[mo.type].textcolor or textcolor["white"]
        v.drawString(bar_x + (bar_w / 2), (bar_y - 7) + gap, boss_namecolor..boss_name.."\x80"..":", flags, "thin-center")

        -- Bar

        local fill_width = FixedMul(fill_w, FixedDiv(mo.health, mo.info.spawnhealth))
        local color = ((mo.health < mo.info.spawnhealth / 2) and 35 or 151)
        local bgcolor = ((mo.health < mo.info.spawnhealth / 2) and 47 or 253)

        v.drawFill(bar_x + 1, gap + bar_y + 1, bar_w, bar_h, 28|flags)
        v.drawFill(bar_x, gap + bar_y, bar_w, bar_h, 3|flags)

        v.drawFill(fill_x, gap + fill_y, fill_w, fill_h, bgcolor|flags)
        v.drawFill(fill_x + 1, gap + fill_y + 1, fill_width - 2, fill_h - 2, color|flags)
    end
end)

-- Vanilla
established_bosses[MT_EGGMOBILE].name = "Eggman"
established_bosses[MT_EGGMOBILE2].name = "Eggman"
established_bosses[MT_EGGMOBILE3].name = "Eggman"
established_bosses[MT_EGGMOBILE4].name = "Eggman"
established_bosses[MT_CYBRAKDEMON].name = "Brak Eggman"
established_bosses[MT_BLACKEGGMAN].name = "Black Eggman" -- There's a difference...
established_bosses[MT_FANG].name = "Fang"
established_bosses[MT_METALSONIC_BATTLE].name = "Metal Sonic"
