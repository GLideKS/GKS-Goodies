--All these stuff to sync chatactive and menu active per player.
--Ty Epix

SafeFreeslot("SPR_GD_CHATBUBBLE", "SPR_GD_OPTIONS", "SPR_GD_TERMINAL",
"MT_GD_BUBBLE", "S_GD_BUBBLE")
local SPR_GD_CHATBUBBLE = SPR_GD_CHATBUBBLE
local SPR_GD_OPTIONS = SPR_GD_OPTIONS
local MT_GD_BUBBLE = MT_GD_BUBBLE
local S_GD_BUBBLE = S_GD_BUBBLE

local old_menuactive = false
local old_chatactive = false
local luasig = "iAmLua"..P_RandomFixed()
gBundleHook("NetVars", "Random Fixed", function(n) luasig = n($); end)

local bubble_scale = FU * 3 / 2

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

gBundleHook("PostThinkFrame", "Synced status check", function()
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

states[S_GD_BUBBLE] = {SPR_NULL, FF_ANIMATE|FF_FULLBRIGHT|A, -1, nil, 2, TICRATE/2, S_GD_BUBBLE}
mobjinfo[MT_GD_BUBBLE] = {
    doomednum = -1,
    spawnstate = S_GD_BUBBLE,
    radius = 10*FU,
    height = 10*FU,
    dispoffset = 10,
    flags = MF_NOCLIPTHING|MF_NOCLIPHEIGHT|MF_NOGRAVITY|MF_NOBLOCKMAP|MF_SCENERY
}

local function Set_Z(mo)
    local capped_height = min(mo.height, FixedMul(skins[mo.skin].height, mo.scale)) -- There will be addon cases that mobj's height will be too far from the sprites so let's better cap this.
    local yscale_offset = FixedDiv(mo.spriteyscale, mo.scale)

    local height = FixedMul(capped_height, yscale_offset)

    return height
end

--Returns a bubble sprite depending of the player's status
---@param p player_t
local function StatusToSprite(p)
    if p.menuactive then return SPR_GD_OPTIONS
    elseif p.chatactive then return SPR_GD_CHATBUBBLE
    end
end

local function StatusCheck(p)
    if ((p.menuactive or p.chatactive) and not p.quittime) then return true end
    return false
end

--Chase always the player
local function bubblefollow(mo)
    local t = mo.target

    if not ((t and t.valid) and StatusCheck(p)) then
        P_RemoveMobj(mo)
        return
    end

    local p = t.player

    mo.sprite = StatusToSprite(p)
	GD_FollowMobj(mo, 0, 0, Set_Z(t))
end

--Spawn the bubble if the player is doing one of these actions
gBundleHook("PlayerThink", "Spawn Bubble", function(p)
    local mo = p.mo
    if not (mo and mo.valid) then return end

    if StatusCheck(p) then
        if not mo.bubble then
            local bubble = P_SpawnMobjFromMobj(mo, 0, 0, Set_Z(mo), MT_GD_BUBBLE)
            bubble.target = mo
            bubble.spritexscale, bubble.spriteyscale = bubble_scale, bubble_scale
            mo.bubble = true
        end
    elseif mo.bubble then
        mo.bubble = false
    end
end)

gBundleHook("MobjThinker", "Bubble Follow", bubblefollow, MT_GD_BUBBLE)