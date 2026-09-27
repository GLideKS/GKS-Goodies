-- TODO: In a future replace with a menu library that supports GC_ JA_ game controls to not be keyboard only
-- I doubt Lugent wants to support gamepad users sooo better find one that supports it if possible.

-- NOTE: v2.2.16 will feature CV_MENU for cvars, maybe I'll consider to use it when it comes out.

local MENU = LugentMenu

local function COM_Execute(command)
    COM_BufInsertText(consoleplayer, command)
    S_StartSound(nil, sfx_strpst, consoleplayer)
end

local GDMenu = {
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
            {text = "Bubble Status", cvar = CV_FindVar("bubble_status"), y_pos = 32},
            {text = "\x88".."Nametags...", action = function() MENU:GoToPage(2) end, y_pos = 42},

            {header = true, text = "Server Options", y_pos = 64},
            {text = "Goal Ring", cvar = CV_FindVar("goalring"), y_pos = 76},
            {text = "Per-player Goal Ring", cvar = CV_FindVar("goalring_clientsided"), y_pos = 86},
            {text = "Allow Ring Sharing", cvar = CV_FindVar("ring_sharing"), y_pos = 96},
            {text = "Allow Nametags", cvar = CV_FindVar("allownametags"), y_pos = 106},
            {text = "Allow Windlines", cvar = CV_FindVar("globalwindlines"), y_pos = 116},
            {text = "Round Control", cvar = CV_FindVar("roundcontrol"), y_pos = 126},
            {text = "Token Alternative", cvar = CV_FindVar("token_alt"), y_pos = 136},
            {text = "\x88".."Friendly Fire tweaks...", action = function() MENU:GoToPage(3) end,y_pos = 146},
            {text = "\x88".."Race/Competition tweaks...", action = function() MENU:GoToPage(4) end, y_pos = 156},
        },
        on_open = function(menu, page)
            if not (isserver or IsPlayerAdmin(consoleplayer)) then
                for i = 7, #page.entries do -- So let's assume the next entries are admin related stuff
                    if page.entries[i].header then continue end
                    page.entries[i].disabled = true
                end
            end
        end
    },
    {
        x_pos = 30,
        y_pos = 30,
        header_text = "Nametags",
        header_color = V_SKYMAP,
        start_item = 1,
        previous_page = 1,
        previous_item = 5,
        no_background = false,
        scroll = false,
        entries = {
            {text = "Nametags", cvar = CV_FindVar("nametags"), y_pos = 0},
            {text = "Scale", cvar = CV_FindVar("nametags_scale"), y_pos = 10},
            {text = "Self Nametag", cvar = CV_FindVar("nametags_self"), y_pos = 20},
            {text = "Distance", cvar = CV_FindVar("nametags_dist"), y_pos = 30},
        },
    },
    {
        x_pos = 30,
        y_pos = 30,
        header_text = "Friendly Fire Tweaks",
        header_color = V_REDMAP,
        start_item = 1,
        previous_page = 1,
        previous_item = 14,
        no_background = false,
        scroll = false,
        entries = {
            {text = "Main Toggle", cvar = CV_FindVar("friendlyfire_enhanced"), y_pos = 0},
            {text = "Hit colission", cvar = CV_FindVar("ff_collision"), y_pos = 10},
            {text = "Hit with abilities only", cvar = CV_FindVar("ff_onlyabilities"), y_pos = 20},
            {text = "Hit type", cvar = CV_FindVar("ff_hittype"), y_pos = 30},
            {text = "Momentum on hit", cvar = CV_FindVar("ff_momentum"), y_pos = 40},
        },
        thinker = function(menu, page)
            local ffenh = CV_FindVar("friendlyfire_enhanced").value
            for i = 2, #page.entries do
                if page.entries[i].header then continue end
                if ffenh then
                    page.entries[i].disabled = false
                else
                    page.entries[i].disabled = true
                end
            end
        end
    },
    {
        x_pos = 30,
        y_pos = 30,
        header_text = "Race/Competition Tweaks",
        header_color = V_SKYMAP,
        start_item = 1,
        previous_page = 1,
        previous_item = 15,
        no_background = false,
        scroll = false,
        entries = {
            {text = "Prevent damage on countdown", cvar = CV_FindVar("race_nocountdowndamage"), y_pos = 0},
            {text = "Race starting music", cvar = CV_FindVar("race_startmusic"), y_pos = 10},
            {text = "Voices", cvar = CV_FindVar("race_voices"), y_pos = 20},
        },
    }
}

COM_AddCommand("gd_menu", function(player)
    MENU:OpenMenu(GDMenu, 1)
end, COM_LOCAL)
