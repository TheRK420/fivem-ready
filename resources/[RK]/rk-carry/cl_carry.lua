-- local carryingBackInProgress = false
-- local carryAnimNamePlaying = ""
-- local carryAnimDictPlaying = ""
-- local carryControlFlagPlaying = 0
RKCore = nil
local carryingBackInProgress = false
iamcarried = false
iamcarrying = false
local inside = false
local playerd = nil
carried = false

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

Citizen.CreateThread(function()
    while RKCore == nil do
        TriggerEvent('rk:getSharedObject', function(obj)
            RKCore = obj
        end)
        Citizen.Wait(0)
    end

    while RKCore.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    RKCore.PlayerData = RKCore.GetPlayerData()
end)

-- RegisterCommand("carry",function(source, args)
-- 	if not carryingBackInProgress then
-- 		local player = PlayerPedId()	
-- 		lib = 'missfinale_c2mcs_1'
-- 		anim1 = 'fin_c2_mcs_1_camman'
-- 		lib2 = 'nm'
-- 		anim2 = 'firemans_carry'
-- 		distans = 0.15
-- 		distans2 = 0.27
-- 		height = 0.63
-- 		spin = 0.0		
-- 		length = 100000
-- 		controlFlagMe = 49
-- 		controlFlagTarget = 33
-- 		animFlagTarget = 1
-- 		local closestPlayer = GetClosestPlayer(3)
-- 		target = GetPlayerServerId(closestPlayer)
-- 		if closestPlayer ~= -1 and closestPlayer ~= nil then
-- 			carryingBackInProgress = true
-- 			TriggerServerEvent('CarryPeople:sync', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget)
-- 		else
-- 			TriggerEvent("DoLongHudText","No one nearby to carry!",1)
-- 		end
-- 	else
-- 		carryingBackInProgress = false
-- 		ClearPedSecondaryTask(GetPlayerPed(-1))
-- 		DetachEntity(GetPlayerPed(-1), true, false)
-- 		local closestPlayer = GetClosestPlayer(3)
-- 		target = GetPlayerServerId(closestPlayer)
-- 		if target ~= 0 then 
-- 			TriggerServerEvent("CarryPeople:stop",target)
-- 		end
-- 	end
-- end,false)

-- RegisterNetEvent('CarryPeople:syncTarget')
-- AddEventHandler('CarryPeople:syncTarget', function(target, animationLib, animation2, distans, distans2, height, length,spin,controlFlag)
-- 	local playerPed = GetPlayerPed(-1)
-- 	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
-- 	carryingBackInProgress = true
-- 	RequestAnimDict(animationLib)

-- 	while not HasAnimDictLoaded(animationLib) do
-- 		Citizen.Wait(10)
-- 	end
-- 	if spin == nil then spin = 180.0 end
-- 	AttachEntityToEntity(GetPlayerPed(-1), targetPed, 0, distans2, distans, height, 0.5, 0.5, spin, false, false, false, false, 2, false)
-- 	if controlFlag == nil then controlFlag = 0 end
-- 	TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
-- 	carryAnimNamePlaying = animation2
-- 	carryAnimDictPlaying = animationLib
-- 	carryControlFlagPlaying = controlFlag
-- end)

-- RegisterNetEvent('CarryPeople:syncMe')
-- AddEventHandler('CarryPeople:syncMe', function(animationLib, animation,length,controlFlag,animFlag)
-- 	local playerPed = GetPlayerPed(-1)
-- 	RequestAnimDict(animationLib)

-- 	while not HasAnimDictLoaded(animationLib) do
-- 		Citizen.Wait(10)
-- 	end
-- 	Wait(500)
-- 	if controlFlag == nil then controlFlag = 0 end
-- 	TaskPlayAnim(playerPed, animationLib, animation, 8.0, -8.0, length, controlFlag, 0, false, false, false)
-- 	carryAnimNamePlaying = animation
-- 	carryAnimDictPlaying = animationLib
-- 	carryControlFlagPlaying = controlFlag
-- end)

