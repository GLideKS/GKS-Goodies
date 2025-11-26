-- j2b2's Hurry Up!
--edited by GLide KS

--TODO: Refactor music

local victorysoundplayed = 0
local countdownstart = 0
local hurrymusic = "HURRY"..P_RandomRange(1,5)

local CV_Fractions = {
	["3/4"]=0,
	["1"]=1,
	["1/2"]=2,
	["1/3"]=3,
	["1/4"]=4,
	["2/3"]=5
}

local cvCountdown = CV_FindVar("countdowntime")
local cvHurryPlayers = CV_RegisterVar({name="hurry_players",defaultvalue="2/3",flags=CV_NETVAR | CV_SHOWMODIF,PossibleValue=CV_Fractions})
local cvHurryTimeLimit = CV_RegisterVar({name="hurry_timelimit",defaultvalue=0,flags=CV_NETVAR | CV_SHOWMODIF,PossibleValue=CV_Unsigned})

local comStartCountdown = COM_AddCommand("hurry_startcountdown",function(player,time)
	time = tonumber(time)
	if time == nil then
		countdownstart = leveltime
	else
		time = max(min(time,9999999),0)
		countdownstart = leveltime+time*TICRATE-cvCountdown.value*TICRATE
	end
	S_ChangeMusic(hurrymusic, true, player)
	mapmusname = hurrymusic
	S_StartSound(nil,43)
	P_SetupLevelSky(33)
	P_StartQuake(3*FRACUNIT, -1)
	for player in players.iterate do
		if not player.hurryplayedsound then
			player.hurryplayedsound = false
		end
		player.hurry_voice = true
	end
end,COM_ADMIN)

local function IsValid(a)
	if a ~= nil then return a.valid end
	return false
end

local function ShouldHurry()
	return multiplayer
end

addHook("NetVars",function(network)
	countdownstart = network(countdownstart)
end)

addHook("MapChange",function()
	countdownstart = 0
	hurrymusic = "HURRY"..P_RandomRange(1,5)
	victorysoundplayed = 0
end)

addHook("MapLoad",function()
	for player in players.iterate do
		player.hurryplayedsound = false
		player.hurry_voice = false
	end
end)

addHook("ThinkFrame",function()
	if ShouldHurry() then
		if countdownstart == 0 then
			if cvHurryTimeLimit.value ~= 0 and leveltime+cvCountdown.value*TICRATE >= cvHurryTimeLimit.value*TICRATE*60 then
				countdownstart = leveltime
				S_StartSound(nil,sfx_dwnind)
			else
				local totalCount = 0
				local finishedCount = 0
				for player in players.iterate() do
					if IsValid(player) then
						local lapcount = (CV_FindVar("numlaps").value) or (mapheaderinfo[gamemap].numlaps) or 4
						if player.laps >= lapcount or player.pflags & PF_FINISHED then
							finishedCount = finishedCount+1
						end
						if player.lives > 0 then
							totalCount = totalCount+1
						end
					end
				end
				local requiredForFinish
				if cvHurryPlayers.value == 0 then
					requiredForFinish = min(1,1)
				elseif cvHurryPlayers.value == 1 then
					requiredForFinish = 1
				elseif cvHurryPlayers.value == 5 then
					requiredForFinish = max(1,1)
				else
					requiredForFinish = max(1,1)
				end
				
				if finishedCount >= requiredForFinish and finishedCount ~= totalCount then
					S_ChangeMusic(hurrymusic, true, player)
					mapmusname = hurrymusic
					countdownstart = leveltime
					S_StartSound(nil,43)
					P_SetupLevelSky(33)
					P_StartQuake(3*FRACUNIT, -1)
					for player in players.iterate do
						if not player.hurryplayedsound then
							player.hurryplayedsound = false
						end
						player.hurry_voice = true
					end
			    end
			end
		end
	end
end)

local HUD_TEXT_Y = 168
local HUD_NUMBER_Y = HUD_TEXT_Y+10
local HUD_FLASH_TIME = TICRATE/2

hud.add(function(v,stplyr)
	local countdownEnd = countdownstart+cvCountdown.value*TICRATE
	if ShouldHurry() then
		if countdownstart ~= 0 and countdownEnd > leveltime and stplyr.exiting == 0 then
			local time = leveltime/HUD_FLASH_TIME
			local videoFlags = V_SNAPTOBOTTOM | V_PERPLAYER
			if time%2 then videoFlags = videoFlags | V_YELLOWMAP end
				v.drawString(160, HUD_TEXT_Y, "HURRY UP!", videoFlags, "center")
				
			end
		end
end,"game")

-- j2b2's Hurry Up!
