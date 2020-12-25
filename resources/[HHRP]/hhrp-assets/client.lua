HHCore = nil

Citizen.CreateThread(function()
	while HHCore == nil do
		TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    while true do
        local player = GetPlayerPed(-1)
        
        Citizen.Wait(5*1000) -- checks every 5 seconds (to limit resource usage)
        
        SetDiscordAppId(693700192540557363) -- client id (int)

        SetRichPresence( " Citizen is on " .. GetStreetNameFromHashKey(GetStreetNameAtCoord(table.unpack(GetEntityCoords(player))) )) -- main text (string)

        SetDiscordRichPresenceAsset("hhrp") -- large logo key (string)
        --SetDiscordRichPresenceAssetText(GetPlayerName(source)) -- Large logo "hover" text (string)

        SetDiscordRichPresenceAssetSmall("hhrp") -- small logo key (string)
        SetDiscordRichPresenceAssetSmallText("Health: "..(GetEntityHealth(player)-100)) -- small logo "hover" text (string)

    name = GetPlayerName(PlayerId())
    id = GetPlayerServerId(PlayerId())
	
    SetDiscordRichPresenceAssetText("ID: "..id.." | "..name.." ")
    
    Citizen.Wait(6000)

    end
end)

local reti = false

local HUD_ELEMENTS = {
    HUD = { id = 0, hidden = false },
    HUD_WANTED_STARS = { id = 1, hidden = true },
    HUD_WEAPON_ICON = { id = 2, hidden = false },
    HUD_CASH = { id = 3, hidden = true },
    HUD_MP_CASH = { id = 4, hidden = true },
    HUD_MP_MESSAGE = { id = 5, hidden = true },
    HUD_VEHICLE_NAME = { id = 6, hidden = true },
    HUD_AREA_NAME = { id = 7, hidden = true },
    HUD_VEHICLE_CLASS = { id = 8, hidden = true },
    HUD_STREET_NAME = { id = 9, hidden = true },
    HUD_HELP_TEXT = { id = 10, hidden = false },
    HUD_FLOATING_HELP_TEXT_1 = { id = 11, hidden = false },
    HUD_FLOATING_HELP_TEXT_2 = { id = 12, hidden = false },
    HUD_CASH_CHANGE = { id = 13, hidden = true },
    HUD_RETICLE = { id = 14, hidden = false },
    HUD_SUBTITLE_TEXT = { id = 15, hidden = false },
    HUD_RADIO_STATIONS = { id = 16, hidden = false },
    HUD_SAVING_GAME = { id = 17, hidden = false },
    HUD_GAME_STREAM = { id = 18, hidden = false },
    HUD_WEAPON_WHEEL = { id = 19, hidden = false },
    HUD_WEAPON_WHEEL_STATS = { id = 20, hidden = false },
    MAX_HUD_COMPONENTS = { id = 21, hidden = false },
    MAX_HUD_WEAPONS = { id = 22, hidden = false },
    MAX_SCRIPTED_HUD_COMPONENTS = { id = 141, hidden = false }
}
-- Parameter for hiding radar when not in a vehicle
local playerp = PlayerPedId()
RegisterCommand("crosshair", function()
    reti = not reti
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if reti then
            ShowHudComponentThisFrame(14)
        else
            HideHudComponentThisFrame(14)
        end
    end
end)

local HUD_HIDE_RADAR_ON_FOOT = true

-- Main thread
Citizen.CreateThread(function()
    -- Loop forever and update HUD every frame
    while true do
        Citizen.Wait(0)
        -- If enabled only show radar when in a vehicle (use a zoomed out view)
        if HUD_HIDE_RADAR_ON_FOOT then
            local player = GetPlayerPed(-1)
            DisplayRadar(IsPedInAnyVehicle(player, false))
        end
        -- Hide other HUD components
        for key, val in pairs(HUD_ELEMENTS) do
            if val.hidden then
                HideHudComponentThisFrame(val.id)
            else
                if val.id == 14 then
                    --ShowHudComponentThisFrame(14)
                else
                    ShowHudComponentThisFrame(val.id)
                end
            end
        end
    end
end)

local INPUT_AIM = 0
local INPUT_AIM = 0
local UseFPS = false
local justpressed = 0