-- RegisterNetEvent('CarryPeople:cl_stop')
-- AddEventHandler('CarryPeople:cl_stop', function()
-- 	carryingBackInProgress = false
-- 	ClearPedSecondaryTask(GetPlayerPed(-1))
-- 	DetachEntity(GetPlayerPed(-1), true, false)
-- end)

-- Citizen.CreateThread(function()
-- 	while true do
-- 		if carryingBackInProgress then 
-- 			while not IsEntityPlayingAnim(GetPlayerPed(-1), carryAnimDictPlaying, carryAnimNamePlaying, 3) do
-- 				TaskPlayAnim(GetPlayerPed(-1), carryAnimDictPlaying, carryAnimNamePlaying, 8.0, -8.0, 100000, carryControlFlagPlaying, 0, false, false, false)
-- 				Citizen.Wait(0)
-- 			end
-- 		end
-- 		Wait(0)
-- 	end
-- end)

-- function GetPlayers()
--     local players = {}

--     for i = 0, 255 do
--         if NetworkIsPlayerActive(i) then
--             table.insert(players, i)
--         end
--     end

--     return players
-- end

-- function GetClosestPlayer(radius)
--     local players = GetPlayers()
--     local closestDistance = -1
--     local closestPlayer = -1
--     local ply = GetPlayerPed(-1)
--     local plyCoords = GetEntityCoords(ply, 0)

--     for index,value in ipairs(players) do
--         local target = GetPlayerPed(value)
--         if(target ~= ply) then
--             local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
--             local distance = GetDistanceBetweenCoords(targetCoords['x'], targetCoords['y'], targetCoords['z'], plyCoords['x'], plyCoords['y'], plyCoords['z'], true)
--             if(closestDistance == -1 or closestDistance > distance) then
--                 closestPlayer = value
--                 closestDistance = distance
--             end
--         end
--     end
-- 	--print("closest player is dist: " .. tostring(closestDistance))
-- 	if closestDistance <= radius then
-- 		return closestPlayer
-- 	else
-- 		return nil
-- 	end
-- end

-- function drawNativeNotification(text)
--     SetTextComponentFormat('STRING')
--     AddTextComponentString(text)
--     DisplayHelpTextFromStringLabel(0, 0, 1, -1)
-- end

Citizen.CreateThread(function()
	while true do
		local sleep = 500
		if carryingBackInProgress  then
			sleep= 0
			DisableControlAction(0,24,true) -- disable attack
			DisableControlAction(0,25,true) -- disable aim
			DisableControlAction(0,47,true) -- disable weapon
			DisableControlAction(0,58,true) -- disable weapon
			DisableControlAction(0,263,true) -- disable melee
			DisableControlAction(0,264,true) -- disable melee
			DisableControlAction(0,257,true) -- disable melee
			DisableControlAction(0,140,true) -- disable melee
			DisableControlAction(0,141,true) -- disable melee
			DisableControlAction(0,142,true) -- disable melee
			DisableControlAction(0,143,true) -- disable melee
			DisableControlAction(0,32,true) -- move (w)
			DisableControlAction(0,34,true) -- move (a)
			DisableControlAction(0,33,true) -- move (s)
			DisableControlAction(0,35,true) -- move (d)
			DisableControlAction(0,48,true) -- move (d)
			EnableControlAction(0, Keys['T'], true)
			EnableControlAction(0, Keys['E'], true)
			EnableControlAction(0, 1, true)
			EnableControlAction(0, 2, true)			
			DisableControlAction(0, Keys['F1'], true) --NO PHONE
			DisableControlAction(0, Keys['F2'], true) -- NO INVENTORY
			DisableControlAction(0, Keys['F3'], true) -- NO MENUS
			DisableControlAction(0, Keys['F6'], true) -- NO MENUS
			DisableControlAction(0, Keys['F7'], true) -- NO MENUS
			DisableControlAction(0, Keys['F9'], true) -- NO MENUS
			DisableControlAction(0, Keys['X'], true) -- NO MENUS
			DisableControlAction(0, Keys['F'], true)		
		end
		Citizen.Wait(sleep)
	end
end)


