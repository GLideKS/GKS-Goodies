local setting = GKSGoodies.serversettings

--Localize to optimize
local CV_FindVar = CV_FindVar
local COM_BufInsertText = COM_BufInsertText
local GTR_TEAMFLAGS = GTR_TEAMFLAGS
local GTR_RINGSLINGER = GTR_RINGSLINGER
local GTR_TAG = GTR_TAG
local GTR_HIDEFROZEN = GTR_HIDEFROZEN

local function SetValueOrDefault(cvar, num)
	local default = {
		timelimit = CV_FindVar("default_timelimit") and CV_FindVar("default_timelimit").value,
		pointlimit = CV_FindVar("default_pointlimit") and CV_FindVar("default_pointlimit").value,
	}
	--Num defines if it's either a timelimit or a pointlimit
	if not num then --set to default timelimit
		return ((CV_FindVar(cvar) and CV_FindVar(cvar).value) or default.timelimit)
	else --set to default pointlimit
		return ((CV_FindVar(cvar) and CV_FindVar(cvar).value) or default.pointlimit)
	end
end

GoodiesHook.MapLoad.RoundControl = function()
	if not (isdedicatedserver or isserver) then return end

	local ctf = {
		timelimit = SetValueOrDefault("ctf_timelimit"),
		pointlimit = SetValueOrDefault("ctf_pointlimit", 1),
	}

	local match = {
		timelimit = SetValueOrDefault("match_timelimit"),
		pointlimit = SetValueOrDefault("match_pointlimit", 1),
	}

	local tag = {
		timelimit = SetValueOrDefault("tag_timelimit"),
		pointlimit = SetValueOrDefault("tag_pointlimit", 1),
	}

	local hs = {
		timelimit = SetValueOrDefault("hs_timelimit"),
		pointlimit = SetValueOrDefault("hs_pointlimit", 1),
	}

	if (gametyperules & GTR_TEAMFLAGS) then --CTF commonly
		COM_BufInsertText(server,"pointlimit "..ctf.pointlimit)
		COM_BufInsertText(server,"timelimit "..ctf.timelimit)
	--Match and any other ringslinger mode.
	elseif (gametyperules & GTR_RINGSLINGER) and not ((gametyperules & GTR_TAG) or (gametyperules & GTR_HIDEFROZEN)) then
		COM_BufInsertText(server,"pointlimit "..match.pointlimit)
		COM_BufInsertText(server,"timelimit "..match.timelimit)
	elseif (gametyperules & GTR_TAG) then
		if (gametyperules & GTR_HIDEFROZEN) then --is hide and seek
			COM_BufInsertText(server,"pointlimit "..hs.pointlimit)
			COM_BufInsertText(server,"timelimit "..hs.timelimit)
		else --Otherwise, is normal tag
			COM_BufInsertText(server,"pointlimit "..tag.pointlimit)
			COM_BufInsertText(server,"timelimit "..tag.timelimit)
		end
	end
end