local g_timelimit = 6
local g_pointlimit = 5

local function onThink()
	if (isdedicatedserver or isserver)
	and (gametyperules & GTR_RINGSLINGER)
		if (RSR and gametype == GT_RSRCTF) or (gametype == GT_RSRCTF)
			COM_BufInsertText(server,"pointlimit "..g_pointlimit)
			COM_BufInsertText(server,"timelimit "..g_timelimit+1)
		else
			COM_BufInsertText(server,"pointlimit 0")
			COM_BufInsertText(server,"timelimit "..g_timelimit)
		end
	end
end
addHook("MapLoad",onThink)