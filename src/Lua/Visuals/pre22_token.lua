-- [[ Main Color Script by Jisk from Zombie Escape 2 ]] --

local tokencvar = CV_RegisterVar({
	name = "token_alt",
	defaultvalue = 1,
	PossibleValue = CV_TrueFalse,
    flags = CV_NETVAR|CV_CALL,
    func = gd_notice
})

SafeFreeslot("SKINCOLOR_GDCHROMA") -- From Zombie Escape 2's Exit ring, however it's renamed to avoid conflicts with ZE2

local original_ramp = {97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,31}
local anim_speed = 2

local function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

skincolors[SKINCOLOR_GDCHROMA] = {
	name = "Chroma",
	ramp = shallowcopy(original_ramp),
	invcolor = SKINCOLOR_SKY,
	invshade = 0,
	chatcolor = V_BLUEMAP,
	accessible = true
}

-- Localize to optimize
local addHook = addHook
local MT_OVERLAY = MT_OVERLAY
local SKINCOLOR_GDCHROMA = SKINCOLOR_GDCHROMA
local S_THOK = S_THOK
local SPR_OILF = SPR_OILF
local chroma = skincolors[SKINCOLOR_GDCHROMA]
local P_RandomRange = P_RandomRange
local P_SpawnMobjFromMobj = P_SpawnMobjFromMobj
local P_RemoveMobj = P_RemoveMobj
local P_RandomChance = P_RandomChance
local RF_SEMIBRIGHT = RF_SEMIBRIGHT
local RF_FULLBRIGHT = RF_FULLBRIGHT
local FU = FU
local AST_ADD = AST_ADD
local paletteToRgb = color.paletteToRgb
local rgbToHsl = color.rgbToHsl
local hslToRgb = color.hslToRgb
local rgbToPalette = color.rgbToPalette

addHook("ThinkFrame", function()
    local realhue = (leveltime*anim_speed % 256)

    for i,v in ipairs(original_ramp) do
        local index = original_ramp[i]
        local r, g, b = paletteToRgb(index)
        local h, s, l = rgbToHsl(r, g, b)

        h = realhue

        l = min($ * 2, 220)

        r, g, b = hslToRgb(h, 255, l)
        index = rgbToPalette(r, g, b)

        chroma.ramp[i-1] = index
    end
end)

-- [[ Token Alt (Pre 2.2 inspired token) ]] --

SafeFreeslot("SPR_COLORABLE_EMERALD")
local SPR_COLORABLE_EMERALD = SPR_COLORABLE_EMERALD

local function TokenSpawn(mo)
    if not tokencvar.value then return end
	mo.alttoken = true
	mo.tics = -1
    mo.sprite = SPR_COLORABLE_EMERALD
	mo.renderflags = $|RF_SEMIBRIGHT
	mo.frame = A
	mo.spritexscale = $ * 5 / 4
	mo.spriteyscale = $ * 5 / 4
	mo.spriteyoffset = 1 * FU
	mo.color = SKINCOLOR_GDCHROMA

	-- Mini corona?
    mo.overlay = P_SpawnMobjFromMobj(mo, 0, 0, 0, MT_OVERLAY)
    mo.overlay.target = mo
    mo.overlay.state = S_THOK
	mo.overlay.sprite = SPR_OILF
	mo.overlay.colorized = true
	mo.overlay.color = SKINCOLOR_GDCHROMA
    mo.overlay.tics = -1
	mo.overlay.spritexscale = FU / 3
	mo.overlay.spriteyscale = FU / 3
	mo.overlay.spriteyoffset = 45 * FU
	mo.overlay.renderflags = $|RF_FULLBRIGHT
	mo.overlay.blendmode = AST_ADD
	mo.overlay.dispoffset = -10
	mo.overlay.alpha = $ / 2
end

local function TokenThinker(mo)
	if not mo.alttoken then return end
	local ov = mo.overlay

	if not (mo.valid and mo.health) then
		if ov and ov.valid then
			P_RemoveMobj(ov)
		end
		return
	end

	-- Spawn sparkles around the token
    if (leveltime % 6) != 0 then return end
    local rad = FixedDiv(mo.radius * 2, mo.scale)/FU
    local hei = FixedDiv(mo.height, mo.scale)/FU

    local sparkle = P_SpawnMobjFromMobj(mo,
        P_RandomRange(-rad,rad)*FU,
        P_RandomRange(-rad,rad)*FU,
        P_RandomRange(- hei / 3,hei)*FU,
        MT_BOXSPARKLE
    )

    if P_RandomChance(FU * 5 / 7) then
        sparkle.colorized = true
        sparkle.color = mo.color
    end
    sparkle.renderflags = $|RF_FULLBRIGHT
end

addHook("MapThingSpawn", TokenSpawn, MT_TOKEN)
addHook("MobjThinker", TokenThinker, MT_TOKEN)