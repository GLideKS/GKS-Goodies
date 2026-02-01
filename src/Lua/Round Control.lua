local GoodiesHook = GoodiesHook
local g_timelimit = 6
local g_pointlimit = 5

GoodiesHook.MapLoad.RoundControl = function()
	if (isdedicatedserver or isserver)
	and (gametyperules & GTR_RINGSLINGER) then
		if (gametyperules & GTR_TEAMFLAGS) then
			COM_BufInsertText(server,"pointlimit "..g_pointlimit)
			COM_BufInsertText(server,"timelimit "..g_timelimit+1)
		else
			COM_BufInsertText(server,"pointlimit 0")
			COM_BufInsertText(server,"timelimit "..g_timelimit)
		end
	end
end