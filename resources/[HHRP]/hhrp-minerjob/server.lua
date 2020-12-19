--------------------------------
------- Created by Hamza -------
-------------------------------- 

local HHCore = nil

didmining = {}

TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)

local MiningPos 		= Config.MiningPositions
local WashingPos 		= Config.WashingPositions
local SmeltingPos 		= Config.SmeltingPositions

-- On Player Load, load the spots:
AddEventHandler('hhrp:playerLoaded', function(source)
    TriggerClientEvent('hhrp_MinerJob:loadSpot', source, MiningPos, WashingPos, SmeltingPos)
end)

-- Refresh Spot Status:
RegisterServerEvent('hhrp_MinerJob:refreshSpots')
AddEventHandler('hhrp_MinerJob:refreshSpots', function()
    TriggerClientEvent('hhrp_MinerJob:loadSpot', -1, MiningPos, WashingPos, SmeltingPos)
end)

-- Update Spot Status:
RegisterServerEvent('hhrp_MinerJob:spotStatus')
AddEventHandler('hhrp_MinerJob:spotStatus', function(id, status)
    local xPlayer = HHCore.GetPlayerFromId(source)
    if MiningPos[id].pairs ~= nil then
        MiningPos[MiningPos[id].pairs].mining=status
        TriggerClientEvent('hhrp_MinerJob:updateStatus', -1, MiningPos[id].pairs, status)
    end
    MiningPos[id].mining=status
    TriggerClientEvent('hhrp_MinerJob:updateStatus', -1, id, status)
end)

-- Server Callback to get inventory pickaxe:
-- HHCore.RegisterServerCallback("hhrp_MinerJob:getPickaxe",function(source,cb)
-- 	local xPlayer = HHCore.GetPlayerFromId(source)
-- 	if xPlayer.getInventoryItem(Config.Pickaxe).count >= 1 then
-- 		cb(true)
-- 	else
-- 		cb(false)
-- 	end
-- end)

-- Server Callback to get inventory pickaxe:
RegisterNetEvent("hhrp_MinerJob:getStoneLimit")
AddEventHandler("hhrp_MinerJob:getStoneLimit",function()
	local xPlayer = HHCore.GetPlayerFromId(source)
		local player = xPlayer.identifier
		table.insert(didmining, {identifier = player})
		--cb(false)
	end
end)

HHCore.RegisterServerCallback("hhrp_MinerJob:didmining",function(source, cb) 
local xPlayer = HHCore.GetPlayerFromId(source)
local did = 0
	for k,v in pairs(didmining) do
		if v.identifier == xPlayer.identifier then
			did = 1
		end
	end
	if did ~= 1 then 
		cb(true)
	else
		cb(false)
	end
end)

-- Server Callback to get inventory washing pan:
-- HHCore.RegisterServerCallback("hhrp_MinerJob:getWashPan",function(source,cb)
-- 	local xPlayer = HHCore.GetPlayerFromId(source)
-- 	if xPlayer.getInventoryItem(Config.Washpan).count >= 1 then
-- 		cb(true)
-- 	else
-- 		cb(false)
-- 	end
-- end)

-- -- Server Callback to get inventory pickaxe:
-- HHCore.RegisterServerCallback("hhrp_MinerJob:getWashedStoneLimit",function(source,cb)
-- 	local xPlayer = HHCore.GetPlayerFromId(source)
-- 	if xPlayer.getInventoryItem(Config.WStone).count <= Config.MaxWStoneAmount then
-- 		cb(true)
-- 	else
-- 		cb(false)
-- 	end
-- end)

-- -- Server Callback to get washed stone:
-- HHCore.RegisterServerCallback("hhrp_MinerJob:getWashedStone",function(source,cb)
-- 	local xPlayer = HHCore.GetPlayerFromId(source)
-- 	if xPlayer.getInventoryItem(Config.WStone).count >= 10 then
-- 		xPlayer.removeInventoryItem(Config.WStone, 10)
-- 		cb(true)
-- 	else
-- 		cb(false)
-- 	end
-- end)

