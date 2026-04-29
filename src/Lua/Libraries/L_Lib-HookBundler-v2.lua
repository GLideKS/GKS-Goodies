--//// Malice Furia's Hook Bundler Script ////--
--//// Credit mainly goes to Glide KS and some other folks from Soashi's for alerting me to this idea(?) ////--
--//// Works with any and all hook types, and *should* behave identically when multiple hooks return different things ////--
--//// If you need to contact me, do it on the MB (do note, I don't check often at all.) ////--


--> Enables the changing/removing of functions in hooks.
--! Keep in mind they are NOT net synced.
rawset(_G, "MaliceHooksAllowChanges", false)

--// Compat //--

local MALICEHOOKVERSION = 2
if MaliceHooksLoaded ~= nil then
	if MaliceHooksLoaded < MALICEHOOKVERSION then
		print("\x85\[!] Warning: The already loaded version of Hook Bundler is out of date, please update it or reach out to the mod's developer. [!]")
		print("\x85\[!] Alternatively, load this mod first. [!]")
	end
	return
end

rawset(_G, "MaliceHooksLoaded", MALICEHOOKVERSION)


--// Localize //--

local type = type
local error = error
local print = print
local pairs = pairs
local unpack = unpack
local pcall = pcall
local select = select

local addHook = addHook


--// Tables //--

--> No return type. No extra.
local Hooks_NRT_NE = {
	IntermissionThinker = false,
	MapChange = false,
	MapLoad = false,
	
	PreThinkFrame = false,
	ThinkFrame = false,
	PostThinkFrame = false,
	
	GameQuit = false,
	
	NetVars = false,
	PlayerJoin = false,
	PlayerQuit = false,
	
	PlayerThink = false,
	PlayerSpawn = false,
	
	PlayerCmd = false,
	
	AddonLoaded = false
}

--> Return type. No extra.
local Hooks_RT_NE = {
	BotTiccmd = false,
	BotRespawn = false,
	
	PlayerMsg = false,
	TeamSwitch = false,
	ViewpointSwitch = false,
	SeenPlayer = false,
	
	PlayerCanDamage = false,
	PlayerHeight = false,
	PlayerCanEnterSpinGaps = false,
	ShieldSpawn = false,
	
	AbilitySpecial = false,
	JumpSpecial = false,
	JumpSpinSpecial = false,
	SpinSpecial = false,
	ShieldSpecial = false,
	
	MusicChange = false,
	
	KeyDown = false,
	KeyUp = false,
}

-- No return type. Extra.
local Hooks_NRT_E = {
	LinedefExecute = {},
	HUD = {}
}

-- Return type. Extra.
local Hooks_RT_E = {
	BotAI = {},
	
	HurtMsg = {},
	
	MapThingSpawn = {},
	MobjSpawn = {},
	MobjRemoved = {},
	MobjThinker = {},
	MobjFuse = {},
	BossThinker = {},
	
	ShouldDamage = {},
	MobjDamage = {},
	MobjDeath = {},
	BossDeath = {},
	FollowMobj = {},
	MobjCollide = {},
	MobjLineCollide = {},
	MobjMoveBlocked = {},
	MobjMoveCollide = {},
	TouchSpecial = {},
	
	ShouldJingleContinue = {}
}

local Hooks_SPEC = {
	PrePlayerThink = false,
	PostPlayerThink = false
}

--> For checking the validity of hooks.
local ExtraTypes = {
	LinedefExecute = "string",
	HUD = "string",
	BotAI = "string",
	ShouldJingleContinue = "string"
}


--// Functions //--

