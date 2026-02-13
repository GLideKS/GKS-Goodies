--Goodies Menu made with MenuLib
--TO-DO: Complete this menu

local ML = MenuLib
local buffer = ""
local bufferid = ML.newBufferID()

local com_buffer = ""
local com_bufferid = ML.newBufferID()

local button = {
    color = 11,
    outline_color,
    selected_color = 64,
    selected_outline_color,
    width = 85,
    height = 20,
    spacing = 5
}

--Main menu
ML.addMenu({
	stringId = "gd_menu",
	title = "Goodies Menu",
    width = ((button.width+button.spacing)*3/2)+5,--120,
    height = 70,

    drawer = function(v, ML, menu, props)
        local corner_x = props.corner_x + 28
		local corner_y = props.corner_y + 18

        local serversettings = ML.addButton(v, {
            id = 1,
            x = corner_x,
            y = corner_y,
            width = button.width,
            height = button.height,
            name = "Server Settings",
            color = button.color,
            selected = {
                color = button.selected_color
            },

            pressFunc = function()
                MenuLib.initMenu(MenuLib.findMenu("server"))
			end
        })

        local usersettings = ML.addButton(v, {
            id = 2,
            x = corner_x,
            y = (serversettings.y+serversettings.height)+button.spacing,
            width = button.width,
            height = button.height,
            name = "User Settings",
            color = button.color,
            selected = {
                color = button.selected_color
            },

            pressFunc = function()
                MenuLib.initMenu(MenuLib.findMenu("server"))
			end
        })
    end
})

--Server Settings
ML.addMenu({
	stringId = "server",
	title = "Server Settings",
    width = 210,
    height = 70,

    drawer = function(v, ML, menu, props)
        local corner_x = props.corner_x + 18
		local corner_y = props.corner_y + 18

        ML.addButton(v, {
            id = 1,
            x = corner_x,
            y = corner_y,
            width = button.width,
            height = button.height,
            name = "Gametype Settings",
            color = button.color,
            selected = {
                color = button.selected_color
            },

            pressFunc = function()
                MenuLib.initMenu(MenuLib.findMenu("gametypesettings"))
			end
        })

        ML.addButton(v, {
            id = 2,
            x = corner_x+button.width+5,
            y = corner_y,
            width = button.width,
            height = button.height,
            name = "Server Messages",
            color = button.color,
            selected = {
                color = button.selected_color
            },

            pressFunc = function()
                return
			end
        })

        ML.addButton(v, {
            id = 3,
            x = corner_x,
            y = corner_y+button.height+button.spacing,
            width = button.width,
            height = button.height,
            name = "Overtime Config.",
            color = button.color,
            selected = {
                color = button.selected_color
            },

            pressFunc = function()
                print("yes")
			end
        })

        ML.addButton(v, {
            id = 4,
            x = corner_x+button.width+5,
            y = corner_y+button.height+button.spacing,
            width = button.width,
            height = button.height,
            name = "Toggle features",
            color = button.color,
            selected = {
                color = button.selected_color
            },

            pressFunc = function()
                print("yes")
			end
        })
    end
})

--Gametype settings

local commands = {
    [1] = {
        text = "Match",
        tlimitcommand = "match_timelimit",
        plimitcommand = "match_pointlimit",
        tlimit = CV_FindVar("match_timelimit"),
        plimit = CV_FindVar("match_pointlimit")
    },
    [2] = {
        text = "CTF",
        tlimitcommand = "ctf_timelimit",
        plimitcommand = "ctf_pointlimit",
        tlimit = CV_FindVar("ctf_timelimit"),
        plimit = CV_FindVar("ctf_pointlimit")
    },
    [3] = {
        text = "TAG",
        tlimitcommand = "tag_timelimit",
        plimitcommand = "tag_pointlimit",
        tlimit = CV_FindVar("tag_timelimit"),
        plimit = CV_FindVar("tag_pointlimit")
    },
    [4] = {
        text = "Hide & Seek",
        tlimitcommand = "hs_timelimit",
        plimitcommand = "hs_pointlimit",
        tlimit = CV_FindVar("hs_timelimit"),
        plimit = CV_FindVar("hs_pointlimit")
    },
    [5] = {
        text = "Default",
        tlimitcommand = "default_timelimit",
        plimitcommand = "default_pointlimit",
        tlimit = CV_FindVar("default_timelimit"),
        plimit = CV_FindVar("default_pointlimit")
    },
    [6] = {
        text = "Current",
        tlimitcommand = "timelimit",
        plimitcommand = "pointlimit",
        tlimit = CV_FindVar("timelimit"),
        plimit = CV_FindVar("pointlimit")
    },
}
local copied_value = 0

