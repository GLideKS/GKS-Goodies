//TODO: Adapt this to make it customizable

/*local DidYouKnow = {}

DidYouKnow[0] = "\128Tip: Press \130Custom 1 \128after a spring to use advance trick. You can gain speed with it!"
DidYouKnow[1] = "\128Tip: Press \130forward or jump \128repeated times to charge your spindash fast! like classic games."
DidYouKnow[2] = "\128You can enable or disable super form animations with \130supersprites \128command."
DidYouKnow[3] = "\128All players agreed that this level sucks? alright, to skip it, a minimum of players needs to say \130rtv \128in the chat."
DidYouKnow[4] = "\128Pro tip: Be wise when platforming, or else players will catch up to you!"
DidYouKnow[5] = "\128Pro tip: Downwards slopes and speedpads are a good choice to build speed."
DidYouKnow[6] = "\128Don't like air acceleration? use \130airacceleration_toggle \128to disable or enable air acceleration. Or Adjust with \130airacceleration_amount. \128has better air control if you use it. but depends on your play style."

local server_motd = false

addHook("ThinkFrame", function()
	local g = P_RandomKey(#DidYouKnow)
	if multiplayer
		if (leveltime % 6300) == 700
			if G_IsSpecialStage(gamemap) then return end
			chatprint("\x87<~GKS> " ..DidYouKnow[g])
			S_StartSound(player, sfx_3db06)
		end
	end
end)

addHook("PlayerJoin", function ()
	if server_motd == false
		chatprint("\x83\Welcome to \x82\ GKS Racing Server\x83\! Good luck on the races and have fun!")
		server_motd = true
	end
end)

addHook("ThinkFrame", function()
	if leveltime == 1
		if server_motd == false
			server_motd = true
		end
	end
end)*/