-- this prevents certain camera modes
local disable = 0
Citizen.CreateThread( function()
    while true do    
        Citizen.Wait(1)

        if IsControlPressed(0, INPUT_AIM) then
            justpressed = justpressed + 1
        end

        if IsControlJustReleased(0, INPUT_AIM) then
        	if justpressed < 15 then
        		UseFPS = true
        	end
        	justpressed = 0
        end

        if GetFollowPedCamViewMode() == 1 or GetFollowVehicleCamViewMode() == 1 then
        	Citizen.Wait(1)
        	SetFollowPedCamViewMode(0)
        	SetFollowVehicleCamViewMode(0)
        end

        if UseFPS then
        	if GetFollowPedCamViewMode() == 0 or GetFollowVehicleCamViewMode() == 0 then
        		Citizen.Wait(1)
        		
        		SetFollowPedCamViewMode(4)
        		SetFollowVehicleCamViewMode(4)
        	else
        		Citizen.Wait(1)
        		
        		SetFollowPedCamViewMode(0)
        		SetFollowVehicleCamViewMode(0)
        	end
    		UseFPS = false
        end

        if IsPedArmed(ped,1) or not IsPedArmed(ped,7) then
            if IsControlJustPressed(0,24) or IsControlJustPressed(0,141) or IsControlJustPressed(0,142) or IsControlJustPressed(0,140)  then
                disable = 50
            end
        end

        if disable > 0 then
            disable = disable - 1
            DisableControlAction(0,24)
            DisableControlAction(0,140)
            DisableControlAction(0,141)
            DisableControlAction(0,142)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if IsPedArmed(PlayerPedId(), 6) then
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
        else
            Citizen.Wait(1500)
        end
    end
end)

--- TACKLE ---
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
        if IsPedRunning(PlayerPedId()) and IsControlJustReleased(0, 51) then
            TryTackle()
        end
    end
end)

TimerEnabled = false

function TryTackle()
    if not TimerEnabled then
        --print("attempting a tackle.")
        t, distance = GetClosestPlayer()
        if(distance ~= -1 and distance < 1.5) then
            local maxheading = (GetEntityHeading(GetPlayerPed(-1)) + 15.0)
            local minheading = (GetEntityHeading(GetPlayerPed(-1)) - 15.0)
            local theading = (GetEntityHeading(t))

            TriggerServerEvent('CrashTackle',GetPlayerServerId(t))
            TriggerEvent("animation:tacklelol") 

            TimerEnabled = true
            Citizen.Wait(4500)
            TimerEnabled = false
        else
            TimerEnabled = true
            Citizen.Wait(1000)
            TimerEnabled = false
        end
    end
end

RegisterNetEvent('playerTackled')
AddEventHandler('playerTackled', function()
    SetPedToRagdoll(GetPlayerPed(-1), math.random(8500), math.random(8500), 0, 0, 0, 0) 

    TimerEnabled = true
    Citizen.Wait(1500)
    TimerEnabled = false
end)

RegisterNetEvent('animation:tacklelol')
AddEventHandler('animation:tacklelol', function()

    if not handCuffed and not IsPedRagdoll(GetPlayerPed(-1)) then

        local lPed = GetPlayerPed(-1)

        RequestAnimDict("swimming@first_person@diving")
        while not HasAnimDictLoaded("swimming@first_person@diving") do
            Citizen.Wait(1)
        end
            
        if IsEntityPlayingAnim(lPed, "swimming@first_person@diving", "dive_run_fwd_-45_loop", 3) then
            ClearPedSecondaryTask(lPed)
        else
            TaskPlayAnim(lPed, "swimming@first_person@diving", "dive_run_fwd_-45_loop", 8.0, -8, -1, 49, 0, 0, 0, 0)
            seccount = 3
            while seccount > 0 do
                Citizen.Wait(100)
                seccount = seccount - 1
            end
            ClearPedSecondaryTask(lPed)
            SetPedToRagdoll(GetPlayerPed(-1), 150, 150, 0, 0, 0, 0) 
        end        
    end
end)

function GetClosestPlayer()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local closestPed = -1
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)
	if not IsPedInAnyVehicle(PlayerPedId(), false) then

		for index,value in ipairs(players) do
			local target = GetPlayerPed(value)
			if(target ~= ply) then
				local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
				local distance = #(vector3(targetCoords["x"], targetCoords["y"], targetCoords["z"]) - vector3(plyCoords["x"], plyCoords["y"], plyCoords["z"]))
				if(closestDistance == -1 or closestDistance > distance) and not IsPedInAnyVehicle(target, false) then
					closestPlayer = value
					closestPed = target
					closestDistance = distance
				end
			end
		end
		
		return closestPlayer, closestDistance, closestPed

	else
		TriggerEvent("DoShortHudText","Inside Vehicle.",2)
	end
end

