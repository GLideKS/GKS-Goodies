--Must load first
local libs = "Libraries/"
rawset(_G,"MENULIB_ROOT",libs.."MenuLib/")
dofile(MENULIB_ROOT .. "exec.lua")
dofile(MENULIB_ROOT .. "debug.lua") -- Not required

local voicesdir = "Voices/"
dofile(voicesdir.."System")

local racedir = "Race/"
dofile(racedir.."Race Adjustments")
dofile(racedir.."Hurry Up.lua")
dofile(racedir.."Race Start")

dofile("Round Control")
dofile("Team Color Variants")
dofile("TimeLimit stuff")
--dofile("tips.lua") --wip