HHCore = nil

TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('hhrp_service:activateService', 'taxi', Config.MaxInService)
end

TriggerEvent('hhrp_phone:registerNumber', 'taxi', _U('taxi_client'), true, true)
TriggerEvent('hhrp_society:registerSociety', 'taxi', 'Taxi', 'society_taxi', 'society_taxi', 'society_taxi', {type = 'public'})

RegisterServerEvent('hhrp_taxijob:success')
AddEventHandler('hhrp_taxijob:success', function()
	local xPlayer = HHCore.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'taxi' then
		print(('hhrp_taxijob: %s attempted to trigger success!'):format(xPlayer.identifier))
		return
	end

	math.randomseed(os.time())

	local total = math.random(Config.NPCJobEarnings.min, Config.NPCJobEarnings.max)
	local societyAccount

	if xPlayer.job.grade >= 3 then
		total = total * 2
	end

	TriggerEvent('hhrp_addonaccount:getSharedAccount', 'society_taxi', function(account)
		societyAccount = account
	end)

	if societyAccount then
		local playerMoney  = HHCore.Math.Round(total / 100 * 30)
		local societyMoney = HHCore.Math.Round(total / 100 * 70)

		xPlayer.addMoney(playerMoney)
		societyAccount.addMoney(societyMoney)

		TriggerClientEvent('hhrp:showNotification', xPlayer.source, _U('comp_earned', societyMoney, playerMoney))
	else
		xPlayer.addMoney(total)
		TriggerClientEvent('hhrp:showNotification', xPlayer.source, _U('have_earned', total))
	end

end)

RegisterServerEvent('hhrp_taxijob:getStockItem')
AddEventHandler('hhrp_taxijob:getStockItem', function(itemName, count)
	local xPlayer = HHCore.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'taxi' then
		print(('hhrp_taxijob: %s attempted to trigger getStockItem!'):format(xPlayer.identifier))
		return
	end
	
	TriggerEvent('hhrp_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
		local item = inventory.getItem(itemName)
		local sourceItem = xPlayer.getInventoryItem(itemName)

		-- is there enough in the society?
		if count > 0 and item.count >= count then
		
			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('hhrp:showNotification', xPlayer.source, _U('player_cannot_hold'))
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('hhrp:showNotification', xPlayer.source, _U('have_withdrawn', count, item.label))
			end
		else
			TriggerClientEvent('hhrp:showNotification', xPlayer.source, _U('quantity_invalid'))
		end
	end)
end)

HHCore.RegisterServerCallback('hhrp_taxijob:getStockItems', function(source, cb)
	TriggerEvent('hhrp_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('hhrp_taxijob:putStockItems')
AddEventHandler('hhrp_taxijob:putStockItems', function(itemName, count)
	local xPlayer = HHCore.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'taxi' then
		print(('hhrp_taxijob: %s attempted to trigger putStockItems!'):format(xPlayer.identifier))
		return
	end

	TriggerEvent('hhrp_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
		local item = inventory.getItem(itemName)

		if item.count >= 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('hhrp:showNotification', xPlayer.source, _U('have_deposited', count, item.label))
		else
			TriggerClientEvent('hhrp:showNotification', xPlayer.source, _U('quantity_invalid'))
		end

	end)

end)

HHCore.RegisterServerCallback('hhrp_taxijob:getPlayerInventory', function(source, cb)
	local xPlayer = HHCore.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)
