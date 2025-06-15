--Script by GLide KS

--Default Voices (SONIC R)
freeslot("sfx_defset",
		 "sfx_defgo", 
		 "sfx_defred")

--Amy Freeslot Voices
freeslot("sfx_amyvc1",
		 "sfx_amyvc2", 
		 "sfx_amyrd",
		 "sfx_amyhur")

--Sonic Freeslot Voices
freeslot("sfx_sncvc1",
		 "sfx_sncvc2", 
		 "sfx_sncrd1",
		 "sfx_sncrd2",
		 "sfx_sncgo",
		 "sfx_snchur")
		 
--Knuckles Freeslot Voices
freeslot("sfx_knxvc1",
		 "sfx_knxvc2",
		 "sfx_knxvc3",
		 "sfx_knxvc4", 
		 "sfx_knxrd1",
		 "sfx_knxgo",
		 "sfx_knxhr1",
		 "sfx_knxhr2",
		 "sfx_knxhr3")
		 
--Tails Freeslot Voices
freeslot("sfx_tlsvc1",
		 "sfx_tlsvc2",
		 "sfx_tlsrd1",
		 "sfx_tlsgo",
		 "sfx_tlshr1",
		 "sfx_tlshr2",
		 "sfx_tlshr3")
		 
--Metal Sonic Freeslot Voices
freeslot("sfx_mtlvc1",
		 "sfx_mtlvc2",
		 "sfx_mtlvc3",
		 "sfx_mtlrd1",
		 "sfx_mtlrd2",
		 "sfx_mtlrd3",
		 "sfx_mtlgo",
		 "sfx_mtlhur")

--SA Sonic Freeslot Voices
freeslot("sfx_sasvc1",
		 "sfx_sasvc2",
		 "sfx_sasvc3", 
		 "sfx_sasrd1",
		 "sfx_sasgo",
		 "sfx_sashr1",
		 "sfx_sashr2",
		 "sfx_sashr3",
		 "sfx_sashr4")
		 
--Shadow Freeslot Voices
freeslot("sfx_sdwvc1",
		 "sfx_sdwvc2",
		 "sfx_sdwvc3", 
		 "sfx_sdwvc4",
		 "sfx_sdwrd1",
		 "sfx_sdwrd2",
		 "sfx_sdwrd3",
		 "sfx_sdwrd4",
		 "sfx_sdwgo",
		 "sfx_sdwhr1",
		 "sfx_sdwhr2",
		 "sfx_sdwhr3"
		 )
		 
--Jet Freeslot Voices
freeslot("sfx_jetvc1",
		 "sfx_jetvc2",
		 "sfx_jetrd1",
		 "sfx_jethr1"
		 )
		 
--Takis Freeslot Voices
freeslot(
		 "sfx_tkshr1",
		 "sfx_tkshr2",
		 "sfx_tkshr3"
		 )