local function bundleHook(hook, hookName, hookFunction, extra)
	if type(hook) ~= "string" then error("Hook type must be a string.") return end
	if type(hookName) ~= "string" then error("Hook name must be a string.") return end
	if type(hookFunction) ~= "function" then error("Hook function must be a function.") return end

	--> No return type. No extra.
	if Hooks_NRT_NE[hook] ~= nil then
		if Hooks_NRT_NE[hook] == false then
			print("\x82\[HookBundle] Initializing hook bundle \""..hook.."\"...")
			Hooks_NRT_NE[hook] = {}

			addHook(hook, function(...)
				for thisHookName, hookFunction in pairs(Hooks_NRT_NE[hook]) do
					local success, v1 = pcall(hookFunction, ...)
					if not success then print("\x82\[HookBundle]\x85 Error in hook \""..thisHookName.."\":\x80 "..v1) continue end
				end
			end)
		end

		if Hooks_NRT_NE[hook][hookName] ~= nil then
			if not MaliceHooksAllowChanges then
				error("Hook name \""..hookName.."\" already exists in \""..hook.."\".")
			else
				Hooks_NRT_NE[hook][hookName] = hookFunction
				print("\x82\[HookBundle] Overrided hook \""..hookName.."\" on \""..hook.."\".")
			end

			return
		end

		Hooks_NRT_NE[hook][hookName] = hookFunction
		print("\x82\[HookBundle] Added hook \""..hookName.."\" to \""..hook.."\".")

	--> Return type. No extra.
	elseif Hooks_RT_NE[hook] ~= nil then
		if Hooks_RT_NE[hook] == false then
			print("\x82\[HookBundle] Initializing hook bundle \""..hook.."\"...")
			Hooks_RT_NE[hook] = {}

			addHook(hook, function(...)
				-- look, i know it's weird, and it's probably wrong too. im just avoiding creating a table like the plague cuz i know for a *fact* that is inefficient.
				local r1, r2, r3, r4, r5, r6

				for thisHookName, hookFunction in pairs(Hooks_RT_NE[hook]) do
					local success, v1, v2, v3, v4, v5, v6 = pcall(hookFunction, ...)
					if not success then print("\x82\[HookBundle]\x85 Error in hook \""..thisHookName.."\":\x80 "..v1) continue end
					
					if v1 ~= nil then r1 = v1; r2 = v2; r3 = v3; r4 = v4; r5 = v5; r6 = v6 end
				end

				return r1, r2, r3, r4, r5, r6
			end)
		end

		if Hooks_RT_NE[hook][hookName] ~= nil then
			if not MaliceHooksAllowChanges then
				error("Hook name \""..hookName.."\" already exists in \""..hook.."\".")
			else
				Hooks_RT_NE[hook][hookName] = hookFunction
				print("\x82\[HookBundle] Overrided hook \""..hookName.."\" on \""..hook.."\".")
			end

			return
		end

		Hooks_RT_NE[hook][hookName] = hookFunction
		print("\x82\[HookBundle] Added hook \""..hookName.."\" to \""..hook.."\".")

	--> No return type. Extra.
	elseif Hooks_NRT_E[hook] ~= nil then
		if type(extra) ~= (ExtraTypes[hook] or "number") then error("Extra type for \""..hook.."\" must be a "..(ExtraTypes[hook] or "number")..".") return end

		if not Hooks_NRT_E[hook][extra] then
			print("\x82\[HookBundle] Initializing hook bundle \""..hook.."\" ["..extra.."]...")
			Hooks_NRT_E[hook][extra] = {}
			addHook(hook, function(...)
				for thisHookName, hookFunction in pairs(Hooks_NRT_E[hook][extra]) do
					local success, v1 = pcall(hookFunction, ...)
					if not success then print("\x82\[HookBundle]\x85 Error in hook \""..thisHookName.."\":\x80 "..v1) continue end
				end
			end, extra)
		end

		if Hooks_NRT_E[hook][extra][hookName] ~= nil then
			if not MaliceHooksAllowChanges then
				error("Hook name \""..hookName.."\" already exists in \""..hook.."\". ["..extra.."]")
			else
				Hooks_NRT_E[hook][extra][hookName] = hookFunction
				print("\x82\[HookBundle] Overrided hook \""..hookName.."\" on \""..hook.."\". ["..extra.."]")
			end

			return
		end

		Hooks_NRT_E[hook][extra][hookName] = hookFunction
		print("\x82\[HookBundle] Added hook \""..hookName.."\" to \""..hook.."\". ["..extra.."]")

	--> Return type. Extra.
	elseif Hooks_RT_E[hook] ~= nil then
		if type(extra) ~= (ExtraTypes[hook] or "number") then error("Extra type for \""..hook.."\" must be a "..(ExtraTypes[hook] or "number")..".") return end

		if not Hooks_RT_E[hook][extra] then
			print("\x82\[HookBundle] Initializing hook bundle \""..hook.."\" ["..extra.."]...")
			Hooks_RT_E[hook][extra] = {}
			addHook(hook, function(...)
				local r1, r2, r3, r4, r5, r6, r7, r8

				for thisHookName, hookFunction in pairs(Hooks_RT_E[hook][extra]) do
					local success, v1, v2, v3, v4, v5, v6, r7, r8 = pcall(hookFunction, ...)
					if not success then print("\x82\[HookBundle]\x85 Error in hook \""..thisHookName.."\":\x80 "..v1) continue end
					
					if v1 ~= nil then r1 = v1; r2 = v2; r3 = v3; r4 = v4; r5 = v5; r6 = v6; r7 = v7; r8 = v8 end
				end

				return r1, r2, r3, r4, r5, r6, r7, r8
			end, extra)
		end

		if Hooks_RT_E[hook][extra][hookName] ~= nil then
			if not MaliceHooksAllowChanges then
				error("Hook name \""..hookName.."\" already exists in \""..hook.."\". ["..extra.."]")
			else
				Hooks_RT_E[hook][extra][hookName] = hookFunction
				print("\x82\[HookBundle] Overrided hook \""..hookName.."\" on \""..hook.."\". ["..extra.."]")
			end

			return
		end

		Hooks_RT_E[hook][extra][hookName] = hookFunction
		print("\x82\[HookBundle] Added hook \""..hookName.."\" to \""..hook.."\". ["..extra.."]")
		
	--> Special Cases
	elseif hook == "PrePlayerThink" then
		if Hooks_SPEC[hook] == false then
			print("\x82\[HookBundle] Initializing hook bundle \""..hook.."\"...")
			Hooks_SPEC[hook] = {}

			addHook("PreThinkFrame", function()
				for p in players.iterate do
					for thisHookName, hookFunction in pairs(Hooks_SPEC[hook]) do
						local success, v1 = {pcall(hookFunction, p)}
						if not success then print("\x82\[HookBundle]\x85 Error in hook \""..thisHookName.."\":\x80 "..v1) continue end
					end
				end
			end)
		end
		
		if Hooks_SPEC[hook][hookName] ~= nil then
			if not MaliceHooksAllowChanges then
				error("Hook name \""..hookName.."\" already exists in \""..hook.."\".")
			else
				Hooks_SPEC[hook][hookName] = hookFunction
				print("\x82\[HookBundle] Overrided hook \""..hookName.."\" on \""..hook.."\".")
			end

			return
		end

		Hooks_SPEC[hook][hookName] = hookFunction
		print("\x82\[HookBundle] Added hook \""..hookName.."\" to \""..hook.."\".")
		
	elseif hook == "PostPlayerThink" then
		if Hooks_SPEC[hook] == false then
			print("\x82\[HookBundle] Initializing hook bundle \""..hook.."\"...")
			Hooks_SPEC[hook] = {}

			addHook("PostThinkFrame", function()
				for p in players.iterate do
					for thisHookName, hookFunction in pairs(Hooks_SPEC[hook]) do
						local success, v1 = {pcall(hookFunction, p)}
						if not success then print("\x82\[HookBundle]\x85 Error in hook \""..thisHookName.."\":\x80 "..v1) continue end
					end
				end
			end)
		end
		
		if Hooks_SPEC[hook][hookName] ~= nil then
			if not MaliceHooksAllowChanges then
				error("Hook name \""..hookName.."\" already exists in \""..hook.."\".")
			else
				Hooks_SPEC[hook][hookName] = hookFunction
				print("\x82\[HookBundle] Overrided hook \""..hookName.."\" on \""..hook.."\".")
			end

			return
		end

		Hooks_SPEC[hook][hookName] = hookFunction
		print("\x82\[HookBundle] Added hook \""..hookName.."\" to \""..hook.."\".")
		
	else
		error("Invalid hook \""..hook.."\".")
	end
