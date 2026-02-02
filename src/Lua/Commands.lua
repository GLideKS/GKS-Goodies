--CTF

local function update_ctf_values()
    local settings = GKSGoodies.serversettings.ctf_config

    local tlimit = CV_FindVar("ctf_timelimit") and CV_FindVar("ctf_timelimit").value
    local plimit = CV_FindVar("ctf_pointlimit") and CV_FindVar("ctf_pointlimit").value
    settings.timelimit = tlimit
    settings.pointlimit = plimit
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
    local settings = GKSGoodies.serversettings.match_config

    local tlimit = CV_FindVar("match_timelimit") and CV_FindVar("match_timelimit").value
    local plimit = CV_FindVar("match_pointlimit") and CV_FindVar("match_pointlimit").value
    settings.timelimit = tlimit
    settings.pointlimit = plimit
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
    local settings = GKSGoodies.serversettings.tag_config

    local tlimit = CV_FindVar("tag_timelimit") and CV_FindVar("tag_timelimit").value
    local plimit = CV_FindVar("tag_pointlimit") and CV_FindVar("tag_pointlimit").value
    settings.timelimit = tlimit
    settings.pointlimit = plimit
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
    local settings = GKSGoodies.serversettings.hs_config

    local tlimit = CV_FindVar("hs_timelimit") and CV_FindVar("hs_timelimit").value
    local plimit = CV_FindVar("hs_pointlimit") and CV_FindVar("hs_pointlimit").value
    settings.timelimit = tlimit
    settings.pointlimit = plimit
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