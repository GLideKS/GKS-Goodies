--load all files
local directory = { "/",

    -- [[ Must load first]] --
    "Globals.lua",
    "Functions.lua",
    {"Libraries",
        "L_Lib-HookBundler-v2.lua",
        "Info_Fireworks.lua",
    },

    -- [[ Anything else ]] --

    {"Race", -- Race gamemode stuff
        {"Voices",
            "definitions.lua",
            "system.lua",
        },
        "Race Adjustments.lua",
        "Hurry Up.lua",
        "Race Start.lua",
    },

    {"Coop", -- Coop stuff
        "Ring sharing.lua",
    },

    {"Team Visuals", -- Team gamemodes stuff
        "Color Variants.lua",
        "Flag Capture Firework.lua",
        "Flag Hold.lua",
    },

    -- General
    "Round Control.lua",
    "tips.lua",
    "Status Bubbles.lua",
    "TimeLimit stuff.lua",
    "Windlines.lua",
    "Super Sparkles.lua",
    "Enhanced_FF.lua",
}

local function load(dir, path)
	for i, v in ipairs(dir) do
		if i == 1 then continue end

		if type(v) == "string" then
			dofile(path..v)
		elseif type(v) == "table" then
			load(v, path..v[1].."/")
		end
	end
end

load(directory, "")