-- -- Server Callback to get stone count & remove stone:
-- HHCore.RegisterServerCallback("hhrp_MinerJob:removeStone",function(source,cb)
-- 	local xPlayer = HHCore.GetPlayerFromId(source)
-- 	if xPlayer.getInventoryItem(Config.Stone).count >= Config.ReqStoneForWash then
-- 		xPlayer.removeInventoryItem(Config.Stone, Config.ReqStoneForWash)
-- 		cb(true)
-- 	else
-- 		cb(false)
-- 	end
-- end)

-- -- Function to reward player after mining/washing:
-- RegisterServerEvent("hhrp_MinerJob:reward")
-- AddEventHandler("hhrp_MinerJob:reward", function(itemName,itemAmount)
-- 	local xPlayer = HHCore.GetPlayerFromId(source)
-- 	local itemLabel = HHCore.GetItemLabel(itemName)
-- 	xPlayer.addInventoryItem(itemName, itemAmount)	
-- 	TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', length = 2000, text = "You get "..itemAmount.."x "..itemLabel})
-- end)

-- -- Function to reward player after smelting:
-- RegisterServerEvent("hhrp_MinerJob:rewardSmelting")
-- AddEventHandler("hhrp_MinerJob:rewardSmelting", function()
-- 	local xPlayer = HHCore.GetPlayerFromId(source)
		
-- 	local itemLimit1 = xPlayer.getInventoryItem(Config.Item1).count
-- 	local itemLimit2 = xPlayer.getInventoryItem(Config.Item2).count
-- 	local itemLimit3 = xPlayer.getInventoryItem(Config.Item3).count
-- 	local itemLimit4 = xPlayer.getInventoryItem(Config.Item4).count
-- 	local itemLimit5 = xPlayer.getInventoryItem(Config.Item5).count
-- 	local itemLimit6 = xPlayer.getInventoryItem(Config.Item6).count
		
-- 	local rewardChance = math.random(1,10)
	
-- 	if rewardChance == 1 then
-- 		if itemLimit1 < Config.ItemLimit1 then
-- 			xPlayer.addInventoryItem(Config.Item1, Config.ItemReward1)
-- 			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', length = 2000, text = "You got 1x Diamond." })
-- 		else
-- 			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', length = 2000, text = "Not enough empty space anymore." })
-- 		end
-- 	elseif rewardChance == 2 then
-- 		if itemLimit2 < Config.ItemLimit2 then
-- 			xPlayer.addInventoryItem(Config.Item2, Config.ItemReward2)
-- 			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', length = 2000, text = "You got 1x Rubies." })
-- 		else
-- 			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', length = 2000, text = "Not enough empty space anymore." })
-- 		end
-- 	elseif rewardChance == 3 or rewardChance == 4 or rewardChance == 5 then
-- 		local firstChance = math.random(1,2)
-- 		if firstChance == 1 then
-- 			if itemLimit3 < Config.ItemLimit3 then
-- 				xPlayer.addInventoryItem(Config.Item3, Config.ItemReward3)
-- 				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', length = 2000, text = "You received 1x Gold." })
-- 			else
-- 				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', length = 2000, text = "Not enough empty space anymore." })
-- 			end
-- 		else
-- 			if itemLimit4 < Config.ItemLimit4 then
-- 				xPlayer.addInventoryItem(Config.Item4, Config.ItemReward4)
-- 				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', length = 2000, text = "You got 2x Silver." })
-- 			else
-- 				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', length = 2000, text = "Not enough empty space anymore." })
-- 			end
-- 		end
-- 	elseif rewardChance == 6 or rewardChance == 7 or rewardChance == 8 or rewardChance == 9 or rewardChance == 10 then
-- 		local secondChance = math.random(1,2)
-- 		if secondChance == 1 then
-- 			if itemLimit5 < Config.ItemLimit5 then
-- 				xPlayer.addInventoryItem(Config.Item5, Config.ItemReward5)
-- 				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', length = 2000, text = "You got 3x Copper." })
-- 			else
-- 				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', length = 2000, text = "Not enough empty space anymore." })
-- 			end
-- 		else
-- 			if itemLimit6 < Config.ItemLimit6 then
-- 				xPlayer.addInventoryItem(Config.Item6, Config.ItemReward6)
-- 				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', length = 2000, text = "You got 7x Iron Ore." })
-- 			else
-- 				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', length = 2000, text = "Not enough empty space anymore." })
-- 			end
-- 		end
-- 	end
	
-- end)

