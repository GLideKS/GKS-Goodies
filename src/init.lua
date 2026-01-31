--Must load first
local libs = "Libraries/"
dofile("Functions.lua")
rawset(_G,"MENULIB_ROOT",libs.."MenuLib/")
dofile(MENULIB_ROOT .. "exec.lua")

local voicesdir = "Voices/"
dofile(voicesdir.."System")

local racedir = "Race/"
dofile(racedir.."Race Adjustments")
dofile(racedir.."Hurry Up.lua")
dofile(racedir.."Nonspin Headstart")
dofile(racedir.."Race Start")

local rsdir = "Ringslinger/"
dofile(rsdir.."Team Color Variants")
dofile(rsdir.."TimeLimit stuff")
dofile(rsdir.."Visual Flag Hold")

dofile("Round Control")
--dofile("tips.lua") --wip