-- TODO: Orbit around the player in proportion of the shards collected to be a symmetrical rotation

SafeFreeslot("MT_SHARDHOLD", "S_SHARDHOLD")

-- Localize to optimize
local MT_SHARDHOLD = MT_SHARDHOLD
local S_SHARDHOLD = S_SHARDHOLD
local addHook = addHook
local A_RotateSpikeBall = A_RotateSpikeBall
local P_SpawnMobjFromMobj = P_SpawnMobjFromMobj
local flags = MF_SCENERY|MF_NOGRAVITY|MF_NOBLOCKMAP|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOCLIPTHING

states[S_SHARDHOLD] = {SPR_SHRD, A, -1, A_RotateSpikeBall, 0, 0, S_SHARDHOLD}
mobjinfo[MT_SHARDHOLD] = {
    doomednum = -1,
    spawnstate = S_SHARDHOLD,
    speed = 4 * FU,
    radius = 20 * FU,
    height = 20 * FU,
    flags = flags
}

local function ShardTouch(mo, toucher)
    if toucher.gdshards and toucher.gdshards >= 3 then return end -- Uh you're supposed to grab 3 shards at maximum

    local shard = P_SpawnMobjFromMobj(toucher, 0, 0, 0, MT_SHARDHOLD) -- You got a shard! orbit around the player.
    shard.target = toucher
    shard.frame = mo.frame -- Give the shard's frame to the orbiting shard
    toucher.gdshards = not toucher.gdshards and 1 or ($ + 1)
end

local function ShardMain(mo)
    A_RotateSpikeBall(mo, 0, 0) -- The reason of why is not in the state directly is due to the shard frame being modified as well.
end

addHook("TouchSpecial", ShardTouch, MT_EMERHUNT)
addHook("MobjThinker", ShardMain, MT_SHARDHOLD)