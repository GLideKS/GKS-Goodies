--Must load first
local libs = "Libraries/"
dofile(libs.."L_Lib-HookBundler-v2.lua")
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