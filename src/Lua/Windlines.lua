-- Localize some things from the wind effect to avoid calculations each tic when spawning
local windfuse = TICRATE/3
local windoffset = -16*FU
local windflags = FF_PAPERSPRITE|FF_SEMIBRIGHT|FF_ADD
local windsprite = SPR_RAIN
local fall_speed = 20 * FU
local MT_THOK = MT_THOK

-- Command

local function notice(cvar)
    if cvar.value then
        print("The server enabled windlines")
    else
        print("The server disabled windlines")
    end
end

CV_RegisterVar({
	name = "globalwindlines",
	defaultvalue = 1,
	PossibleValue = CV_TrueFalse,
	flags = CV_NETVAR|CV_CALL,
    func = notice
})

COM_AddCommand("toggle_windlines", function(p)
    if p.gd_windlines then
        p.gd_windlines = false
        CONS_Printf(p, "Windlines has been disabled for you")
    else
        p.gd_windlines = true
        CONS_Printf(p, "Windlines has been enabled for you")
    end
end)

-- Main

local function windeffect(p) -- Grabbed from Epic Murder Mystery with some adjustments
	local me = p.mo
	local rad = FixedDiv(me.radius * 3 / 2, me.scale)/FU
	local hei = FixedDiv(me.height, me.scale)/FU

	local wind = P_SpawnMobjFromMobj(me,
		P_RandomRange(-rad,rad)*FU,
		P_RandomRange(-rad,rad)*FU,
		P_RandomRange(0,hei)*FU,
		MT_THOK
	)
	wind.sprite = windsprite
	wind.fuse = windfuse
	wind.tics = wind.fuse
	wind.frame = $|windflags

	local momz = me.momz
	if (me.lastz ~= nil) then
		momz = me.z - me.lastz
	end

	wind.angle = R_PointToAngle2(0,0, me.momx, me.momy)
	wind.rollangle = R_PointToAngle2(0, 0, R_PointToDist2(0,0,me.momx,me.momy), momz) + ANGLE_90

	wind.momx = me.momx/3
	wind.momy = me.momy/3
	wind.momz = momz/3

	wind.spriteyoffset = windoffset

	wind.height = wind.scale
	wind.radius = 5*wind.scale
	wind.dontdrawforviewmobj = me

    if p.ctfteam then
        wind.colorized = true
        wind.color = me.color
    end
end

local function Windlines_Func(p)
    if p.gd_windlines == nil then
        p.gd_windlines = true
    end

    if not CV_FindVar("globalwindlines").value then return end
    if (p.powers[pw_carry] == CR_NIGHTSMODE) then return end

    local mo = p.mo
    if not p.gd_windlines then return end
    if not (mo and mo.valid and mo.health) then return end

    if p.powers[pw_justsprung] then
        windeffect(p)
    end

    if (leveltime % 2) == 0 then
        local speed = FixedHypot(p.rmomx, p.rmomy)
        local nm_speed = skins[mo.skin].normalspeed
        local z_speed_requirement = (mo.momz > FixedMul(fall_speed, mo.scale)) or (mo.momz < -FixedMul(fall_speed, mo.scale))
        local speed_requirement = FixedMul((nm_speed + 5 * FU), mo.scale)

        if (speed > speed_requirement) or z_speed_requirement then
            windeffect(p)
        end
    end
end

gBundleHook("PlayerThink", "Windlines", Windlines_Func)