--Sets a name for the server in the chat (not the dedicated one)
COM_AddCommand("prefix_name", function(p, name)
	if name then
		GKSGoodies.serverprefix.text = name
	else
		CONS_Printf(p, "Sets the server's name in the chat")
	end
end, COM_ADMIN)

--Set a color for the name
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

--Prints a list of colors to be used for prefix_color
COM_AddCommand("prefix_colorlist", function(p, name)
	CONS_Printf(p, "----List of text colors available for prefix_color----")
	CONS_Printf(p, "")
	for colorname, hex in pairs(GKSGoodies.prefixcolors) do
		CONS_Printf(p, hex..colorname)
	end
end, COM_ADMIN)

--Add a tip
COM_AddCommand("tips_add", function(p, message)
	if message then
		table.insert(GKSGoodies.tips.messages, message)
		CONS_Printf(p, "Message inserted sucessfully to the tips list")
	else
		CONS_Printf(p, "Adds a message for the tips list")
	end
end, COM_ADMIN)

--Remove a tip
COM_AddCommand("tips_remove", function(p, arg)
	local index = tonumber(arg)

	if (index and GKSGoodies.tips.messages[index]) then
		table.remove(GKSGoodies.tips.messages, index)
		CONS_Printf(p, "Message removed sucessfully from the tips list")
	else
		CONS_Printf(p, "Message index not valid or not found.")
	end
end, COM_ADMIN)

--Prints the list of tips given
COM_AddCommand("tips_list", function(p)
	if #GKSGoodies.tips.messages then
		CONS_Printf(p, "----List of tips messages stored----")
		CONS_Printf(p, "")
		for i = 1, #GKSGoodies.tips.messages do
			CONS_Printf(p, "\x82"..i..":\x80 "..GKSGoodies.tips.messages[i])
		end
	else
		CONS_Printf(p, "No tips messages found.")
	end
end, COM_ADMIN)

--Remove all the tips
COM_AddCommand("tips_clear", function(p)
	if #GKSGoodies.tips.messages then
		GKSGoodies.tips.messages = {}
		CONS_Printf(p, "Tips list has been cleared sucessfully")
	else
		CONS_Printf(p, "No tips messages found. no need to clear.")
	end
end, COM_ADMIN)

--Set a welcome message
COM_AddCommand("welcome_message", function(p, message)
	if message then
		GKSGoodies.welcome.message = message
		CONS_Printf(p, "Welcome message has been set")
	else
		CONS_Printf(p, "Sets a welcome message for the joining player")
	end
end, COM_ADMIN)