CV_RegisterVar({
	name = "pvp_collision",
	defaultvalue = 1,
	PossibleValue = CV_TrueFalse,
	flags = CV_NETVAR,
})

CV_RegisterVar({
	name = "pvp_momentum",
	defaultvalue = 0,
	PossibleValue = CV_TrueFalse,
	flags = CV_NETVAR,
})

CV_RegisterVar({
	name = "pvp_onlyabilities",
	defaultvalue = 1,
	PossibleValue = CV_TrueFalse,
	flags = CV_NETVAR,
})

CV_RegisterVar({
	name = "pvp_hittype",
	defaultvalue = 1,
	PossibleValue = {bump = 0, damage = 1},
	flags = CV_NETVAR,
})

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
        local hittype = CV_FindVar("pvp_hittype").value
        local collide = CV_FindVar("pvp_collision").value
        local momentum = CV_FindVar("pvp_momentum").value

        if hittype then
            P_DamageMobj(mo, toucher, toucher)
        else
            P_DoPlayerPain(mo.player, toucher, toucher)
            S_StartSound(toucher, randomized_sound)
        end

        if collide then
            toucher.momx = (-$)/2
            toucher.momy = (-$)/2
            toucher.momz = ($ < 0) and (-$)/2 or $
        end

        if momentum then
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
	local p1, p2 = toucher.player, mo.player
	if not (toucher and toucher.valid) then return end
    if not (mo and mo.valid) then return end
	if not L_ZCollide(toucher, mo) then return end
    if not GD_CanHurtPlayer(p1, p2) then return end
    if not P_PlayerCanDamage(p1, mo) then return end
    if (CV_FindVar("pvp_onlyabilities").value and not (p1.pflags & (PF_THOKKED|PF_GLIDING|PF_SPINNING))) then return end

    if P_PlayerCanDamage(p2, toucher) then
        PVP_Damage(toucher, mo, true)
        return
    end

	PVP_Damage(toucher, mo)
end

gBundleHook("MobjMoveCollide", "Enhanced FriendlyFire", PVP, MT_PLAYER)
