local range = RING_DIST * 3

local global_nametags = CV_RegisterVar({ -- Server's choice to allow this feature or not.
	name = "allownametags",
	defaultvalue = 1,
	PossibleValue = CV_TrueFalse,
    flags = CV_NETVAR,
})

local nametags = CV_RegisterVar({ -- User's choice
	name = "nametags",
	defaultvalue = 0, -- I doubt many people likes nametags so let's make it disabled by default
	PossibleValue = CV_TrueFalse,
})

local nametag_self = CV_RegisterVar({ -- Also make appear your nametag as well??
	name = "nametags_self",
	defaultvalue = 0,
	PossibleValue = CV_TrueFalse,
})

local nametag_scale = CV_RegisterVar({
	name = "nametags_scale",
	defaultvalue = 0,
	PossibleValue = {tiny = 0, small = 1, medium = 2, big = 3},
})

local font_types = { -- To be used with nametags_scale
    [0] = "small-thin-fixed-center",
    [1] = "small-fixed-center",
    [2] = "thin-fixed-center",
    [3] = "fixed-center",
}

-- Localize to optimize
local getSpritePatch
local drawScaled
local getColormap
local drawString

local function Nametags(v, p, c)
    if not global_nametags.value then return end
    if not nametags.value then return end

    -- Set up our things first
    if getSpritePatch == nil then getSpritePatch = v.getSpritePatch end
    if drawScaled == nil then drawScaled = v.drawScaled end
    if getColormap == nil then getColormap = v.getColormap end
    if drawString == nil then drawString = v.drawString end

    local pmo = p.mo
	if not pmo or not pmo.valid then return end
    local found = {}

	searchBlockmap("objects", function(mobj, foundmobj)
        if not (foundmobj.type == MT_PLAYER and foundmobj.player) then return end
		local dist = R_PointToDist2(mobj.x, mobj.y, foundmobj.x, foundmobj.y)
		if (dist > range) then return end

		found[#found + 1] = foundmobj
	end, pmo,
	pmo.x - range, pmo.x + range,
	pmo.y - range, pmo.y + range)

    if nametag_self.value then
        local self_result = GD_GetScreenCoords(v, p, c, {
            x = pmo.x,
            y = pmo.y,
            z = pmo.z + pmo.height
        })
		if self_result or self_result.onscreen then
            local self_x, self_y = self_result.x, self_result.y
            local self_name, self_color = p.name, skincolors[pmo.color].chatcolor

            drawString(self_x, self_y - (9 * FU), self_name, self_color|V_ALLOWLOWERCASE, font_types[nametag_scale.value])
        end
    end

	if (#found <= 0) then return end

    for i = 1 ,#found , 1 do
		local mobj = found[i]
		local result = GD_GetScreenCoords(v, p, c, {
            x = mobj.x,
            y = mobj.y,
            z = mobj.z + mobj.height
        })
		if not result or not result.onscreen then continue end
        local x, y = result.x, result.y
        local name, color = mobj.player.name, skincolors[mobj.color].chatcolor

        drawString(x, y - (9 * FU), name, color|V_ALLOWLOWERCASE, font_types[nametag_scale.value])
	end
end

addHook("HUD", Nametags)