--Character variants (there's a lot in the message board...)

local amy_variants = {
	amy = true,
	rosegoldamy = true
}

local sonic_variants = {
	sonic = true,
	ssnsonic = true
}

local knux_variants = {
	knuckles = true,
	rocknux = true
}

local tails_variants = {
	tails = true,
	jellytails = true
}

local metal_variants = {
	metalsonic = true,
	jetmetalsonic = true,
	metalknuckles = true
}

local shadow_variants = {
	shadow = true,
	ssnshadow = true
}

--Voices for unsupported chars or unknown voices
--(Updated for each rotation the server has)
local default_voice = {
	fang = true,
	smiles = true,
	cinos = true,
	willo = true,
	blossom = true,
	flimp = true,
	tailsdoll = true,
	jana = true,
	skip = true,
	kou = true,
	maimy = true,
	cacee = true,
	mach = true,
	veph = true,
	ugly = true
}

addHook("PlayerThink", function(player)
	local p = player
	local check_lapcount = (CV_FindVar("numlaps").value) or (mapheaderinfo[gamemap].numlaps) or 4
	if not p.victorysoundplayed
		p.victorysoundplayed = false
	end
	
	if p.mo and p.mo.valid and (gametyperules & GTR_RACE) --previous checks
	
/*--------------GOAL SOUNDS---------------*/
	
		if p.laps >= check_lapcount or p.pflags & PF_FINISHED
			
			--Amy
			if amy_variants[p.mo.skin]
			and not p.victorysoundplayed then
				S_StartSound(p.mo, P_RandomRange(sfx_amyvc1,sfx_amyvc2))
				p.victorysoundplayed = true
			end
			
			--Sonic
			if sonic_variants[p.mo.skin]
			and not p.victorysoundplayed then
				S_StartSound(p.mo, P_RandomRange(sfx_sncvc1,sfx_sncvc2))
				p.victorysoundplayed = true
			end
			
			--Knuckles
			if knux_variants[p.mo.skin]
			and not p.victorysoundplayed then
				S_StartSound(p.mo, P_RandomRange(sfx_knxvc1,sfx_knxvc4))
				p.victorysoundplayed = true
			end
			
			--Tails
			if tails_variants[p.mo.skin]
			and not p.victorysoundplayed then
				S_StartSound(p.mo, P_RandomRange(sfx_tlsvc1,sfx_tlsvc2))
				p.victorysoundplayed = true
			end
			
			--Metal Sonic and Metal Knux
			if metal_variants[p.mo.skin]
			and not p.victorysoundplayed then
				S_StartSound(p.mo, P_RandomRange(sfx_mtlvc1,sfx_mtlvc3))
				p.victorysoundplayed = true
			end
			
			--Shadow
			if shadow_variants[p.mo.skin]
			and not p.victorysoundplayed then
				S_StartSound(p.mo, P_RandomRange(sfx_sdwvc1,sfx_sdwvc4))
				p.victorysoundplayed = true
			end
			
			--SA Sonic
			if p.mo.skin == "adventuresonic" and not p.victorysoundplayed then
				S_StartSound(p.mo, P_RandomRange(sfx_sasvc1,sfx_sasvc3))
				p.victorysoundplayed = true
			end
			
			--Jet
			if p.mo.skin == "jet" and not p.victorysoundplayed then
				S_StartSound(p.mo, P_RandomRange(sfx_jetvc1,sfx_jetvc2))
				p.victorysoundplayed = true
			end
			
		else
			p.victorysoundplayed = false

/*--------------HURRY SOUNDS---------------*/

			if p.hurry_voice and not p.hurryplayedsound then
			
			
				--Sonic
				if sonic_variants[p.mo.skin]
					S_StartSound(p.mo, sfx_snchur, p)
					player.hurryplayedsound = true
				end
				
				--Amy
				if amy_variants[p.mo.skin]
					S_StartSound(p.mo, sfx_amyhur, p)
					player.hurryplayedsound = true
				end
				
				--Knuckles
				if knux_variants[p.mo.skin]
					S_StartSound(p.mo, P_RandomRange(sfx_knxhr1,sfx_knxhr3), p)
					player.hurryplayedsound = true
				end
				
				--Tails
				if tails_variants[p.mo.skin]
					S_StartSound(p.mo, P_RandomRange(sfx_tlshr1,sfx_tlshr3), p)
					player.hurryplayedsound = true
				end
				
				--Metal Sonic
				if metal_variants[p.mo.skin]
					S_StartSound(p.mo, sfx_mtlhur, p)
					player.hurryplayedsound = true
				end
				
				--Shadow
				if shadow_variants[p.mo.skin]
					S_StartSound(p.mo, P_RandomRange(sfx_sdwhr1,sfx_sdwhr3), p)
					player.hurryplayedsound = true
				end
				
				--Adventure Sonic
				if p.mo.skin == "adventuresonic"
					S_StartSound(p.mo, P_RandomRange(sfx_sashr1,sfx_sashr4), p)
					player.hurryplayedsound = true
				end
				
				--Takis
				if p.mo.skin == "takisthefox"
					S_StartSound(p.mo, P_RandomRange(sfx_tkshr1,sfx_tkshr3), p)
					player.hurryplayedsound = true
				end
				
				--Jet
				if p.mo.skin == "jet"
					S_StartSound(p.mo, sfx_jethr1, p)
					player.hurryplayedsound = true
				end
			end
		end
		
/*--------------READY SOUNDS---------------*/
		
		if leveltime == 25 then --Ready Sound
		
			--Amy
			if amy_variants[p.mo.skin]
				S_StartSound(p.mo, sfx_amyrd, p)
			end
			
			--Sonic
			if sonic_variants[p.mo.skin]
				S_StartSound(p.mo, P_RandomRange(sfx_sncrd1,sfx_sncrd2), p)
			end
			
			--Knuckles
			if knux_variants[p.mo.skin]
				S_StartSound(p.mo, sfx_knxrd1, p)
			end
			
			--Tails
			if tails_variants[p.mo.skin]
				S_StartSound(p.mo, sfx_tlsrd1, p)
			end
			
			--Metal Sonic
			if metal_variants[p.mo.skin]
				S_StartSound(p.mo, P_RandomRange(sfx_mtlrd1,sfx_mtlrd3), p)
			end
			
			--Shadow
			if shadow_variants[p.mo.skin]
				S_StartSound(p.mo, P_RandomRange(sfx_sdwrd1,sfx_sdwrd4), p)
			end
			
			--Adventure Sonic
			if p.mo.skin == "adventuresonic" then
				S_StartSound(p.mo, sfx_sasrd1, p)
			end
			
			--Takis
			if p.mo.skin == "takisthefox" then
				S_StartSound(p.mo, sfx_tkshr3, p)
			end
			
			--Takis
			if p.mo.skin == "jet" then
				S_StartSound(p.mo, sfx_jetrd1, p)
			end
		end	
		
/*--------------GO SOUNDS---------------*/
		
		if leveltime == 140 then
		
			--Sonic
			if default_voice[p.mo.skin]
				S_StartSound(p.mo, sfx_defgo, p)
			end
			
			--Sonic
			if sonic_variants[p.mo.skin]
				S_StartSound(p.mo, sfx_sncgo, p)
			end
			
			--Knuckles
			if knux_variants[p.mo.skin]
				S_StartSound(p.mo, sfx_knxgo, p)
			end
			
			--Metal Sonic
			if metal_variants[p.mo.skin]
				S_StartSound(p.mo, sfx_mtlgo, p)
			end
			
			--Tails
			if tails_variants[p.mo.skin]
				S_StartSound(p.mo, sfx_tlsgo, p)
			end
			
			--Shadow
			if shadow_variants[p.mo.skin]
				S_StartSound(p.mo, sfx_sdwgo, p)
			end
			
			--Adventure Sonic
			if p.mo.skin == "adventuresonic" then
				S_StartSound(p.mo, sfx_sasgo, p)
			end
		end
		
/*--------------DEFAULT VOICE---------------*/

		if leveltime == 35 then --READY
			if default_voice[p.mo.skin]
				S_StartSound(p.mo, sfx_defred, p)
			end
		end
		
		if leveltime == 105 then --SET
			if default_voice[p.mo.skin]
				S_StartSound(p.mo, sfx_defset, p)
			end
		end
		
		if leveltime == 140 then --GO
			if default_voice[p.mo.skin]
				S_StartSound(p.mo, sfx_defgo, p)
			end
		end
		
		
		
	end
end)

