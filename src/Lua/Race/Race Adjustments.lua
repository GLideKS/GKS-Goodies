--Prevent damage on countdown
local function RaceCountdownNoDMG(mo, mo2)
	if not (gametyperules & GTR_RACE) then return end
	if not (mo and mo.valid) then return end
	if (leveltime < 4*TICRATE) or (mo.player.realtime == 0) then
		return false
	end

	if not (mo2 and mo2.valid) then return end

	if mo2.type == MT_SPINFIRE --from elemental shield
	and not mo.player.powers[pw_flashing] then
		return true
	end
end

--Friendlyfire support for Race

local function InflictDamage(mo, mo2, DMGType) --Damage handler
	local p1, p2 = mo.player, mo2.player

	if (p2.powers[pw_shield] & SH_FORCE) then --Force shield protects from damage
		local angle = R_PointToAngle2(mo.x,mo.y,mo2.x,mo2.y)
		P_InstaThrust(mo, -angle, p1.speed)
		S_StartSound(mo2, sfx_s3k49)
		if (p2.powers[pw_shield] & SH_FORCEHP) then
			p2.powers[pw_shield] = SH_FORCE
		else
			S_StartSound(mo2, sfx_cdfm16)
			p2.powers[pw_shield] = 0
		end
		return true
	elseif p2.powers[pw_invulnerability] then
		return
	else
		P_DamageMobj(mo2, mo, mo, nil, DMGType or nil)
	end
end

local function ZCollide(mo,mo2)
	if (mo.z > mo2.z + mo2.height) then return false; end
	if (mo2.z > mo.z + mo.height) then return false; end
	return true
end

local function RacePVP(mo, mo2)
	if not (gametyperules & GTR_RACE) then return end
	local p1, p2 = mo.player, mo2.player

	if not ((mo and mo.valid) and (mo2 and mo2.valid) and (p1 and p2)) then return end
	if not ZCollide(mo, mo2) then return end
	if not GD_CanHurtPlayer(p1, p2) then return end

	if p1.powers[pw_invulnerability] then --invuln
		InflictDamage(mo, mo2)
	end

	if p1.pflags & PF_SHIELDABILITY
	and P_PlayerCanDamage(p1, mo2) then
		if (p1.powers[pw_shield] & SH_ELEMENTAL) then
			InflictDamage(mo, mo2, DMG_FIRE)
			P_SetObjectMomZ(mo, FixedMul(mo.scale, 10*FU))
			P_SetObjectMomZ(mo2, mo.momz)
			return true
		end
	end
end

addHook("ShouldDamage", RaceCountdownNoDMG, MT_PLAYER)
addHook("MobjMoveCollide", RacePVP, MT_PLAYER)