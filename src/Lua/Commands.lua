--CTF
local settings = GKSGoodies.serversettings

local function update_ctf_values()
    local setting = settings.ctf_config

    local tlimit = CV_FindVar("ctf_timelimit") and CV_FindVar("ctf_timelimit").value
    local plimit = CV_FindVar("ctf_pointlimit") and CV_FindVar("ctf_pointlimit").value
    setting.timelimit = tlimit
    setting.pointlimit = plimit
end

CV_RegisterVar({
	name = "ctf_timelimit",
	defaultvalue = 0,
	PossibleValue = CV_Unsigned,
	flags = CV_CALL|CV_NETVAR,
	func = update_ctf_values
})

CV_RegisterVar({
	name = "ctf_pointlimit",
	defaultvalue = 0,
	PossibleValue = CV_Unsigned,
	flags = CV_CALL|CV_NETVAR,
	func = update_ctf_values
})

--Match

local function update_match_values()
    local setting = settings.match_config

    local tlimit = CV_FindVar("match_timelimit") and CV_FindVar("match_timelimit").value
    local plimit = CV_FindVar("match_pointlimit") and CV_FindVar("match_pointlimit").value
    setting.timelimit = tlimit
    setting.pointlimit = plimit
end

CV_RegisterVar({
	name = "match_timelimit",
	defaultvalue = 0,
	PossibleValue = CV_Unsigned,
	flags = CV_CALL|CV_NETVAR,
	func = update_match_values
})

CV_RegisterVar({
	name = "match_pointlimit",
	defaultvalue = 0,
	PossibleValue = CV_Unsigned,
	flags = CV_CALL|CV_NETVAR,
	func = update_match_values
})

--Tag

local function update_tag_values()
    local setting = settings.tag_config

    local tlimit = CV_FindVar("tag_timelimit") and CV_FindVar("tag_timelimit").value
    local plimit = CV_FindVar("tag_pointlimit") and CV_FindVar("tag_pointlimit").value
    setting.timelimit = tlimit
    setting.pointlimit = plimit
end

CV_RegisterVar({
	name = "tag_timelimit",
	defaultvalue = 0,
	PossibleValue = CV_Unsigned,
	flags = CV_CALL|CV_NETVAR,
	func = update_tag_values
})

CV_RegisterVar({
	name = "tag_pointlimit",
	defaultvalue = 0,
	PossibleValue = CV_Unsigned,
	flags = CV_CALL|CV_NETVAR,
	func = update_tag_values
})

--H&S

local function update_hs_values()
    local setting = settings.hs_config

    local tlimit = CV_FindVar("hs_timelimit") and CV_FindVar("hs_timelimit").value
    local plimit = CV_FindVar("hs_pointlimit") and CV_FindVar("hs_pointlimit").value
    setting.timelimit = tlimit
    setting.pointlimit = plimit
end

CV_RegisterVar({
	name = "hs_timelimit",
	defaultvalue = 0,
	PossibleValue = CV_Unsigned,
	flags = CV_CALL|CV_NETVAR,
	func = update_hs_values
})

CV_RegisterVar({
	name = "hs_pointlimit",
	defaultvalue = 0,
	PossibleValue = CV_Unsigned,
	flags = CV_CALL|CV_NETVAR,
	func = update_hs_values
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

--Commands to handle tips

COM_AddCommand("gd_tips_add", function(p, message)
	if message then
		table.insert(GKSGoodies.tips.messages, message)
		CONS_Printf(p, "Message inserted sucessfully to the tips list")
	else
		CONS_Printf(p, "Adds a message for the tips list")
	end
end, COM_ADMIN)

COM_AddCommand("gd_tips_remove", function(p, arg)
	local index = tonumber(arg)

	if (index and GKSGoodies.tips.messages[index]) then
		table.remove(GKSGoodies.tips.messages, index)
		CONS_Printf(p, "Message removed sucessfully from the tips list")
	else
		CONS_Printf(p, "Message index not valid or not found.")
	end
end, COM_ADMIN)

COM_AddCommand("gd_tips_list", function(p)
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

COM_AddCommand("gd_tips_clear", function(p)
	if #GKSGoodies.tips.messages then
		GKSGoodies.tips.messages = {}
		CONS_Printf(p, "Tips list has been cleared sucessfully")
	else
		CONS_Printf(p, "No tips messages found. no need to clear.")
	end
end, COM_ADMIN)

--Commands to handle welcome messages

COM_AddCommand("gd_welcome_message", function(p, message)
	if message then
		GKSGoodies.welcome.message = message
		CONS_Printf(p, "Welcome message has been set")
	else
		CONS_Printf(p, "Sets a welcome message for the joining player")
	end
end, COM_ADMIN)