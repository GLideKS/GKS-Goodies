--Prevent damage from other players on countdown
GoodiesHook.PlayerThink.RaceCountdownNoDMG = function(p)
	if not (gametype == GT_RACE) then return end
	if not (p and p.mo and p.mo.valid) then return end
	if (leveltime < 4*TICRATE) or (p.realtime == 0) then
		if not (p.mo.flags & MF_NOCLIPTHING) then
			p.mo.flags = $|MF_NOCLIPTHING
		end
	elseif (p.mo.flags & MF_NOCLIPTHING)
	and leveltime == (4*TICRATE)+5 then
		p.mo.flags = $ &~MF_NOCLIPTHING
	end
end