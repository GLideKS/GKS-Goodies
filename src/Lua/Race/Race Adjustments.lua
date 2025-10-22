--Prevent damage from other players on countdown
addHook("PlayerThink", function(p)
	if not (gametype == GT_RACE) return end
	if not (p and p.mo and p.mo.valid) return end
	if (leveltime < 4*TICRATE) or (p.realtime == 0)
		if not (p.mo.flags & MF_NOCLIPTHING)
			p.mo.flags = $|MF_NOCLIPTHING
		end
	elseif (p.mo.flags & MF_NOCLIPTHING)
	and leveltime == (4*TICRATE)+5
		p.mo.flags = $ &~MF_NOCLIPTHING
	end
end)