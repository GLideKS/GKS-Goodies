freeslot("MT_DAMAGEBOOST", "S_DAMAGEBOOST", "SPR_DAMAGEBOOST")

states[S_DAMAGEBOOST] = {SPR_DAMAGEBOOST, FF_FULLBRIGHT|FF_ADD|FF_ANIMATE, -1, nil, 2, 1, S_DAMAGEBOOST}

mobjinfo[MT_DAMAGEBOOST] = {
        doomednum = -1,
        spawnstate = S_DAMAGEBOOST,
		spawnhealth = 100,
        speed = 0,
        radius = 35*FRACUNIT,
        height = 50*FRACUNIT,
        mass = 1,
		flags = MF_NOGRAVITY|MF_FLOAT|MF_NOCLIPHEIGHT|MF_MISSILE
}

local function BoostConditions(p)
	if (p.powers[pw_sneakers]
	or p.Ringboostmode)
		return true
	end
end

local function FlipChecks(mo, z_adjust)
if P_MobjFlip(mo.target.player.mo) == -1
	local pmo = mo.target.player.mo
	if mo and mo.valid
		mo.flags2 = $|MF2_OBJECTFLIP
		mo.eflags = $|MFE_VERTICALFLIP
		mo.z = ($+FixedMul(mo.target.player.mo.scale, z_adjust))
	end
else
	if mo and mo.valid
		mo.flags2 = $ & ~MF2_OBJECTFLIP
		mo.eflags = $ & ~MFE_VERTICALFLIP
	end
end
end

local function GhostShape(mo, color)
	if mo and mo.valid
		if (leveltime & 1)
			local ghs = P_SpawnGhostMobj(mo)
			if ghs and ghs.valid
				ghs.color = color
				ghs.blendmode = AST_ADD
				ghs.colorized = true
				ghs.frame = FF_FULLBRIGHT|$
				ghs.fuse = 5
			end
		end
	end
end

--Wolf Buster VFX
addHook("MobjThinker", function(mo)
	if (MM and MM.isMM()) return end
	
	local target = mo.target
    if not (mo and mo.valid) then
        return
    end

    if not (mo.target
    and mo.target.valid
    and mo.target.player)
	or not BoostConditions(mo.target.player) then
        P_RemoveMobj(mo)
        return
    end

    local x, y = cos(mo.target.player.drawangle),sin(mo.target.player.drawangle)

    P_MoveOrigin(mo, mo.target.x+5+x, mo.target.y+5+y, (mo.target.z+(mo.target.height/2))-(20*mo.scale))
	mo.angle = mo.target.player.drawangle
	
	local p = target.player
		
	mo.color = p.mo.color
	mo.dispoffset = 0
	FlipChecks(mo, -8*FU)
	mo.scale = p.mo.scale*3/2
	GhostShape(mo, mo.color)
end, MT_DAMAGEBOOST)

local function SpawnVFX(p, mobjtype, vfxscale)
if not (p.vfx and p.vfx.valid)
	p.vfx = P_SpawnMobj(p.mo.x, p.mo.y, p.mo.z, mobjtype)
	p.vfx.target = p.mo
	p.vfx.scale = vfxscale
else
	if (p == displayplayer) 
	or (p == secondarydisplayplayer) 
		if not camera.chase
			if p.vfx.valid
				p.vfx.flags2 = $|MF2_DONTDRAW
			end
		else
			if p.vfx and p.vfx.valid
				p.vfx.flags2 = $ & ~MF2_DONTDRAW
			end
		end
	end
end
end

addHook("PlayerThink", function(p)
	if not (p and p.mo and p.mo.valid) return end
	if BoostConditions(p)
		SpawnVFX(p, MT_DAMAGEBOOST, p.mo.scale*3/2)
	end
end)

local function pvp(mobj, pmo)
    if not (mobj and mobj.valid and pmo and pmo.valid) then return end
	
    local mobjTop = mobj.z + mobj.height
    local pmoTop = pmo.z + pmo.height

    if mobjTop > pmo.z and mobj.z < pmoTop then
        P_DamageMobj(pmo, mobj, mobj.target, 10, DMG_FIRE)
    end
end

addHook("MobjMoveCollide", pvp, MT_DAMAGEBOOST)
addHook("MobjCollide", pvp, MT_DAMAGEBOOST)
addHook("PlayerCanDamage", function(p)
	if not (p and p.mo and p.mo.valid) return end
	if BoostConditions(p)
		return true
	end
end)