function GetPlayers()
    local players = {}

    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            players[#players+1]= i
        end
    end

    return players
end
--- POINT ---

local mp_pointing = false
local keyPressed = false

local function startPointing()
    local ped = GetPlayerPed(-1)
    RequestAnimDict("anim@mp_point")
    while not HasAnimDictLoaded("anim@mp_point") do
        Wait(0)
    end
    SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
    SetPedConfigFlag(ped, 36, 1)
    Citizen.InvokeNative(0x2D537BA194896636, ped, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
    RemoveAnimDict("anim@mp_point")
end

local function stopPointing()
    local ped = GetPlayerPed(-1)
    Citizen.InvokeNative(0xD01015C7316AE176, ped, "Stop")
    if not IsPedInjured(ped) then
        ClearPedSecondaryTask(ped)
    end
    if not IsPedInAnyVehicle(ped, 1) then
        SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
    end
    SetPedConfigFlag(ped, 36, 0)
    ClearPedSecondaryTask(PlayerPedId())
end

local once = true
local oldval = false
local oldvalped = false

Citizen.CreateThread(function()
    while true do
        Wait(0)

        if once then
            once = false
        end

        if not keyPressed then
            if IsControlPressed(0, 29) and not mp_pointing and IsPedOnFoot(PlayerPedId()) then
                Wait(200)
                if not IsControlPressed(0, 29) then
                    keyPressed = true
                    startPointing()
                    mp_pointing = true
                else
                    keyPressed = true
                    while IsControlPressed(0, 29) do
                        Wait(50)
                    end
                end
            elseif (IsControlPressed(0, 29) and mp_pointing) or (not IsPedOnFoot(PlayerPedId()) and mp_pointing) then
                keyPressed = true
                mp_pointing = false
                stopPointing()
            end
        end

        if keyPressed then
            if not IsControlPressed(0, 29) then
                keyPressed = false
            end
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) and not mp_pointing then
            stopPointing()
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) then
            if not IsPedOnFoot(PlayerPedId()) then
                stopPointing()
            else
                local ped = GetPlayerPed(-1)
                local camPitch = GetGameplayCamRelativePitch()
                if camPitch < -70.0 then
                    camPitch = -70.0
                elseif camPitch > 42.0 then
                    camPitch = 42.0
                end
                camPitch = (camPitch + 70.0) / 112.0

                local camHeading = GetGameplayCamRelativeHeading()
                local cosCamHeading = Cos(camHeading)
                local sinCamHeading = Sin(camHeading)
                if camHeading < -180.0 then
                    camHeading = -180.0
                elseif camHeading > 180.0 then
                    camHeading = 180.0
                end
                camHeading = (camHeading + 180.0) / 360.0

                local blocked = 0
                local nn = 0
                local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
                local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7);
                nn,blocked,coords,coords = GetRaycastResult(ray)

                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Pitch", camPitch)
                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Heading", camHeading * -1.0 + 1.0)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isBlocked", blocked)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isFirstPerson", Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)
            end
        end
    end
end)

--Dice
RegisterCommand('roll', function(source, args, rawCommand)
    -- Interpret the number of sides
    local die = 6
    if args[1] ~= nil and tonumber(args[1]) then
        die = tonumber(args[1])
    end
    -- Interpret the number of rolls
    rolls = 1
    if args[2] ~= nil and tonumber(args[2]) then
        rolls = tonumber(args[2])
    end
    -- Roll and add up rolls
    local number = 0
    for i = rolls,1,-1
    do
        number = number + math.random(1,die)
    end

    loadAnimDict("anim@mp_player_intcelebrationmale@wank")
    TaskPlayAnim(GetPlayerPed(-1), "anim@mp_player_intcelebrationmale@wank", "wank", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
    Citizen.Wait(1500)
    ClearPedTasks(GetPlayerPed(-1))
    TriggerServerEvent('3dme:shareDisplay', 'Rolled a d' .. die .. ' ' .. rolls .. ' time(s): ' .. number)
end)

function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict( dict )
        Citizen.Wait(5)
    end
end

--Citizen Card

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/pnum', "Shows phone number to nearby players")
end)


--TPM

RegisterCommand("tpm", function(source)
    TeleportToWaypoint()
end)

Citizen.CreateThread(function()
    while true do
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 0.1)
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_FLASHLIGHT"), 0.2)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_BAT"), 0.3)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_PISTOL"), 0.2)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_COMBATPISTOL"), 0.2)
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_WRENCH"), 0.3)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_NIGHTSTICK"), 0.2)
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_POOLCUE"), 0.2)
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_SMG"), 0.6)
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_PISTOL_MK2"), 0.4)
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_HEAVYPISTOL"), 0.4)
	N_0x4757f00bc6323cfe(GetHashKey("WEAPON_APPISTOL"), 0.3)
    N_0x4757f00bc6323cfe(GetHashKey("WEAPON_CARBINERIFLE"), 0.6)
	Wait(0)
    end
