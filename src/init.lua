/*
SafeFreeslot, generally good practice to avoid wasting freeslots
regardless of how specific the freeslot name is. Also modder friendly
from chrispy chars!!! by Lach!!!!
*/
rawset(_G,"SafeFreeslot",function(...)
	local to_freeslot = {...}
	local returning = nil
	local single = (#to_freeslot == 1)
	for _, item in ipairs(to_freeslot) do
		if rawget(_G, item) == nil then
			if single then
				returning = freeslot(item)
			else
				freeslot(item)
			end
		end
	end
	return returning
end)

--Must load first
local libs = "Libraries/"
dofile("Globals.lua")
dofile("Functions.lua")
dofile(libs.."Info_Fireworks.lua")

local voicesdir = "Voices/" --Character voices
dofile(voicesdir.."System")

local racedir = "Race/" -- Race stuff
dofile(racedir.."Race Adjustments")
dofile(racedir.."Hurry Up.lua")
dofile(racedir.."Race Start")

dofile("Team GT Visuals")
dofile("TimeLimit stuff")
dofile("Commands")
dofile("Round Control") --Round Control
dofile("tips.lua") --wip
dofile("Status Bubbles.lua")

--Hook Everything
local addHook = addHook
for hookName, subTable in pairs(GoodiesHook) do
    print("[GKS Goodies] \x82\Registering functions for the hook :" .. hookName)

    addHook(hookName, function(...)
        for i in pairs(subTable) do
            subTable[i](...)
        end
    end)

    for i in pairs(subTable) do
        print("[GKS Goodies] \x83\Function "..i.." sucessfully linked to :"..hookName)
    end
end