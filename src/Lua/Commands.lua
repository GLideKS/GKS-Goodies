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
	local precip_strings = {
		[0] = "None",
		[1] = "Storm",
		[2] = "Snow",
		[3] = "Rain",
		[4] = "Blank (Preloaded Precipitation)",
		[5] = "Storm (no rain)",
		[6] = "Storm (nolightning)"
	}

    local sky = CV_FindVar("overtime_sky") and CV_FindVar("overtime_sky").value
    local weather = CV_FindVar("overtime_weather") and CV_FindVar("overtime_weather").value
    settings.overtime_sky = sky
    settings.overtime_weather = weather

	print("Overtime's weather has been changed to "..precip_strings[weather])
	print("Overtime's sky has been changed to "..sky)
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