Citizen.CreateThread(function()
	while true do
		local sleep = 500
		if carryingBackInProgress then
			sleep = 50
			
			local vehicled = VehicleInFront()
			if vehicled then
			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local trunk = GetEntityBoneIndexByName(vehicled, 'bumper_r')
			if trunk == -1 then
				trunk = GetEntityBoneIndexByName(vehicled, 'platelight')
				if trunk == -1 then
					if GetHashKey('ambulance') == GetEntityModel(vehicled) then 
						trunk = GetEntityBoneIndexByName(vehicled, 'door_dside_r')
					end
					if trunk == -1 then
						if GetVehicleClass(vehicled) ~= 8 then
							trunk = GetEntityBoneIndexByName(vehicled, 'exhaust')
						end
					end
					-- if trunk == -1 then
					-- 	trunk = 	 GetEntityBoneIndexByName(vehicled, 'boot')
					-- end
				end
			end
				if trunk ~= -1 then
					local coords = GetWorldPositionOfEntityBone(vehicled, trunk)
					local distance  = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true)	
					if  distance <= 2 and carryingBackInProgress and carried ~=nil then
						sleep = 2
						RKCore.Game.Utils.DrawText3D(coords, 'Press [~b~ALT~s~] to Put in Trunk',0.8) --Draw 3d text
						insidecar(carried,vehicled)
					end 
				end		
		end
	end
		Citizen.Wait(sleep)
	end
end)



RegisterCommand("carry",function(source, args)
	if GetEntityHealth(PlayerPedId()) > 105 and GetVehiclePedIsIn(PlayerPedId(),false)==0 then
		if not carryingBackInProgress then
			local player = PlayerPedId()	
			lib = 'missfinale_c2mcs_1'
			anim1 = 'fin_c2_mcs_1_camman'
			lib2 = 'nm'
			anim2 = 'firemans_carry'
			distans = 0.15
			distans2 = 0.27
			height = 0.63
			spin = 0.0		
			length = 100000
			controlFlagMe = 49
			controlFlagTarget = 33
			animFlagTarget = 1
			local closestPlayer = GetClosestPlayer(3)
			if closestPlayer ~= nil then
				target = GetPlayerServerId(closestPlayer)
				if GetVehiclePedIsIn(GetPlayerPed(closestPlayer),false)==0 or GetEntityHealth(GetPlayerPed(closestPlayer))<=105 then
					carryingBackInProgress = true
					ClearPedTasksImmediately(PlayerPedId())   
					ClearPedTasksImmediately(closestPlayer)   
					inside = false	
					TriggerServerEvent("cmg2_animations:stop",target)
					playerd = target
					TriggerServerEvent('cmg2_animations:sync', closestPlayer, lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget)
					carried = closestPlayer
				end
			end
		else
			carryingBackInProgress = false
			ClearPedSecondaryTask(GetPlayerPed(-1))
			DetachEntity(GetPlayerPed(-1), true, false)
			local closestPlayer = GetClosestPlayer(3)
			target = GetPlayerServerId(closestPlayer)
			ClearPedTasksImmediately(closestPlayer)   
			inside = false	
			TriggerServerEvent("cmg2_animations:stop",target)
		end
		
	end
end,false)



RegisterNetEvent('cmg2_animations:syncTarget')
AddEventHandler('cmg2_animations:syncTarget', function(target, animationLib, animation2, distans, distans2, height, length,spin,controlFlag)
	local playerPed = GetPlayerPed(-1)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	carryingBackInProgress = true
	isOnBed = false

	RequestAnimDict(animationLib)

	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end

	if spin == nil then spin = 180.0 end

	AttachEntityToEntity(GetPlayerPed(-1), targetPed, 0, distans2, distans, height, 0.5, 0.5, spin, false, false, false, false, 2, false)

	if controlFlag == nil then controlFlag = 0 end

	while carryingBackInProgress do
		if not IsEntityPlayingAnim(playerPed, animationLib, animation2, 3) then
			TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
		end
		Citizen.Wait(100)
	end
end)