end)

local function DisableHeadshots()
    SetPedSuffersCriticalHits(PlayerPedId(), false)
end

function TeleportToWaypoint()
    HHCore.TriggerServerCallback("tpm:fetchUserRank", function(playerRank)
        if playerRank == "admin" or playerRank == "superadmin" or playerRank == "mod" then
            local WaypointHandle = GetFirstBlipInfoId(8)

            if DoesBlipExist(WaypointHandle) then
                local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)

                for height = 1, 1000 do
                    SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                    local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

                    if foundGround then
                        SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                        break
                    end

                    Citizen.Wait(5)
                end
                TriggerEvent('DoLongHudText', "Teleported", 1)
            else
                TriggerEvent('DoLongHudText', "Please place your waypoint", 1)
            end
        else
            TriggerEvent('DoLongHudText', "You do not have rights to do this", 2)
        end
    end)
end

--NONPCDROP
function SetWeaponDrops()
	local handle, ped = FindFirstPed()
	local finished = false

	repeat
		if not IsEntityDead(ped) then
			SetPedDropsWeaponsWhenDead(ped, false)
		end
		finished, ped = FindNextPed(handle)
	until not finished

	EndFindPed(handle)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		SetWeaponDrops()
	end
end)

--[[ SEAT SHUFFLE ]]--
local disableShuffle = true
function disableSeatShuffle(flag)
	disableShuffle = flag
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPedInAnyVehicle(GetPlayerPed(-1), false) and disableShuffle then
			if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) == GetPlayerPed(-1) then
				if GetIsTaskActive(GetPlayerPed(-1), 165) then
					SetPedIntoVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
				end
			end
		end
	end
end)

RegisterNetEvent("SeatShuffle")
AddEventHandler("SeatShuffle", function()
	if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
		disableSeatShuffle(false)
        TriggerEvent('DoLongHudText', "Seat switched", 1)
		Citizen.Wait(5000)
		disableSeatShuffle(true)
	else
        TriggerEvent('DoLongHudText', "Not in vehicle", 2)
		CancelEvent()
	end
end)

RegisterCommand("shuff", function(source, args, raw) --change command here
    TriggerEvent("SeatShuffle")
end, false) --False, allow everyone to run it

--Alcohol

function AttachPropAndPlayAnimation(dictionary,animation,typeAnim,timer,message,func,remove,itemid)
    if itemid == "hamburger" or itemid == "heartstopper" or itemid == "bleederburger" then
        TriggerEvent("attachItem", "hamburger")
    elseif itemid == "sandwich" then
        TriggerEvent("attachItem", "sandwich")
    elseif itemid == "donut" then
        TriggerEvent("attachItem", "donut")
    elseif itemid == "water" or itemid == "cola" or itemid == "vodka" or itemid == "whiskey" or itemid == "beer" or itemid == "coffee" then
        TriggerEvent("attachItem", itemid)
    elseif itemid == "fishtaco" or itemid == "taco" then
        TriggerEvent("attachItem", "taco")
    elseif itemid == "greencow" or itemid == 'whiteclaw' then
        TriggerEvent("attachItem", "energydrink")
    elseif itemid == "slushy" then
        TriggerEvent("attachItem", "cup")
    end
    TaskItem(dictionary, animation, typeAnim, timer, message, func, remove, itemid)
end

function TaskItem(dictionary,animation,typeAnim,timer,message,func,remove,itemid)
    loadAnimDict( dictionary ) 
    TaskPlayAnim( PlayerPedId(), dictionary, animation, 8.0, 1.0, -1, typeAnim, 0, 0, 0, 0 )
    exports["hhrp-taskbar"]:taskBar(timer, message)
        TriggerEvent("destroyProp")
        ClearPedTasks(PlayerPedId())

    if remove then
        TriggerEvent("inventory:removeItem",itemid, 1)
    end
end

RegisterNetEvent('alcohol:anim')
AddEventHandler('alcohol:anim', function(itemid)
    if itemid == 'vodka' then
        AttachPropAndPlayAnimation("amb@world_human_drinking@coffee@male@idle_a", "idle_c", 49,6000,"Drink","changethirst",true,itemid)
    elseif itemid == 'whiskey' then
        AttachPropAndPlayAnimation("amb@world_human_drinking@coffee@male@idle_a", "idle_c", 49,6000,"Drink","changethirst",true,itemid)
    elseif itemid == 'beer' then
        AttachPropAndPlayAnimation("amb@world_human_drinking@coffee@male@idle_a", "idle_c", 49,6000,"Drink","changethirst",true,itemid)
    elseif itemid == 'whiteclaw' then
        AttachPropAndPlayAnimation("amb@world_human_drinking@coffee@male@idle_a", "idle_c", 49,6000,"Drink","changethirst",true,itemid)
    end 
end)

