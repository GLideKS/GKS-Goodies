--All these stuff to sync chatactive and menu active per player.
--Ty Epix

SafeFreeslot("SPR_GD_CHATBUBBLE", "SPR_GD_OPTIONS", "SPR_GD_TERMINAL",
"MT_GD_BUBBLE", "S_GD_BUBBLE")
local SPR_GD_CHATBUBBLE = SPR_GD_CHATBUBBLE
local SPR_GD_OPTIONS = SPR_GD_OPTIONS
local SPR_GD_TERMINAL = SPR_GD_TERMINAL
local MT_GD_BUBBLE = MT_GD_BUBBLE
local S_GD_BUBBLE = S_GD_BUBBLE

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

states[S_GD_BUBBLE] = {SPR_NULL, FF_ANIMATE|FF_FULLBRIGHT|A, -1, nil, 2, TICRATE/2, S_GD_BUBBLE}
mobjinfo[MT_GD_BUBBLE] = {
    doomednum = -1,
    spawnstate = S_GD_BUBBLE,
    radius = 10*FU,
    height = 10*FU,
    dispoffset = 10,
    flags = MF_NOCLIPTHING|MF_NOCLIPHEIGHT|MF_NOGRAVITY|MF_NOBLOCKMAP|MF_SCENERY
}

--Returns a bubble sprite depending of the player's status
---@param p player_t
local function StatusToSprite(p)
    if p.consoleactive then return SPR_GD_TERMINAL
    elseif p.menuactive then return SPR_GD_OPTIONS
    elseif p.chatactive then return SPR_GD_CHATBUBBLE
    end
end

--Chase always the player
local function bubblefollow(mo)
    local t = mo.target
    local p = t.player
    if not ((t and t.valid and p) and (
        p.menuactive
        or p.chatactive
        or p.consoleactive
    )) then
        P_RemoveMobj(mo)
        return
    end

    --Cache target's stuff
	local z = t.height+(5*t.scale) --position
    local sprite = StatusToSprite(p)

    --Follow the object
	GD_FollowMobj(mo, 0, 0, z, t.scale*3/2)
    if mo.sprite != sprite then mo.sprite = sprite end
end

--Spawn the bubble if the player is doing one of these actions
GoodiesHook.PlayerThink.Bubble = function (p)
    if not (p.mo and p.mo.valid) then return end

    local mo = p.mo
    if (p.consoleactive or p.menuactive or p.chatactive) then
        if mo.bubblespawn then return end
        local f = P_MobjFlip(mo)
        local bubble = P_SpawnMobjFromMobj(mo, 0 , 0, f*(mo.height+(5*mo.scale)), MT_GD_BUBBLE)
        bubble.target = mo
        bubble.height = mo.height
        bubble.eflags = mo.eflags
        mo.bubblespawn = true
    else
        mo.bubblespawn = false
    end
end

addHook("MobjThinker", bubblefollow, MT_GD_BUBBLE)