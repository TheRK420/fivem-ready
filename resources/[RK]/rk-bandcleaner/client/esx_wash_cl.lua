local GUI          			  = {}
local hasAlreadyEnteredMarker = false
local isInWASHMarker 		  = false
local menuIsShowed   		  = false

RKCore = nil

Citizen.CreateThread(function()
	while RKCore == nil do
		TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)
		Citizen.Wait(0)
	end
end)

-- Render markers
Citizen.CreateThread(function()
	while true do		
		Citizen.Wait(0)		
		local coords = GetEntityCoords(GetPlayerPed(-1))		
		for i=1, #Config.WASH, 1 do
			if(GetDistanceBetweenCoords(coords, Config.WASH[i].x, Config.WASH[i].y, Config.WASH[i].z, true) < Config.DrawDistance) then
				DrawMarker(Config.MarkerType, Config.WASH[i].x, Config.WASH[i].y, Config.WASH[i].z - Config.ZDiff, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1, 1, 1, 0, 100, 0, 100, false, true, 2, false, false, false, false)
			end
		end
	end
end)

-- Citizen.CreateThread(function()
--     RequestModel(GetHashKey("cs_lestercrest"))    
--     while not HasModelLoaded(GetHashKey("cs_lestercrest")) do
--         Wait(1)
-- 	end
-- 	for i=1, #Config.WASH, 1 do    
-- 		local npc = CreatePed(4, GetHashKey("cs_lestercrest"), Config.WASH[i].x, Config.WASH[i].y, Config.WASH[i].z - 0.90, 0, false, true)
-- 	end
-- 	SetEntityHeading(npc,  246.62)
--     FreezeEntityPosition(npc, true)
--     SetEntityInvincible(npc, true)
--     SetBlockingOfNonTemporaryEvents(npc, true)
-- end)

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do		
		Citizen.Wait(0)
		local coords = GetEntityCoords(GetPlayerPed(-1))
		isInWASHMarker = false
		for i=1, #Config.WASH, 1 do
			if(GetDistanceBetweenCoords(coords, Config.WASH[i].x, Config.WASH[i].y, Config.WASH[i].z, true) < Config.ZoneSize.x / 2) then
				isInWASHMarker = true
				SetTextComponentFormat('STRING')
				AddTextComponentString(_U('press_e_wash'))
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			end
		end
		if isInWASHMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
		end
		if not isInWASHMarker and hasAlreadyEnteredMarker then
		 	hasAlreadyEnteredMarker = false
		end
	end
end)

-- Menu interactions
Citizen.CreateThread(function()
	while true do
	Citizen.Wait(0)
		if IsControlJustReleased(0, 38) and isInWASHMarker then
			if exports['rk-inventory']:hasEnoughOfItem('band', 1) then
				local amt = exports['rk-inventory']:getQuantity('band')
				TriggerEvent("inventory:removeItem", 'band', amt)
				local mult = math.random(350, 650)
				TriggerServerEvent('rk_moneywash:withdraw', amt*mult)
			else
				TriggerEvent('DoLongHudText', 'Do You Have Anything To Exchange', 2)
			end
		end
	end
end)