Citizen.CreateThread(function()
	for i = 1, 15 do
		EnableDispatchService(i, false)
	end
end)

-- CLEAR PD AREA

Citizen.CreateThread(function()
    while (true) do
     Citizen.Wait(0)
        SetVehicleModelIsSuppressed(GetHashKey("rubble"), true)
        SetVehicleModelIsSuppressed(GetHashKey("blimp"), true)
        local playerPed = GetPlayerPed(-1)
        local playerLocalisation = GetEntityCoords(playerPed)
        ClearAreaOfCops(playerLocalisation.x, playerLocalisation.y, playerLocalisation.z, 1000.0)
    end
end)

Citizen.CreateThread(function()
    while (true) do
        ClearAreaOfPeds(440.84, -983.14, 30.69, 300, 1)
        Citizen.Wait(0)
    end
end)

--- ID Card Court House ---

Citizen.CreateThread(function()
while true do
local ped = PlayerPedId()
    Citizen.Wait(1)
        if GetDistanceBetweenCoords(GetEntityCoords(ped), 229.2356, -429.1252, 48.07677, true) < 25 then
            if GetDistanceBetweenCoords(GetEntityCoords(ped), 229.2356, -429.1252, 48.07677, true) < 1 then
                closestString = "[E] - $50 to create ID."
                DrawTxt(229.2356, -429.1252, 48.07677, closestString, 0.7)
                if IsControlJustReleased(1, 51) then
                    if HHCore.GetPlayerData().money >= 50 then
                        TriggerEvent("player:receiveItem",'idcard', 1)
                        TriggerServerEvent("removecash:checkmoney", 50)
                    else
                        TriggerEvent('DoLongHudText', 'Not enough money!', 2)
                    end
                end
            end
        end
    end
end)

function DrawTxt(x, y, z, text)
local onScreen,_x,_y=World3dToScreen2d(x, y, z)
local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)   
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 90)
end

--------------------------------------------------------------------------------------heli cameras---------------------------------------------------------------------------------
-- FiveM Heli Cam by davwheat and mraes
-- Version 2.0 05-11-2018 (DD-MM-YYYY)

-- config
local fov_max = 90.0
local fov_min = 7.5 -- max zoom level (smaller fov is more zoom)
local zoomspeed = 3.0 -- camera zoom speed
local speed_lr = 8.0 -- speed by which the camera pans left-right
local speed_ud = 8.0 -- speed by which the camera pans up-down
local toggle_helicam = 51 -- control id of the button by which to toggle the helicam mode. Default: INPUT_CONTEXT (E)
local toggle_vision = 25 -- control id to toggle vision mode. Default: INPUT_AIM (Right mouse btn)
local toggle_rappel = 154 -- control id to rappel out of the heli. Default: INPUT_DUCK (X)
local toggle_spotlight = 183 -- control id to toggle the front spotlight Default: INPUT_PhoneCameraGrid (G)
local toggle_lock_on = 22 -- control id to lock onto a vehicle with the camera. Default is INPUT_SPRINT (spacebar)
local showLSPDlogo = 0 -- 1 for ON, 0 for OFF
local minHeightAboveGround = 1.5 -- default: 1.5. Minimum height above ground to activate Heli Cam (in metres). Should be between 1 and 20.
local useMilesPerHour = 0 -- 0 is kmh; 1 is mph

-- Script starts here
local helicam = false
local polmav_hash = GetHashKey("polmav") -- change to another heli if you want :P
local fov = (fov_max + fov_min) * 0.5
local vision_state = 0 -- 0 is normal, 1 is night vision, 2 is thermal vision

