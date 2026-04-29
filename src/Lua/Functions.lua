local gd = GKSGoodies

/*
SafeFreeslot, generally good practice to avoid wasting freeslots
regardless of how specific the freeslot name is. Also modder friendly
from chrispy chars!!! by Lach!!!!
*/
rawset(_G,"SafeFreeslot",function(...)
	local to_freeslot = {...}
	local returning = nil
	local single = (#to_freeslot == 1)
	for _, item in ipairs(to_freeslot) do
		if rawget(_G, item) == nil then
			if single then
				returning = freeslot(item)
			else
				freeslot(item)
			end
		end
	end
	return returning
end)

---Spawns a flag for the player
---@param p player_t
local function P_SpawnVisualFlag(p)
	local mo = p.mo

	if (mo.flagmobj and mo.flagmobj.valid) then return end

	local x, y = cos(p.drawangle),sin(p.drawangle) --position relative to angle
	local tx, ty, tz = (25*-x), (25*-y), mo.height/3 --position
	mo.flagmobj = P_SpawnMobjFromMobj(mo, tx, ty, tz, MT_GKS_FLAGHOLD)
	mo.flagmobj.target = mo
	mo.flagmobj.angle = mo.angle
	mo.flagmobj.eflags = mo.eflags

	if p.ctfteam == 1 then --Red Team
		mo.flagmobj.sprite = SPR_BFLG
	elseif p.ctfteam == 2 then --Blue Team
		mo.flagmobj.sprite = SPR_RFLG
	end

    mo.flagmobj.frame = FF_PAPERSPRITE|B
end

--Changes the music for everyone. also you can set weather and sky for everyone if desired
---@param music string
---@param weather any
---@param sky any
local S_ChangeGlobalMusic = function(music, weather, sky)
	S_ChangeMusic(music, true, nil, 128)
	mapmusname = music
	gd.currentmusicplaying = music
	if weather and globalweather != weather then
		P_SwitchWeather(weather)
	end
	if sky then
		P_SetSkyboxMobj(nil)
		P_SetupLevelSky(sky)
	end
end

--Thanks luigi budd for this function
--can @p1 damage @p2?
--P_TagDamage, P_PlayerHitsPlayer
---@param p1 player_t
---@param p2 player_t
---@param nobs any
local function GD_CanHurtPlayer(p1,p2,nobs)
	if not (p1 and p1.valid)
	or not (p2 and p2.valid) then
		return false
	end

	local allowhurt = true
	local ff = CV_FindVar("friendlyfire").value

	if not (nobs) then
		--no griefing!
		if (TAKIS_NET
		and TAKIS_NET.inspecialstage)
		or G_IsSpecialStage(gamemap) then
			return false
		end

		if not (p1.mo and p1.mo.valid) then
			return false
		end

		if not (p2.mo and p2.mo.valid) then
			return false
		end

		if not p1.mo.health then
			return false
		end
		if not p2.mo.health then
			return false
		end

		--non-supers can hit each other, supers can hit other supers,
		--but non-supers cant hit supers
		local superallowed = true
		if (p1.powers[pw_super]) then
			superallowed = true
		elseif (p2.powers[pw_super]) then
			superallowed = false
		end

		if ((p2.powers[pw_flashing])
		or (p2.powers[pw_invulnerability])
		or not superallowed) then
			return false
		end

		if (leveltime <= CV_FindVar("hidetime").value*TR)
		and (gametyperules & GTR_STARTCOUNTDOWN) then
			return false
		end

		if (p1.botleader == p2) then
			return false
		end
	end

	-- In COOP/RACE, you can't hurt other players unless cv_friendlyfire is on
	if (not (ff or (gametyperules & GTR_FRIENDLYFIRE))
	and (gametyperules & (GTR_FRIENDLY|GTR_RACE))) then
		allowhurt = false
	end

	if G_TagGametype() then
		if ((p2.pflags & PF_TAGIT and not ((ff or (gametyperules & GTR_FRIENDLYFIRE))
		and p1.pflags & PF_TAGIT))) then
			allowhurt = false
		end

		if (not (ff or (gametyperules & GTR_FRIENDLYFIRE))
		and (p2.pflags & PF_TAGIT == p1.pflags & PF_TAGIT)) then
			allowhurt = false
		end
	end

	if G_GametypeHasTeams() then
		if (not (ff or gametyperules & GTR_FRIENDLYFIRE))
		and (p2.ctfteam == p1.ctfteam) then
			allowhurt = false
		end
	end

	if P_PlayerInPain(p1) then
		allowhurt = false
	end

	if Takis_Hook then
		/*
			if true, force a hit
			if false, force no hits
			if nil, use the above checks
		*/
		local hook_event = Takis_Hook.events["CanPlayerHurtPlayer"]
		for i,v in ipairs(hook_event) do
			local result = Takis_Hook.tryRunHook("CanPlayerHurtPlayer", v, p1,p2,nobs)
			if result ~= nil then
				allowhurt = result
			end
		end
	end

	return allowhurt
end

---Follows a mobj's target position, scale and angle if desired
---@param mo mobj_t
---@param xadjust fixed_t
---@param yadjust fixed_t
---@param zadjust fixed_t
---@param scale any
---@param follow_angle any
local function GD_FollowMobj(mo, xadjust, yadjust, zadjust, scale, follow_angle)
	if not mo.target then return end
	local f = P_MobjFlip(mo.target)
	local pmo = mo.target

	--Move the object to the target's position
	local x,y,z = pmo.x+(xadjust or 0), pmo.y+(yadjust or 0), pmo.z + (f*zadjust)
	if (mo.x - x) or (mo.y - y) or (mo.z - z) then
		P_MoveOrigin(mo, x, y, z)
	end

	--Copy the angle if desired
	if follow_angle then
		if mo.angle != pmo.player.drawangle then mo.angle = pmo.player.drawangle end
	end

	--Copy other visual properties
	if mo.spriteroll != pmo.spriteroll then mo.spriteroll = pmo.spriteroll end --Follow sprite roll
	if mo.eflags != pmo.eflags then mo.eflags = pmo.eflags end --follow eflags, mostly for flipped gravity
	if pmo.player and mo.dontdrawforviewmobj != pmo then mo.dontdrawforviewmobj = pmo end --Don't draw in first person
	if mo.height != pmo.height then mo.height = pmo.height end --Adjust height, mostly for flipped gravity

	--Adjust Scale
	if scale then
		if mo.scale != scale then mo.scale = scale end
	elseif mo.scale != pmo.scale then mo.scale = pmo.scale
	end
end

rawset(_G, "GD_CanHurtPlayer", GD_CanHurtPlayer)
rawset(_G, "P_SpawnVisualFlag", P_SpawnVisualFlag)
rawset(_G, "S_ChangeGlobalMusic", S_ChangeGlobalMusic)
rawset(_G, "GD_FollowMobj", GD_FollowMobj)