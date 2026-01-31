--Must load first
local libs = "Libraries/"
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
dofile(rsdir.."Round Control")
dofile(rsdir.."Team Color Variants")
dofile(rsdir.."TimeLimit stuff")
--dofile("tips.lua") --wip