RegisterNetEvent('cmg2_animations:syncMe')
AddEventHandler('cmg2_animations:syncMe', function(animationLib, animation,length,controlFlag,animFlag)
	local playerPed = GetPlayerPed(-1)
	RequestAnimDict(animationLib)
	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	Wait(500)
	if controlFlag == nil then controlFlag = 0 end
	while carryingBackInProgress do
		if not IsEntityPlayingAnim(playerPed, animationLib, animation, 3) then
			TaskPlayAnim(playerPed, animationLib, animation, 8.0, -8.0, length, controlFlag, 0, false, false, false)
		end
		Citizen.Wait(100)
	end
	Citizen.Wait(length)
end)

RegisterNetEvent('cmg2_animations:cl_stop')
AddEventHandler('cmg2_animations:cl_stop', function()
	carryingBackInProgress = false
	ClearPedTasksImmediately(GetPlayerPed(-1))
	DetachEntity(GetPlayerPed(-1), true, false)
	inside = false
end)

function GetPlayers()
    local players = {}
    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end
    return players
end

function GetClosestPlayer(radius)
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)

    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if(target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
            local distance = GetDistanceBetweenCoords(targetCoords['x'], targetCoords['y'], targetCoords['z'], plyCoords['x'], plyCoords['y'], plyCoords['z'], true)
            if(closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
	if closestDistance <= radius and closestDistance ~=-1 then
		return closestPlayer
	else
		return nil
	end
end


RegisterCommand("tout",function(source, args)
	if GetEntityHealth(PlayerPedId()) > 105 then
		if inside then
			DetachEntity(PlayerPedId(), true, true)
			ClearPedTasksImmediately(PlayerPedId())   
			inside = false
		end
	end
end)


function VehicleInFront()
    local pos = GetEntityCoords(PlayerPedId())
    local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 6.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
    local _, _, _, _, result = GetRaycastResult(rayHandle)
    return result
end
 

function insidecar(player,vehicles)		
	if IsDisabledControlPressed(0, 19) and GetVehiclePedIsIn(player, false) == 0 and DoesEntityExist(vehicles) and IsEntityAVehicle(vehicles) then
		ClearPedTasksImmediately(PlayerPedId())
		ClearPedTasksImmediately(player)
		DetachEntity(player, true, false)
		carryingBackInProgress = false
		-- target =
		TriggerServerEvent("cmg2_animations:stop", GetPlayerServerId(player))		
		TriggerServerEvent("spushin", GetPlayerServerId(player))
	end			
end

loadDict = function(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
end

RegisterNetEvent("pushin")
AddEventHandler("pushin", function(target)	
	local ped = GetPlayerPed(GetPlayerFromServerId(target))
	local pos = GetEntityCoords(ped,true)
	local vehicle, distance = ESX.Game.GetClosestVehicle(pos)
	SetVehicleDoorOpen(vehicle, 5, false, false)
	if not inside then
		AttachEntityToEntity(ped, vehicle, -1, 0.0, -2.2, 0.5, 0.0, 0.0, 0.0, false, false, false, false, 20, true)	
		if IsEntityAttached(ped) then
			loadDict('timetable@floyd@cryingonbed@base')
			inside = true		
			if not IsEntityPlayingAnim(ped, 'timetable@floyd@cryingonbed@base', 'base', 3) then
				TaskPlayAnim(ped, 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)
			end
			-- else
			-- 	inside = false
		end   
	-- elseif inside then
	-- 	DetachEntity(ped, true, true)
	-- 	ClearPedTasksImmediately(ped)   
	-- 	inside = false	
	end	
	Citizen.Wait(2000)
	SetVehicleDoorShut(vehicle, 5, false,false)
end)

Citizen.CreateThread(function()
	while true do 
		if inside then
			if not IsEntityPlayingAnim(ped, 'timetable@floyd@cryingonbed@base', 'base', 3) then
				TaskPlayAnim(ped, 'timetable@floyd@cryingonbed@base', 'base', 8.0, -8.0, -1, 1, 0, false, false, false)
			end												
		end
		Citizen.Wait(50)
	end
end)


function LoadAnim(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Citizen.Wait(1)
	end
end