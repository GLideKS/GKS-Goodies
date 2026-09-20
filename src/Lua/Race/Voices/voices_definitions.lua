if not GKSR_Voices then rawset(_G, "GKSR_Voices", {}) end

GKSR_Voices["sonic"] = {
	ready = sfx_cdpcm2,
	hurry = sfx_cdpcm3,
	go = sfx_cdpcm5,
	victory = {sfx_cdpcm4, sfx_cdpcm5}
}
