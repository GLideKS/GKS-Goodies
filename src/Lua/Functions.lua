---Follows a mobj's target position, scale and angle if desired
---@param mo mobj_t
---@param xadjust fixed_t
---@param yadjust fixed_t
---@param zadjust fixed_t
---@param scale fixed_t
---@param follow_angle boolean
---@param height_adjust fixed_t
local function P_FollowMobj(mo, xadjust, yadjust, zadjust, scale, follow_angle, height_adjust)
	if not mo.target then return end
	local flipped = P_MobjFlip(mo.target) == -1
	local pmo = mo.target

	mo.dontdrawforviewmobj = pmo --Don't draw in first person

	--oh my god what is this MATH. if it works, IT WORKS
	P_MoveOrigin(mo, pmo.x+(xadjust or 0), pmo.y+(yadjust or 0), pmo.z+((flipped and ((pmo.height)+(zadjust or 0))) or (height_adjust or 0)))
	if follow_angle and mo.angle != pmo.player.drawangle then
		mo.angle = pmo.player.drawangle
	end
	if mo.spriteroll != pmo.spriteroll then
		mo.spriteroll = pmo.spriteroll
	end
	--Adjust Scale
	if scale then
		if mo.scale != scale then
			mo.scale = scale
		end
	elseif mo.scale != pmo.scale then
		mo.scale = pmo.scale
	end

	--Flip Checks merged here
	if P_MobjFlip(mo.target) == -1 then
		if not ((mo.flags2 & MF2_OBJECTFLIP) or (mo.eflags & MFE_VERTICALFLIP)) then
			mo.flags2 = $|MF2_OBJECTFLIP
			mo.eflags = $|MFE_VERTICALFLIP
		end
	elseif ((mo.flags2 & MF2_OBJECTFLIP) or (mo.eflags & MFE_VERTICALFLIP)) then
		mo.flags2 = $ & ~MF2_OBJECTFLIP
		mo.eflags = $ & ~MFE_VERTICALFLIP
	end
end
rawset(_G, "P_FollowMobj", P_FollowMobj)

---Spawns a VFX for the player
---@param p player_t
local function P_SpawnVisualFlag(p)
if (p.flagmobj and p.flagmobj.valid) then return end
	p.flagmobj = P_SpawnMobjFromMobj(p.mo, 0,0,0, MT_GKS_FLAGHOLD)
	p.flagmobj.target = p.mo
	if p.ctfteam == 1 then --Red Team
		p.flagmobj.sprite = SPR_BFLG
	elseif p.ctfteam == 2 then --Blue Team
		p.flagmobj.sprite = SPR_RFLG
	end
    p.flagmobj.frame = FF_PAPERSPRITE|B
end

rawset(_G, "P_SpawnVisualFlag", P_SpawnVisualFlag)
rawset(_G, "NK_SpawnVFX", NK_SpawnVFX)