Citizen.CreateThread(
	function()
		while true do
			Citizen.Wait(0)
			if IsPlayerInPolmav() then
				local lPed = GetPlayerPed(-1)
				local heli = GetVehiclePedIsIn(lPed)

				if IsHeliHighEnough(heli) then
					if IsControlJustPressed(0, toggle_helicam) then -- Toggle Helicam
						PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
						helicam = true
					end

					if IsControlJustPressed(0, toggle_rappel) then -- Initiate rappel
						Citizen.Trace("Attempting rapel from helicopter...")
						if GetPedInVehicleSeat(heli, 1) == lPed or GetPedInVehicleSeat(heli, 2) == lPed then
							PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
							TaskRappelFromHeli(lPed, 1)
						else
							SetNotificationTextEntry("STRING")
							AddTextComponentString("~r~Can't rappel from this seat")
							DrawNotification(false, false)
							PlaySoundFrontend(-1, "5_Second_Timer", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", false)
						end
					end
				end

				if IsControlJustPressed(0, toggle_spotlight) and GetPedInVehicleSeat(heli, -1) == lPed then
					spotlight_state = not spotlight_state
					TriggerServerEvent("heli:spotlight", spotlight_state)
					PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
				end
			end

			if helicam then
				SetTimecycleModifier("heliGunCam")
				SetTimecycleModifierStrength(0.3)
				local scaleform = RequestScaleformMovie("HELI_CAM")
				while not HasScaleformMovieLoaded(scaleform) do
					Citizen.Wait(0)
				end
				local lPed = GetPlayerPed(-1)
				local heli = GetVehiclePedIsIn(lPed)
				local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
				AttachCamToEntity(cam, heli, 0.0, 0.0, -1.5, true)
				SetCamRot(cam, 0.0, 0.0, GetEntityHeading(heli))
				SetCamFov(cam, fov)
				RenderScriptCams(true, false, 0, 1, 0)
				PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
				PushScaleformMovieFunctionParameterInt(showLSPDlogo) -- 0 for nothing, 1 for LSPD logo
				PopScaleformMovieFunctionVoid()
				local locked_on_vehicle = nil
				while helicam and not IsEntityDead(lPed) and (GetVehiclePedIsIn(lPed) == heli) and IsHeliHighEnough(heli) do
					if IsControlJustPressed(0, toggle_helicam) then -- Toggle Helicam
						PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
						helicam = false
					end
					if IsControlJustPressed(0, toggle_vision) then
						PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
						ChangeVision()
					end

					if locked_on_vehicle then
						if DoesEntityExist(locked_on_vehicle) then
							PointCamAtEntity(cam, locked_on_vehicle, 0.0, 0.0, 0.0, true)
							RenderVehicleInfo(locked_on_vehicle)
							if IsControlJustPressed(0, toggle_lock_on) then
								PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
								locked_on_vehicle = nil
								local rot = GetCamRot(cam, 2) -- All this because I can't seem to get the camera unlocked from the entity
								local fov = GetCamFov(cam)
								local old
								cam = cam
								DestroyCam(old_cam, false)
								cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
								AttachCamToEntity(cam, heli, 0.0, 0.0, -1.5, true)
								SetCamRot(cam, rot, 2)
								SetCamFov(cam, fov)
								RenderScriptCams(true, false, 0, 1, 0)
							end
						else
							locked_on_vehicle = nil -- Cam will auto unlock when entity doesn't exist anyway
						end
					else
						local zoomvalue = (1.0 / (fov_max - fov_min)) * (fov - fov_min)
						CheckInputRotation(cam, zoomvalue)
						local vehicle_detected = GetVehicleInView(cam)
						if DoesEntityExist(vehicle_detected) then
							RenderVehicleInfo(vehicle_detected)
							if IsControlJustPressed(0, toggle_lock_on) then
								PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
								locked_on_vehicle = vehicle_detected
							end
						end
					end
					HandleZoom(cam)
					HideHUDThisFrame()
					PushScaleformMovieFunction(scaleform, "SET_ALT_FOV_HEADING")
					PushScaleformMovieFunctionParameterFloat(GetEntityCoords(heli).z)
					PushScaleformMovieFunctionParameterFloat(zoomvalue)
					PushScaleformMovieFunctionParameterFloat(GetCamRot(cam, 2).z)
					PopScaleformMovieFunctionVoid()
					DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
					Citizen.Wait(0)
				end
				helicam = false
				ClearTimecycleModifier()
				fov = (fov_max + fov_min) * 0.5 -- reset to starting zoom level
				RenderScriptCams(false, false, 0, 1, 0) -- Return to gameplay camera
				SetScaleformMovieAsNoLongerNeeded(scaleform) -- Cleanly release the scaleform
				DestroyCam(cam, false)
				SetNightvision(false)
				SetSeethrough(false)
			end
		end
	end
)

RegisterNetEvent("heli:spotlight")
AddEventHandler(
	"heli:spotlight",
	function(serverID, state)
		local heli = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(serverID)), false)
		SetVehicleSearchlight(heli, state, false)
		Citizen.Trace("Set heli light state to " .. tostring(state) .. " for serverID: " .. serverID)
	end
)


