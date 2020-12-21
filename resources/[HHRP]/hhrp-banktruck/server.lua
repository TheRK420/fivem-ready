--------------------------------
------- Created by Hamza -------
-------------------------------- 

local ESX = nil

local cooldownTimer = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- server side for cooldown timer
RegisterServerEvent("esx_TruckRobbery:missionCooldown")
AddEventHandler("esx_TruckRobbery:missionCooldown",function(source)
	table.insert(cooldownTimer,{CoolTimer = GetPlayerIdentifier(source), time = (Config.CooldownTimer * 60000)}) -- cooldown timer for doing missions
end)

ESX.RegisterServerCallback('truck:HasItemkit', function(source, cb, item, count)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
	local item = 'electronickit'
	if (xPlayer.getInventoryItem(item)["count"] >= 1) then
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('truck:HasItemc4', function(source, cb, item, count)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
	local item = 'c4_bank'
	if (xPlayer.getInventoryItem(item)["count"] >= 1) then
		cb(true)
	else
		cb(false)
	end
end)

-- thread for syncing the cooldown timer
Citizen.CreateThread(function() -- do not touch this thread function!
	while true do
	Citizen.Wait(1000)
		for k,v in pairs(cooldownTimer) do
			if v.time <= 0 then
				RemoveCooldownTimer(v.CoolTimer)
			else
				v.time = v.time - 1000
			end
		end
	end
end)

-- sync mission data
RegisterServerEvent("esx_TruckRobbery:syncMissionData")
AddEventHandler("esx_TruckRobbery:syncMissionData",function(data)
	TriggerClientEvent("esx_TruckRobbery:syncMissionData",-1,data)
end)

-- server side function to accept the mission
RegisterServerEvent('esx_TruckRobbery:missionAccepted')
AddEventHandler('esx_TruckRobbery:missionAccepted', function()
	local policeOnline = 0
	local Players = ESX.GetPlayers()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local accountMoney = 0
	accountMoney = xPlayer.getAccount('bank').money
	
	if not CheckCooldownTimer(GetPlayerIdentifier(source)) then
	
		if accountMoney <= Config.MissionCost then
			TriggerClientEvent('esx:showNotification', source, Config.NotEnoughMoney)
		else
			for i = 1, #Players do
				local xPlayer = ESX.GetPlayerFromId(Players[i])
				if xPlayer["job"]["name"] == Config.PoliceDatabaseName then
					policeOnline = policeOnline + 1
				end
			end
			if policeOnline >= Config.RequiredPoliceOnline then
				TriggerEvent("esx_TruckRobbery:missionCooldown",source)
				TriggerClientEvent("esx_TruckRobbery:HackingMiniGame",source)
			
				ESX.RegisterServerCallback("esx_TruckRobbery:StartMissionNow",function(source,cb)
				local _source = source
				local xPlayer = ESX.GetPlayerFromId(_source)
				cb()
				TriggerClientEvent("esx_TruckRobbery:startMission",source,0)
				end)
				xPlayer.removeAccountMoney('bank', Config.MissionCost)
				xPlayer.removeInventoryItem('electronickit', 1)

			else
				TriggerClientEvent('esx:showNotification', source, Config.NotEnoughPolice)
			end
		end
	else
		TriggerClientEvent("esx:showNotification",source,string.format(Config.CooldownMessage,GetCooldownTimer(GetPlayerIdentifier(source))))
	end
end)

-- mission reward
RegisterServerEvent('esx_TruckRobbery:missionComplete')
AddEventHandler('esx_TruckRobbery:missionComplete', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local reward = math.random(Config.MinReward,Config.MaxReward)
	
	if Config.RewardInDirtyMoney then
		xPlayer.addAccountMoney('black_money', tonumber(reward))
	else
		xPlayer.addMoney(reward)
	end	
	TriggerClientEvent('esx:showNotification', source, string.format(Config.RewardMessage,reward))
	
	if Config.EnableItemReward == true then
		local itemAmount1 = math.random(Config.ItemMinAmount1,Config.ItemMaxAmount1)
		xPlayer.addInventoryItem(Config.ItemName1,itemAmount1)
		local item1 = ESX.GetItemLabel(Config.ItemName1)
		TriggerClientEvent('esx:showNotification', source, string.format(Config.Item1Message,itemAmount1))
	end
	
	if Config.EnableRareItemReward == true then
		local chance = math.random(1, 30)
		local itemAmount2 = math.random(Config.ItemMinAmount2,Config.ItemMaxAmount2)
		if chance == 1 then
			xPlayer.addInventoryItem(Config.ItemName2, 1)
			local item2 = ESX.GetItemLabel(Config.ItemName2)
			TriggerClientEvent('esx:showNotification', source, string.format(Config.Item2Message, 1))
		end	
	end
	
	Wait(1000)
end)

RegisterServerEvent('esx_TruckRobbery:TruckRobberyInProgress')
AddEventHandler('esx_TruckRobbery:TruckRobberyInProgress', function(targetCoords, streetName)
	TriggerClientEvent('esx_TruckRobbery:outlawNotify', -1,string.format(Config.DispatchMessage,streetName))
	TriggerClientEvent('esx_TruckRobbery:TruckRobberyInProgress', -1, targetCoords)
end)

RegisterServerEvent('truck:RemoveItemc4')
AddEventHandler('truck:RemoveItemc4', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    xPlayer.removeInventoryItem('c4_bank', 1)
end)

RegisterServerEvent('heist:truck')
AddEventHandler('heist:truck', function(targetCoords, streetName, emergency)
    local _source = source
    local xPlayers = ESX.GetPlayers()
	local messageFull
    fal = "Bomb Blast on"
    msg = "LSPD HIGH Alert!"
	if emergency == 'truck' then
		--TriggerEvent('3dme:shareDisplay', "Calls 911")
		messageFull = {
			template = '<div style="padding: 8px; margin: 8px; background-color: rgba(219, 35, 35, 0.9); border-radius: 25px;"><i class="fas fa-bell"style="font-size:15px"></i> CODE 3 | {0}  {1} | {2}</font></i></b></div>',
        	args = {fal, streetName, msg}
		}
	end
	TriggerClientEvent('heist:setblip', -1, targetCoords, emergency)
    TriggerClientEvent('heist:EmergencySend', -1, messageFull)
end)
-- DO NOT TOUCH!!
function RemoveCooldownTimer(source)
	for k,v in pairs(cooldownTimer) do
		if v.CoolTimer == source then
			table.remove(cooldownTimer,k)
		end
	end
end
-- DO NOT TOUCH!!
function GetCooldownTimer(source)
	for k,v in pairs(cooldownTimer) do
		if v.CoolTimer == source then
			return math.ceil(v.time/60000)
		end
	end
end
-- DO NOT TOUCH!!
function CheckCooldownTimer(source)
	for k,v in pairs(cooldownTimer) do
		if v.CoolTimer == source then
			return true
		end
	end
	return false
end
