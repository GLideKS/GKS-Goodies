local settings = GKSGoodies.serversettings --goodies server settings

--Function to update overtime settings
local function update_overtime()
    local sky = CV_FindVar("overtime_sky") and CV_FindVar("overtime_sky").value
    local weather = CV_FindVar("overtime_weather") and CV_FindVar("overtime_weather").value
    settings.overtime_sky = sky
    settings.overtime_weather = weather
end

--Set overtime's sky
CV_RegisterVar({
	name = "overtime_sky",
	defaultvalue = 12,
	PossibleValue = CV_Unsigned,
	flags = CV_CALL|CV_NETVAR,
	func = update_overtime
})

--Set overtime's weather
CV_RegisterVar({
	name = "overtime_weather",
	defaultvalue = 1,
	PossibleValue = {MIN = 0, MAX = 6},
	flags = CV_CALL|CV_NETVAR,
	func = update_overtime
})