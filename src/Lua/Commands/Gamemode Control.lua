--Defaults

CV_RegisterVar({
	name = "default_timelimit",
	defaultvalue = 6,
	PossibleValue = {MIN=0, MAX=30},
	flags = CV_NETVAR
})

CV_RegisterVar({
	name = "default_pointlimit",
	defaultvalue = 0,
	PossibleValue = CV_Unsigned,
	flags = CV_NETVAR
})

--CTF

CV_RegisterVar({
	name = "ctf_timelimit",
	defaultvalue = 0,
	PossibleValue = {MIN=0, MAX=30},
	flags = CV_NETVAR
})

CV_RegisterVar({
	name = "ctf_pointlimit",
	defaultvalue = 0,
	PossibleValue = CV_Unsigned,
	flags = CV_NETVAR
})

--Match

CV_RegisterVar({
	name = "match_timelimit",
	defaultvalue = 0,
	PossibleValue = {MIN=0, MAX=30},
	flags = CV_NETVAR
})

CV_RegisterVar({
	name = "match_pointlimit",
	defaultvalue = 0,
	PossibleValue = CV_Unsigned,
	flags = CV_NETVAR
})

--Tag

CV_RegisterVar({
	name = "tag_timelimit",
	defaultvalue = 0,
	PossibleValue = {MIN=0, MAX=30},
	flags = CV_NETVAR
})

CV_RegisterVar({
	name = "tag_pointlimit",
	defaultvalue = 0,
	PossibleValue = CV_Unsigned,
	flags = CV_NETVAR
})

--H&S

CV_RegisterVar({
	name = "hs_timelimit",
	defaultvalue = 0,
	PossibleValue = {MIN=0, MAX=30},
	flags = CV_NETVAR
})

CV_RegisterVar({
	name = "hs_pointlimit",
	defaultvalue = 0,
	PossibleValue = CV_Unsigned,
	flags = CV_NETVAR
})