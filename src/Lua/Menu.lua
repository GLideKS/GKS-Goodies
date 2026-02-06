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
    width = 230,
    height = 190,

    drawer = function(v, ML, menu, props)
        local corner_x = props.corner_x + 18
		local corner_y = props.corner_y + 18

        local gametypesettings = ML.addButton(v, {
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
                print("yes")
			end
        })
    end
})