Config = {} 
Config.DamageNeeded = 100.0 -- 100.0 being broken and 1000.0 being fixed a lower value than 100.0 will break it
Config.MaxWidth = 5.0 -- Will complete soon
Config.MaxHeight = 5.0
Config.MaxLength = 5.0

local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local First = vector3(0.0, 0.0, 0.0)
local Second = vector3(5.0, 5.0, 5.0)

local Vehicle = {Coords = nil, Vehicle = nil, Dimension = nil, IsInFront = false, Distance = nil}
Citizen.CreateThread(function()
    Citizen.Wait(200)
    while true do
        local ped = PlayerPedId()
        local closestVehicle, Distance = HHCore.Game.GetClosestVehicle()
        local vehicleCoords = GetEntityCoords(closestVehicle)
        local dimension = GetModelDimensions(GetEntityModel(closestVehicle), First, Second)
        if Distance < 6.0  and not IsPedInAnyVehicle(ped, false) then
            Vehicle.Coords = vehicleCoords
            Vehicle.Dimensions = dimension
            Vehicle.Vehicle = closestVehicle
            Vehicle.Distance = Distance
            if GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle), GetEntityCoords(ped), true) > GetDistanceBetweenCoords(GetEntityCoords(closestVehicle) + GetEntityForwardVector(closestVehicle) * -1, GetEntityCoords(ped), true) then
                Vehicle.IsInFront = false
            else
                Vehicle.IsInFront = true
            end
        else
            Vehicle = {Coords = nil, Vehicle = nil, Dimensions = nil, IsInFront = false, Distance = nil}
        end
        Citizen.Wait(500)
    end
end)


Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(5)
        local ped = PlayerPedId()
        if Vehicle.Vehicle ~= nil then
 
                if IsVehicleSeatFree(Vehicle.Vehicle, -1) and GetVehicleEngineHealth(Vehicle.Vehicle) <= Config.DamageNeeded then
                    HHCore.Game.Utils.DrawText3D({x = Vehicle.Coords.x, y = Vehicle.Coords.y, z = Vehicle.Coords.z}, 'Press [~g~SHIFT~w~] and [~g~E~w~] to push the vehicle', 0.4)
                end
     

            if IsControlPressed(0, Keys["LEFTSHIFT"]) and IsVehicleSeatFree(Vehicle.Vehicle, -1) and not IsEntityAttachedToEntity(ped, Vehicle.Vehicle) and IsControlJustPressed(0, Keys["E"])  and GetVehicleEngineHealth(Vehicle.Vehicle) <= Config.DamageNeeded then
                NetworkRequestControlOfEntity(Vehicle.Vehicle)
                local coords = GetEntityCoords(ped)
                if Vehicle.IsInFront then    
                    AttachEntityToEntity(PlayerPedId(), Vehicle.Vehicle, GetPedBoneIndex(6286), 0.0, Vehicle.Dimensions.y * -1 + 0.1 , Vehicle.Dimensions.z + 1.0, 0.0, 0.0, 180.0, 0.0, false, false, true, false, true)
                else
                    AttachEntityToEntity(PlayerPedId(), Vehicle.Vehicle, GetPedBoneIndex(6286), 0.0, Vehicle.Dimensions.y - 0.3, Vehicle.Dimensions.z  + 1.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, true)
                end

                HHCore.Streaming.RequestAnimDict('missfinale_c2ig_11')
                TaskPlayAnim(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0, -8.0, -1, 35, 0, 0, 0, 0)
                Citizen.Wait(200)

                local currentVehicle = Vehicle.Vehicle
                 while true do
                    Citizen.Wait(5)
                    if IsDisabledControlPressed(0, Keys["A"]) then
                        TaskVehicleTempAction(PlayerPedId(), currentVehicle, 11, 1000)
                    end

                    if IsDisabledControlPressed(0, Keys["D"]) then
                        TaskVehicleTempAction(PlayerPedId(), currentVehicle, 10, 1000)
                    end

                    if Vehicle.IsInFront then
                        SetVehicleForwardSpeed(currentVehicle, -1.0)
                    else
                        SetVehicleForwardSpeed(currentVehicle, 1.0)
                    end

                    if HasEntityCollidedWithAnything(currentVehicle) then
                        SetVehicleOnGroundProperly(currentVehicle)
                    end

                    if not IsDisabledControlPressed(0, Keys["E"]) then
                        DetachEntity(ped, false, false)
                        StopAnimTask(ped, 'missfinale_c2ig_11', 'pushcar_offcliff_m', 2.0)
                        FreezeEntityPosition(ped, false)
                        break
                    end
                end
            end
        end
    end
end)

function IsPlayerInPolmav()
	local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
	return IsVehicleModel(vehicle, polmav_hash)
