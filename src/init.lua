--Must load first
local libs = "Libraries/"
dofile("Globals.lua")
dofile("Functions.lua")
dofile("Commands.lua")
rawset(_G,"MENULIB_ROOT",libs.."MenuLib/")
dofile(MENULIB_ROOT .. "exec.lua")

local voicesdir = "Voices/" --Character voices
dofile(voicesdir.."System")

local racedir = "Race/" -- Race stuff
dofile(racedir.."Race Adjustments")
dofile(racedir.."Hurry Up.lua")
dofile(racedir.."Nonspin Headstart")
dofile(racedir.."Race Start")

local rsdir = "Ringslinger/" --Ringslinger Stuff
dofile(rsdir.."Team Color Variants")
dofile(rsdir.."TimeLimit stuff")
dofile(rsdir.."Visual Flag Hold")

dofile("Round Control") --Round Control
--dofile("tips.lua") --wip

--Hook Everything
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