end

rawset(_G, "BundleHook", bundleHook)


--> Ideally: you do not use this, it's just here for the fun of the option, so it's not all too well thought out.
local function bundleUnhook(hook, hookName, extra)
	if not MaliceHooksAllowChanges then error("Hook changes are disabled.") return end
	if type(hook) ~= "string" then error("Hook type must be a string.") return end
	if type(hookName) ~= "string" then error("Hook name must be a string.") return end

	if Hooks_NRT_NE[hook] then
		if Hooks_NRT_NE[hook][hookName] ~= nil then
			Hooks_NRT_NE[hook][hookName] = nil
		end
	elseif Hooks_RT_NE[hook] then
		if Hooks_RT_NE[hook][hookName] ~= nil then
			Hooks_RT_NE[hook][hookName] = nil
		end
	elseif Hooks_NRT_E[hook] then
		if type(extra) ~= (ExtraTypes[hook] or "number") then error("Extra type for \""..hook.."\" must be a "..(ExtraTypes[hook] or "number")..".") return end

		if Hooks_NRT_E[hook][extra][hookName] ~= nil then
			Hooks_NRT_E[hook][extra][hookName] = nil
		end
	elseif Hooks_RT_E[hook] then
		if type(extra) ~= (ExtraTypes[hook] or "number") then error("Extra type for \""..hook.."\" must be a "..(ExtraTypes[hook] or "number")..".") return end

		if Hooks_RT_E[hook][extra][hookName] ~= nil then
			Hooks_RT_E[hook][extra][hookName] = nil
		end
	elseif Hooks_SPEC[hook] then
		if Hooks_SPEC[hook][hookName] ~= nil then
			Hooks_SPEC[hook][hookName] = nil
		end
	else
		error("Invalid hook \""..hook.."\".")
	end
end

rawset(_G, "BundleUnhook", bundleUnhook)
