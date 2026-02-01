local sfx_amyvc1 = sfx_amyvc1
local sfx_amyvc2 = sfx_amyvc2
local sfx_amyrd = sfx_amyrd
local sfx_amyhur = sfx_amyhur
local sfx_sncvc1 = sfx_sncvc1
local sfx_sncvc2 = sfx_sncvc2
local sfx_sncrd1 = sfx_sncrd1
local sfx_sncrd2 = sfx_sncrd2
local sfx_sncgo = sfx_sncgo
local sfx_snchur = sfx_snchur
local sfx_knxvc1 = sfx_knxvc1
local sfx_knxvc2 = sfx_knxvc2
local sfx_knxvc3 = sfx_knxvc3
local sfx_knxvc4 = sfx_knxvc4
local sfx_knxrd1 = sfx_knxrd1
local sfx_knxgo = sfx_knxgo
local sfx_knxhr1 = sfx_knxhr1
local sfx_knxhr2 = sfx_knxhr2
local sfx_knxhr3 = sfx_knxhr3
local sfx_tlsvc1 = sfx_tlsvc1
local sfx_tlsvc2 = sfx_tlsvc2
local sfx_tlsrd1 = sfx_tlsrd1
local sfx_tlsgo = sfx_tlsgo
local sfx_tlshr1 = sfx_tlshr1
local sfx_tlshr2 = sfx_tlshr2
local sfx_tlshr3 = sfx_tlshr3
local sfx_mtlvc1 = sfx_mtlvc1
local sfx_mtlvc2 = sfx_mtlvc2
local sfx_mtlvc3 = sfx_mtlvc3
local sfx_mtlrd1 = sfx_mtlrd1
local sfx_mtlrd2 = sfx_mtlrd2
local sfx_mtlrd3 = sfx_mtlrd3
local sfx_mtlgo = sfx_mtlgo
local sfx_mtlhur = sfx_mtlhur

//-------------------Character Definitions------------------

GKSR_Voices["sonic"] = {
	ready = {sfx_sncrd1, sfx_sncrd2},
	hurry = sfx_snchur,
	go = sfx_sncgo,
	victory = {sfx_sncvc1, sfx_sncvc2}
}

GKSR_Voices["tails"] = {
	ready = sfx_tlsrd1,
	hurry = {sfx_tlshr1, sfx_tlshr2, sfx_tlshr3},
	go = sfx_tlsgo,
	victory = {sfx_tlsvc1, sfx_tlsvc2}
}

GKSR_Voices["knuckles"] = {
	ready = sfx_knxrd1,
	hurry = {sfx_knxhr1, sfx_knxhr2, sfx_knxhr3},
	go = sfx_knxgo,
	victory = {sfx_knxvc1, sfx_knxvc2, sfx_knxvc3, sfx_knxvc4}
}

GKSR_Voices["amy"] = {
	ready = sfx_amyrd,
	hurry = sfx_amyhur,
	victory = {sfx_amyvc1, sfx_amyvc2}
}

GKSR_Voices["metalsonic"] = {
	ready = {sfx_mtlrd1, sfx_mtlrd2, sfx_mtlrd3, sfx_mtlrd4},
	hurry = sfx_mtlhur,
	go = sfx_mtlgo,
	victory = {sfx_mtlvc1, sfx_mtlvc2, sfx_mtlvc3}
}