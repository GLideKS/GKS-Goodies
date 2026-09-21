--load all files
local directory = { "/",

    -- [[ Must load first]] --
    "globals.lua",
    "functions.lua",
    {"Libraries",
        "fireworks.lua",
        "w2s.lua",
    },

    -- [[ Anything else ]] --

    {"Race", -- Race gamemode stuff
        {"Voices",
            "voices_definitions.lua",
            "voices_system.lua",
        },
        "race_adjustments.lua",
        "race_start.lua",
        "hurry_up.lua",
    },

    {"Coop", -- Coop stuff
        "ring_sharing.lua",
    },

    -- Visuals

    {"Visuals",
        {"Team Visuals", -- Team gamemodes stuff
            "color_variants.lua",
            "flag_capture_firework.lua",
            "flag_hold.lua",
        },
        "status_bubbles.lua",
        "windlines.lua",
        "ring_signpost.lua",
        "super_sparkles.lua",
        "ability_plus.lua",
        "pre22_token.lua",
        "shard_holding.lua",
        "nametags.lua",
    },

    -- Utilities

    {"Utilities",
        "tools.lua",
        "round_control.lua",
        "timelimit_tweaks.lua",
        "tips.lua",
        "enhanced_friendlyfire.lua",
    },
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
