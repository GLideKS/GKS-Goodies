--Must load first
local libs = "Libraries/"
dofile("Globals.lua")
dofile("Functions.lua")
dofile(libs.."Info_Fireworks.lua")

local racedir = "Race/" -- Race stuff
dofile(racedir.."Race Adjustments")
dofile(racedir.."Hurry Up.lua")
dofile(racedir.."Race Start")

dofile("Team Visuals/Color Variants")
dofile("Team Visuals/Flag Capture Firework")
dofile("Team Visuals/Flag Hold")
dofile("Round Control") --Round Control
dofile("tips.lua") --wip
dofile("Status Bubbles.lua")

local cmd = "Commands/"

dofile(cmd.."Gamemode Control")
dofile(cmd.."Overtime Properties")
dofile(cmd.."Server Settings")
dofile(cmd.."Tools")

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