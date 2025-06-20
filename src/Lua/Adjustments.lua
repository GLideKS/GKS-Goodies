--Prevent damage from other players 
addHook("PlayerThink", function(p)
	if not (gametype == GT_RACE) return end
	if not (p and p.mo and p.mo.valid) return end
	if (leveltime < 4*TICRATE) or (p.realtime == 0)
		p.mo.flags = $|MF_NOCLIPTHING
	else
		p.mo.flags = $ &~MF_NOCLIPTHING
	end
end)