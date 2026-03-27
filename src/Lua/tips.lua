--List of prefix colors
GKSGoodies.prefixcolors = {
	["white"] = "\x80",
	["magenta"] = "\x81",
	["yellow"] = "\x82",
	["green"] = "\x83",
	["blue"] = "\x84",
	["red"] = "\x85",
	["gray"] = "\x86",
	["orange"] = "\x87",
	["sky"] = "\x88",
	["purple"] = "\x89",
	["aqua"] = "\x8A",
	["peridot"] = "\x8B",
	["azure"] = "\x8C",
	["brown"] = "\x8D",
	["rosy"] = "\x8E",
	["inverted"] = "\x8F"
}

GoodiesHook.ThinkFrame.Messages = function()
	if not (netgame and multiplayer) then return end

	local prefix = GKSGoodies.serverprefix.text
	local prefix_color = GKSGoodies.serverprefix.color
	local colors = GKSGoodies.prefixcolors

	if #GKSGoodies.tips.messages --Tips
	and ((leveltime % 6300) == 700) then
		local tip_message = GKSGoodies.tips.messages[P_RandomRange(1, #GKSGoodies.tips.messages)]
		local tip_sound = GKSGoodies.tips.sound
		chatprint(colors[prefix_color].."<"..prefix.."> "..colors["white"]..tip_message)
		S_StartSound(nil, tip_sound)
	end

	for p in players.iterate do --Welcome
		if not (p.jointime == TICRATE) then continue end
		local welcome_message = GKSGoodies.welcome.message
		local welcome_sound = GKSGoodies.welcome.sound
		chatprintf(p, colors[prefix_color].."<"..prefix.."> "..colors["white"]..welcome_message)
		S_StartSound(nil, welcome_sound, p)
	end
end