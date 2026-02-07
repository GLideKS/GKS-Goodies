--All these stuff to sync chatactive and menu active per player.
--Ty Epix

local old_menuactive = false
local old_chatactive = false
local luasig = "iAmLua"..P_RandomFixed()
addHook("NetVars",function(n) luasig = n($); end)

COM_AddCommand("_menucheck", function(p, signature, status)
    if signature ~= luasig then return end
    if p.menuactive == nil then p.menuactive = false; end
    p.menuactive = (status == "true") and true or false
end)

COM_AddCommand("_chatcheck", function(p, signature, status)
    if signature ~= luasig then return end
    if p.chatactive == nil then p.chatactive = false; end
    p.chatactive = (status == "true") and true or false
end)

addHook("PostThinkFrame", function()
    local p = consoleplayer
    if not (p and p.valid) then return end

    if menuactive ~= old_menuactive then
        COM_BufInsertText(p, "_menucheck "..luasig.." "..tostring(menuactive))
    end
    if chatactive ~= old_chatactive then
        COM_BufInsertText(p, "_chatcheck "..luasig.." "..tostring(chatactive))
    end
    old_menuactive = menuactive
    old_chatactive = chatactive
end)

--Main Bubble Thinker

freeslot("SPR_GD_CHATBUBBLE", "SPR_GD_OPTIONS",
"MT_GD_BUBBLE", "S_GD_BUBBLE")

states[S_GD_BUBBLE] = {SPR_NULL, FF_ANIMATE|FF_FULLBRIGHT|A, -1, nil, 2, TICRATE/2, S_GD_BUBBLE}
mobjinfo[MT_GD_BUBBLE] = {
    doomednum = -1,
    spawnstate = S_GD_BUBBLE,
    radius = 10*FU,
    height = 10*FU,
    dispoffset = 10,
    flags = MF_NOCLIPTHING|MF_NOCLIPHEIGHT|MF_NOGRAVITY|MF_NOBLOCKMAP
}

--Chase always the player
local function bubblefollow(mo)
    local target = mo.target
    local p = target.player
    if not (p and target and (
        p.menuactive
        or p.chatactive
        or p.consoleactive
    )) then
        P_RemoveMobj(mo)
        return
    end

    local f = P_MobjFlip(target)

    P_MoveOrigin(mo, target.x, target.y, target.z+(f*(target.height+(7*target.scale))))
    mo.dontdrawforviewmobj = target --Don't draw in first person
    mo.scale = target.scale*3/2

	--Flip Checks
	if P_MobjFlip(target) == -1 then
		if not (mo.eflags & MFE_VERTICALFLIP) then
			mo.eflags = $|MFE_VERTICALFLIP
		end
	elseif (mo.eflags & MFE_VERTICALFLIP) then
		mo.eflags = $ & ~MFE_VERTICALFLIP
	end
end

--Spawn the bubble if the player is doing one of these actions
GoodiesHook.PlayerThink.Bubble = function (p)
    if not (p and p.mo and p.mo.valid) then return end

    if (p.menuactive or p.chatactive or p.consoleactive) then
        if p.mo.bubblespawn then return end
        local f = P_MobjFlip(p.mo)
        local bubble = P_SpawnMobj(p.mo.x, p.mo.y, p.mo.z+(f*(p.mo.height+(7*p.mo.scale))), MT_GD_BUBBLE)
        bubble.target = p.mo
        bubble.sprite = (p.chatactive and SPR_GD_CHATBUBBLE) or (p.menuactive and SPR_GD_OPTIONS)
        p.mo.bubblespawn = true
    else
        p.mo.bubblespawn = false
    end
end

addHook("MobjThinker", bubblefollow, MT_GD_BUBBLE)