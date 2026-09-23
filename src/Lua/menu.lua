local MENU = LugentMenu

local function COM_Execute(command)
    COM_BufInsertText(consoleplayer, command)
    S_StartSound(nil, sfx_strpst, consoleplayer)
end

local ExampleMenu = {
    {
        x_pos = 30,
        y_pos = 30,
        header_text = "Goodies Menu",
        header_color = V_YELLOWMAP,
        start_item = 2,
        previous_page = -1,
        previous_item = -1,
        no_background = false,
        scroll = true,
        entries = {
            {header = true, text = "User Options", y_pos = 0},
            {text = "Toggle Super Sparkles", action = function() COM_Execute("toggle_supersparkles") end, y_pos = 12},
            {text = "Toggle Windlines", action = function() COM_Execute("toggle_windlines") end, y_pos = 22},
            {text = "Nametags", cvar = CV_FindVar("nametags"), y_pos = 32},
            {text = "Nametag self", cvar = CV_FindVar("nametags_self"), y_pos = 42},
            {text = "Nametags scale", cvar = CV_FindVar("nametags_scale"), y_pos = 52},
            {text = "Bubble Status", cvar = CV_FindVar("bubble_status"), y_pos = 62},

            {header = true, text = "Server Options", y_pos = 74},
            {text = "Allow Ring Sharing", cvar = CV_FindVar("ring_sharing"), y_pos = 86},
            {text = "Allow Nametags", cvar = CV_FindVar("allownametags"), y_pos = 96},
            {text = "Allow Windlines", cvar = CV_FindVar("globalwindlines"), y_pos = 106},
            {text = "Friendly Fire tweaks...", y_pos = 116},
            {text = "Race/Competition tweaks...", y_pos = 126},

            /*
            {header = true, text = "Header", y_pos = 0},
            {text = "Text", y_pos = 12},
            {text = "Action", action = ExampleAction, y_pos = 22},
            {text = "CVar - Integer", cvar = ExampleCVar, y_pos = 32},
            {text = "CVar - Float", cvar = ExampleCVar2, amount = "0.25", y_pos = 42},
            {thintext = true, text = "Thin Text", y_pos = 52},
            {disabled = true, text = "Disabled Text", y_pos = 62},
            {text = "Color", color = SKINCOLOR_GREEN, y_pos = 72},
            {text = "Player", player = 0, y_pos = 100},
            {invisible = true, text = "Invisible Text & Range", range = {1000, 2000}, value = 1000, amount = 10, y_pos = 110},
            {text = "Input", input = "", y_pos = 120},
            {text = "Custom Options", options = {"Option 1", "Option 2", "Option 3", "Option 4"}, value = 1, y_pos = 144},
            */
        }
    }
}

COM_AddCommand("gd_menu", function(player)
    MENU:OpenMenu(ExampleMenu, 1)
end, COM_LOCAL)