ML.addMenu({
	stringId = "gametypesettings",
	title = "Gametype Settings",
    width = 270,
    height = 180,

    drawer = function(v, ML, menu, props)
        local corner_x = props.corner_x + 10
		local corner_y = props.corner_y + 18
        local btnsize = 10
        local btnpos = 68
        local tlimitpos = 15
        local plimitpos = 28
        local copypatch = v.cachePatch("GDCOPY")
        local pastepatch = v.cachePatch("GDPASTE")
        for i in pairs(commands) do
            local col = (i - 1) % 2
            local row = (i - 1) / 2
            local x = corner_x + (col * 130)
            local y = corner_y + (row * 40)

            if i > 4 then
                y = y+40
            end

            v.drawString(x, y, commands[i].text, V_YELLOWMAP)
            v.drawFill(x, y+11, 110, 1, 0)
            v.drawString(x,y+tlimitpos, "timelimit: ".. commands[i].tlimit.value, nil, "thin")
            v.drawString(x,y+28, "pointlimit: ".. commands[i].plimit.value, nil, "thin")

            local set_timelimit = ML.addButton(v, {
                id = 1,
                x = x+btnpos,
                y = y+tlimitpos-(btnsize/5),
                width = btnsize+8,
                height = btnsize,
                name = "Set",
                color = 153,
                selected = {
                    color = 149
                },

                pressFunc = function()
                    ML.startTextInput(com_buffer, com_bufferid, {
                        onenter = function()
                            ML.client.commandbuffer = commands[i].tlimitcommand.." "..ML.client.textbuffer
                        end,
                        tooltip = {"Set a number"}
                    })
                end
            })
            local copy_timelimit = ML.addButton(v, {
                id = 2,
                x = set_timelimit.x+set_timelimit.width+3,
                y = y+tlimitpos-(btnsize/5),
                width = btnsize,
                height = btnsize,
                color = 153,
                selected = {
                    color = 149
                },

                pressFunc = function()
                    copied_value = commands[i].tlimit.value
                    print(copied_value)
                end
            })
            local paste_timelimit = ML.addButton(v, {
                id = 3,
                x = copy_timelimit.x+copy_timelimit.width+3,
                y = y+tlimitpos-(btnsize/5),
                width = btnsize,
                height = btnsize,
                color = 153,
                selected = {
                    color = 149
                },

                pressFunc = function()
                    ML.client.commandbuffer = commands[i].tlimitcommand.." "..copied_value
                end
            })

            local set_pointlimit = ML.addButton(v, {
                id = 4,
                x = x+btnpos,
                y = y+plimitpos-(btnsize/5),
                width = btnsize+8,
                height = btnsize,
                name = "Set",
                color = 153,
                selected = {
                    color = 149
                },

                pressFunc = function()
                    ML.startTextInput(com_buffer, com_bufferid, {
                        onenter = function()
                            ML.client.commandbuffer = commands[i].plimitcommand.." "..ML.client.textbuffer
                        end,
                        tooltip = {"Set a number"}
                    })
                end
            })
            local copy_pointlimit = ML.addButton(v, {
                id = 5,
                x = set_pointlimit.x+set_pointlimit.width+3,
                y = y+plimitpos-(btnsize/5),
                width = btnsize,
                height = btnsize,
                color = 153,
                selected = {
                    color = 149
                },

                pressFunc = function()
                    copied_value = commands[i].plimit.value
                    print(copied_value)
                end
            })
            local paste_pointlimit = ML.addButton(v, {
                id = 3,
                x = copy_pointlimit.x+copy_pointlimit.width+3,
                y = y+plimitpos-(btnsize/5),
                width = btnsize,
                height = btnsize,
                color = 153,
                selected = {
                    color = 149
                },

                pressFunc = function()
                    ML.client.commandbuffer = commands[i].plimitcommand.." "..copied_value
                end
            })
            v.draw(copy_timelimit.x, copy_timelimit.y, copypatch)
            v.draw(paste_timelimit.x, paste_timelimit.y, pastepatch)
            v.draw(copy_pointlimit.x, copy_pointlimit.y, copypatch)
            v.draw(paste_pointlimit.x, paste_pointlimit.y, pastepatch)
        end

        v.drawString(corner_x, corner_y+85, "\x82\NOTE: \x80\Changes will apply on the next map", nil, "thin")
        v.drawFill(corner_x, corner_y+105, 240, 1, 150)
    end
})

