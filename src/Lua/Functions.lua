---Spawns a flag for the player
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