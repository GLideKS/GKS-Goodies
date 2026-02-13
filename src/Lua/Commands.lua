local settings = GKSGoodies.serversettings

--Defaults

CV_RegisterVar({
	name = "default_timelimit",
	defaultvalue = 6,
	PossibleValue = {MIN=0, MAX=30},
	flags = CV_NETVAR
})

CV_RegisterVar({
	name = "default_pointlimit",
	defaultvalue = 0,
	PossibleValue = CV_Unsigned,
	flags = CV_NETVAR
})

--CTF

CV_RegisterVar({
	name = "ctf_timelimit",
	defaultvalue = 0,
	PossibleValue = {MIN=0, MAX=30},
	flags = CV_NETVAR
})

CV_RegisterVar({
	name = "ctf_pointlimit",
	defaultvalue = 0,
	PossibleValue = CV_Unsigned,
	flags = CV_NETVAR
})

--Match

CV_RegisterVar({
	name = "match_timelimit",
	defaultvalue = 0,
	PossibleValue = {MIN=0, MAX=30},
	flags = CV_NETVAR
})

CV_RegisterVar({
	name = "match_pointlimit",
	defaultvalue = 0,
	PossibleValue = CV_Unsigned,
	flags = CV_NETVAR
})

--Tag

CV_RegisterVar({
	name = "tag_timelimit",
	defaultvalue = 0,
	PossibleValue = {MIN=0, MAX=30},
	flags = CV_NETVAR
})

CV_RegisterVar({
	name = "tag_pointlimit",
	defaultvalue = 0,
	PossibleValue = CV_Unsigned,
	flags = CV_NETVAR
})

--H&S

CV_RegisterVar({
	name = "hs_timelimit",
	defaultvalue = 0,
	PossibleValue = {MIN=0, MAX=30},
	flags = CV_NETVAR
})

CV_RegisterVar({
	name = "hs_pointlimit",
	defaultvalue = 0,
	PossibleValue = CV_Unsigned,
	flags = CV_NETVAR
})

--Command to set overtime's sky number and weather

local function update_overtime()
    local sky = CV_FindVar("overtime_sky") and CV_FindVar("overtime_sky").value
    local weather = CV_FindVar("overtime_weather") and CV_FindVar("overtime_weather").value
    settings.overtime_sky = sky
    settings.overtime_weather = weather
end
CV_RegisterVar({
	name = "overtime_sky",
	defaultvalue = 12,
	PossibleValue = CV_Unsigned,
	flags = CV_CALL|CV_NETVAR,
	func = update_overtime
})

CV_RegisterVar({
	name = "overtime_weather",
	defaultvalue = 1,
	PossibleValue = {MIN = 0, MAX = 6},
	flags = CV_CALL|CV_NETVAR,
	func = update_overtime
})

--Command to set overtime's sky number and weather

CV_RegisterVar({
	name = "race_charactervoices",
	defaultvalue = "On",
	PossibleValue = CV_OnOff
})

--Commands to handle server's name on chat

COM_AddCommand("prefix_name", function(p, name)
	if name then
		GKSGoodies.serverprefix.text = name
	else
		CONS_Printf(p, "Sets the server's name in the chat")
	end
end, COM_ADMIN)

COM_AddCommand("prefix_color", function(p, color)
	if color then
		if GKSGoodies.prefixcolors[color] then
			GKSGoodies.serverprefix.color = color
			CONS_Printf(p, "Server's color name in chat has been set to "..color)
		else
			CONS_Printf(p, "Invalid color. see prefix_colorlist to see a list of available colors for it.")
		end
	else
		CONS_Printf(p, "Sets the server's name color in the chat")
	end
end, COM_ADMIN)

COM_AddCommand("prefix_colorlist", function(p, name)
	CONS_Printf(p, "----List of text colors available for prefix_color----")
	CONS_Printf(p, "")
	for colorname, hex in pairs(GKSGoodies.prefixcolors) do
		CONS_Printf(p, hex..colorname)
	end
end, COM_ADMIN)

--Commands to handle tips

COM_AddCommand("tips_add", function(p, message)
	if message then
		table.insert(GKSGoodies.tips.messages, message)
		CONS_Printf(p, "Message inserted sucessfully to the tips list")
	else
		CONS_Printf(p, "Adds a message for the tips list")
	end
end, COM_ADMIN)

COM_AddCommand("tips_remove", function(p, arg)
	local index = tonumber(arg)

	if (index and GKSGoodies.tips.messages[index]) then
		table.remove(GKSGoodies.tips.messages, index)
		CONS_Printf(p, "Message removed sucessfully from the tips list")
	else
		CONS_Printf(p, "Message index not valid or not found.")
	end
end, COM_ADMIN)

COM_AddCommand("tips_list", function(p)
	if #GKSGoodies.tips.messages then
		CONS_Printf(p, "----List of tips messages stored----")
		CONS_Printf(p, "")
		for i = 1, #GKSGoodies.tips.messages do
			CONS_Printf(p, i..": "..GKSGoodies.tips.messages[i])
		end
	else
		CONS_Printf(p, "No tips messages found.")
	end
end, COM_ADMIN)

COM_AddCommand("tips_clear", function(p)
	if #GKSGoodies.tips.messages then
		GKSGoodies.tips.messages = {}
		CONS_Printf(p, "Tips list has been cleared sucessfully")
	else
		CONS_Printf(p, "No tips messages found. no need to clear.")
	end
end, COM_ADMIN)

--Commands to handle welcome messages

COM_AddCommand("welcome_message", function(p, message)
	if message then
		GKSGoodies.welcome.message = message
		CONS_Printf(p, "Welcome message has been set")
	else
		CONS_Printf(p, "Sets a welcome message for the joining player")
	end
end, COM_ADMIN)