--Server messages
--Disabled atm since menulib doesn't support longer strings lol

/*ML.addMenu({
	stringId = "servermsg",
	title = "Server messages",
    width = 270,
    height = 180,

    drawer = function(v, ML, menu, props)
        local corner_x = props.corner_x + 5
		local corner_y = props.corner_y + 18
        local btnsize = 10
        local field_width = menu.width-10
        local field_color = 29

        --prefix name
        local sname = {
            prefix = GKSGoodies.prefixcolors[GKSGoodies.serverprefix.color]..GKSGoodies.serverprefix.text,
            x = corner_x+3,
            y = corner_y+3
        }

        v.drawFill(corner_x, corner_y, field_width, 15, field_color)
        v.drawString(sname.x, sname.y, "Prefix name", V_ALLOWLOWERCASE)
        v.drawString(field_width, sname.y, sname.prefix, V_ALLOWLOWERCASE, "right")
        local edit_prefix = ML.addButton(v, {
            id = 5,
            x = field_width+2,
            y = sname.y-1,
            width = btnsize,
            height = btnsize,
            color = 153,
            selected = {
                color = 149
            },

            pressFunc = function()
                ML.startTextInput(com_buffer, com_bufferid, {
                    onenter = function()
                        ML.client.commandbuffer = "prefix_name "..ML.client.textbuffer
                    end,
                    tooltip = {"Set the server's name in the chat"}
                })
            end
        })

        local color_prefix = ML.addButton(v, {
            id = 5,
            x = edit_prefix.x+(btnsize+3),
            y = sname.y-1,
            width = btnsize,
            height = btnsize,
            color = 153,
            selected = {
                color = 149
            },

            pressFunc = function()
                ML.startTextInput(com_buffer, com_bufferid, {
                    onenter = function()
                        ML.client.commandbuffer = "prefix_color "..ML.client.textbuffer
                    end,
                    tooltip = {"Type the color for the server's name in the chat";
                               "See prefix_colorlist for a list of available colors";}
                })
            end
        })

        --Welcome message
        local welcomemsg = {
            text = GKSGoodies.welcome.message,
            sound = GKSGoodies.welcome.sound,
            x = corner_x+3,
            y = corner_y+23
        }

        v.drawFill(corner_x, corner_y+20, field_width, 15, field_color)
        v.drawString(welcomemsg.x, welcomemsg.y, "Welcome message", V_ALLOWLOWERCASE)
        v.drawString(field_width, welcomemsg.y+1, (welcomemsg.text):sub(1, 15).."...", V_ALLOWLOWERCASE, "thin-right")

        local edit_welcome = ML.addButton(v, {
            id = 5,
            x = field_width+2,
            y = welcomemsg.y-1,
            width = btnsize,
            height = btnsize,
            color = 153,
            selected = {
                color = 149
            },

            pressFunc = function()
                ML.startTextInput(com_buffer, com_bufferid, {
                    onenter = function()
                        ML.client.commandbuffer = "welcome_message "..ML.client.textbuffer
                    end,
                    tooltip = {"Type the welcome message to be shown";
                               "Current is: "..welcomemsg.text}
                })
            end
        })
    end
})*/