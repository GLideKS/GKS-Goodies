local addHook = addHook

local ffenh_toggle = CV_RegisterVar({
	name = "friendlyfire_enhanced",
	defaultvalue = 1,
	PossibleValue = CV_TrueFalse,
	flags = CV_NETVAR,
})

local collide = CV_RegisterVar({
	name = "ff_collision",
	defaultvalue = 1,
	PossibleValue = CV_TrueFalse,
	flags = CV_NETVAR,
})

local momentum = CV_RegisterVar({
	name = "ff_momentum",
	defaultvalue = 0,
	PossibleValue = CV_TrueFalse,
	flags = CV_NETVAR,
})

local onlyabilities = CV_RegisterVar({
	name = "ff_onlyabilities",
	defaultvalue = 1,
	PossibleValue = CV_TrueFalse,
	flags = CV_NETVAR,
})

local hittype = CV_RegisterVar({
	name = "ff_hittype",
	defaultvalue = 0,
	PossibleValue = {bump = 0, damage = 1},
	flags = CV_NETVAR,
})

-- Super Optimize
local MT_DUST = MT_DUST
local sfx_s259 = sfx_s259
local S_StartSound = S_StartSound
local P_SpawnMobjFromMobj = P_SpawnMobjFromMobj
local P_RandomRange = P_RandomRange
local TICRATE = TICRATE
local P_DamageMobj = P_DamageMobj
local P_DoPlayerPain = P_DoPlayerPain
local P_PlayerCanDamage = P_PlayerCanDamage

local hitsounds = {
    [1] = sfx_bnce1,
    [2] = sfx_shldls,
    [3] = sfx_bowl,
    [4] = sfx_bsnipe,
    [5] = sfx_s3k49,
    [6] = sfx_s3k5d,
    [7] = sfx_s3k7b,
    [8] = sfx_s3k8b,
    [9] = sfx_s3k9e,
    [10] = sfx_s3kae
}

local metallic_hitsounds = { --For SF_MACHINE skin flag
    [1] = sfx_s3k6e,
    [2] = sfx_bedeen,
    [3] = sfx_s1a6,
    [4] = sfx_s1b4,
    [5] = sfx_bsnipe,
    [6] = sfx_s3k5d,
    [7] = sfx_s3k7b,
    [8] = sfx_s3k90,
    [9] = sfx_s3k9e,
    [10] = sfx_s3kae,
    [11] = sfx_cdfm28
}

local function PVP_Damage(toucher, mo, split)
    local vfx = P_SpawnMobjFromMobj(mo, 0, 0, (mo.height / 2), MT_DUST)
    local normal_hit = hitsounds[P_RandomRange(1, #hitsounds)]
    local metal_hit = metallic_hitsounds[P_RandomRange(1, #metallic_hitsounds)]
    local randomized_sound = ((skins[mo.skin].flags & SF_MACHINE) and metal_hit) or normal_hit

    vfx.frame = A
    vfx.scale = mo.scale * 2

    if not split then

        if hittype.value then
            P_DamageMobj(mo, toucher, toucher)
        else
            P_DoPlayerPain(mo.player, toucher, toucher)
            S_StartSound(toucher, randomized_sound)
        end

        if collide.value then
            toucher.momx = (-$)/2
            toucher.momy = (-$)/2
            toucher.momz = ($ < 0) and (-$)/2 or $
        end

        if momentum.value then
            mo.momx = collide and -toucher.momx or toucher.momx
            mo.momy = collide and -toucher.momy or toucher.momy
        end
    else
        P_DoPlayerPain(mo.player, toucher, toucher)
        P_DoPlayerPain(toucher.player, mo, mo)
        S_StartSound(toucher, sfx_s259)
    end
end

local function PVP(toucher, mo)
    if not ffenh_toggle.value then return end
	local p1, p2 = toucher.player, mo.player
	if not (toucher and toucher.valid) then return end
    if not (mo and mo.valid) then return end
	if not L_ZCollide(toucher, mo) then return end
    if not GD_CanHurtPlayer(p1, p2) then return end
    if not P_PlayerCanDamage(p1, mo) then return end
    if (onlyabilities.value and not (p1.pflags & (PF_THOKKED|PF_GLIDING|PF_SPINNING))) then return end
    if (gametyperules & GTR_RACE) and ((leveltime < 8*TICRATE) or (p1.realtime == 0)) then return end

    if P_PlayerCanDamage(p2, toucher) then
        PVP_Damage(toucher, mo, true)
        return
    end

	PVP_Damage(toucher, mo)
end

addHook("MobjMoveCollide", PVP, MT_PLAYER)