end

function IsHeliHighEnough(heli)
	return GetEntityHeightAboveGround(heli) > minHeightAboveGround
end

function ChangeVision()
	if vision_state == 0 then
		SetNightvision(true)
		vision_state = 1
	elseif vision_state == 1 then
		SetNightvision(false)
		SetSeethrough(true)
		vision_state = 2
	else
		SetSeethrough(false)
		vision_state = 0
	end
end

function HideHUDThisFrame()
	HideHelpTextThisFrame()
	HideHudAndRadarThisFrame()
	HideHudComponentThisFrame(19) -- weapon wheel
	HideHudComponentThisFrame(1) -- Wanted Stars
	HideHudComponentThisFrame(2) -- Weapon icon
	HideHudComponentThisFrame(3) -- Cash
	HideHudComponentThisFrame(4) -- MP CASH
	HideHudComponentThisFrame(13) -- Cash Change
	HideHudComponentThisFrame(11) -- Floating Help Text
	HideHudComponentThisFrame(12) -- more floating help text
	HideHudComponentThisFrame(15) -- Subtitle Text
	HideHudComponentThisFrame(18) -- Game Stream
end

function CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX * -1.0 * (speed_ud) * (zoomvalue + 0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY * -1.0 * (speed_lr) * (zoomvalue + 0.1)), -89.5) -- Clamping at top (cant see top of heli) and at bottom (doesn't glitch out in -90deg)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

function HandleZoom(cam)
	if IsControlJustPressed(0, 241) then -- Scrollup
		fov = math.max(fov - zoomspeed, fov_min)
	end
	if IsControlJustPressed(0, 242) then
		fov = math.min(fov + zoomspeed, fov_max) -- ScrollDown
	end
	local current_fov = GetCamFov(cam)
	if math.abs(fov - current_fov) < 0.1 then -- the difference is too small, just set the value directly to avoid unneeded updates to FOV of order 10^-5
		fov = current_fov
	end
	SetCamFov(cam, current_fov + (fov - current_fov) * 0.05) -- Smoothing of camera zoom
end

function GetVehicleInView(cam)
	local coords = GetCamCoord(cam)
	local forward_vector = RotAnglesToVec(GetCamRot(cam, 2))
	--DrawLine(coords, coords+(forward_vector*100.0), 255,0,0,255) -- debug line to show LOS of cam
	local rayhandle =
		CastRayPointToPoint(coords, coords + (forward_vector * 200.0), 10, GetVehiclePedIsIn(GetPlayerPed(-1)), 0)
	local _, _, _, _, entityHit = GetRaycastResult(rayhandle)
	if entityHit > 0 and IsEntityAVehicle(entityHit) then
		return entityHit
	else
		return nil
	end
end

function RenderVehicleInfo(vehicle)
	local model = GetEntityModel(vehicle)
	local vehname = GetLabelText(GetDisplayNameFromVehicleModel(model))
	local licenseplate = GetVehicleNumberPlateText(vehicle)
	local numberOfPassengers = GetVehicleNumberOfPassengers(vehicle)
	local isDriverSeatOccupied = IsVehicleSeatFree(vehicle, -1)
	local vehicleSpeed = GetEntitySpeed(vehicle)

	local spdUnits = ""

	if useMilesPerHour then
		vehicleSpeed = vehicleSpeed * 2.236936 -- mph
		spdUnits = "mph"
	else
		vehicleSpeed = vehicleSpeed * 3.6 -- kmh
		spdUnits = "km/h"
	end

	if isDriverSeatOccupied then
		numberOfPassengers = numberOfPassengers + 1
	end

	SetTextFont(0)
	SetTextProportional(1)
	SetTextScale(0.0, 0.55)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(
		"Vehicle: " .. vehname .. "        Plate: " .. licenseplate .. "\nSpeed: " .. math.ceil(vehicleSpeed) .. "        Total occupants: " .. numberOfPassengers
	)
	DrawText(0.45, 0.9)
end

function HandleSpotlight(cam)
if IsControlJustPressed(0, toggle_spotlight) then
PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
spotlight_state = not spotlight_state
end
if spotlight_state then
local rotation = GetCamRot(cam, 2)
local forward_vector = RotAnglesToVec(rotation)
local camcoords = GetCamCoord(cam)
DrawSpotLight(camcoords, forward_vector, 255, 255, 255, 300.0, 10.0, 0.0, 2.0, 1.0)
end
end

function RotAnglesToVec(rot) -- input vector3
	local z = math.rad(rot.z)
	local x = math.rad(rot.x)
	local num = math.abs(math.cos(x))
	return vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end
