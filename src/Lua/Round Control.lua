local setting = GKSGoodies.serversettings

GoodiesHook.MapLoad.RoundControl = function()
	if not (isdedicatedserver or isserver) then return end
	if (gametyperules & GTR_TEAMFLAGS) then --CTF commonly
		COM_BufInsertText(server,"pointlimit "..setting.ctf_config.pointlimit or CV_FindVar("pointlimit").value)
		COM_BufInsertText(server,"timelimit "..setting.ctf_config.timelimit or CV_FindVar("timelimit").value)
	--Match and any other ringslinger mode.
	elseif (gametyperules & GTR_RINGSLINGER) and not ((gametyperules & GTR_TAG) or (gametyperules & GTR_HIDEFROZEN)) then
		COM_BufInsertText(server,"pointlimit "..setting.match_config.pointlimit or CV_FindVar("pointlimit").value)
		COM_BufInsertText(server,"timelimit "..setting.match_config.timelimit or CV_FindVar("timelimit").value)
	elseif (gametyperules & GTR_TAG) then
		if (gametyperules & GTR_HIDEFROZEN) then --is hide and seek
			COM_BufInsertText(server,"pointlimit "..setting.hs_config.pointlimit or CV_FindVar("pointlimit").value)
			COM_BufInsertText(server,"timelimit "..setting.hs_config.timelimit or CV_FindVar("timelimit").value)
		else --Otherwise, is normal tag
			COM_BufInsertText(server,"pointlimit "..setting.tag_config.pointlimit or CV_FindVar("pointlimit").value)
			COM_BufInsertText(server,"timelimit "..setting.tag_config.timelimit or CV_FindVar("timelimit").value)
		end
	end
end