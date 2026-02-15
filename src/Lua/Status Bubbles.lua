--All these stuff to sync chatactive and menu active per player.
--Ty Epix

local old_menuactive = false
local old_chatactive = false
local consoleactive = false
local old_consoleactive = false
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

COM_AddCommand("_consolecheck", function(p, signature, status)
    if signature ~= luasig then return end
    if p.consoleactive == nil then p.consoleactive = false; end
    p.consoleactive = (status == "true") and true or false
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
    if consoleactive ~= old_consoleactive then
        COM_BufInsertText(p, "_consolecheck "..luasig.." "..tostring(consoleactive))
    end
    old_menuactive = menuactive
    old_chatactive = chatactive
    old_consoleactive = consoleactive
end)

local function openconsole(key)
    local con_key = (key.num == input.gameControlToKeyNum(GC_CONSOLE)) --We are pressing the console key again?
                    and true or false
    if not con_key then return end
    if chatactive then return end --do not run on chat
    if not consoleactive then consoleactive = true end
end

local function closeconsole(key)
    local con_key = (key.num == input.gameControlToKeyNum(GC_CONSOLE) --We are pressing the console key again?
                    or key.name == "escape") --Or we are pressing the escape key to exit the console
                    and true or false
    if not con_key then return end
    if chatactive then return end --do not run on chat
    if consoleactive then consoleactive = false end
end
addHook("KeyDown", openconsole)
addHook("KeyUp", closeconsole)

--Main Bubble Thinker

SafeFreeslot("SPR_GD_CHATBUBBLE", "SPR_GD_OPTIONS", "SPR_GD_TERMINAL",
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
    local p = mo.target.player

    if not ((target and target.valid and p) and (
        p.menuactive
        or p.chatactive
        or p.consoleactive
    )) then
        P_RemoveMobj(mo)
        return
    end

    local f = P_MobjFlip(target)
    local sprite = (p.consoleactive and SPR_GD_TERMINAL)
                or (p.menuactive and SPR_GD_OPTIONS)
                or (p.chatactive and SPR_GD_CHATBUBBLE)
    local scale = target.scale*3/2

    P_MoveOrigin(mo, target.x, target.y, target.z+(f*(target.height+(5*target.scale))))
    if mo.sprite != sprite then mo.sprite = sprite end
    if mo.scale != scale then mo.scale = scale end
    if mo.dontdrawforviewmobj != target then mo.dontdrawforviewmobj = target end --Don't draw in first person

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

    if (p.consoleactive or p.menuactive or p.chatactive) then
        if p.mo.bubblespawn then return end
        local f = P_MobjFlip(p.mo)
        local bubble = P_SpawnMobj(p.mo.x, p.mo.y, p.mo.z+(f*(p.mo.height+(5*p.mo.scale))), MT_GD_BUBBLE)
        bubble.target = p.mo
        p.mo.bubblespawn = true
    else
        p.mo.bubblespawn = false
    end
end

addHook("MobjThinker", bubblefollow, MT_GD_BUBBLE)