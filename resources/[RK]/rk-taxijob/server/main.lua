RKCore = nil

TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('rk_service:activateService', 'taxi', Config.MaxInService)
end

TriggerEvent('rk_phone:registerNumber', 'taxi', _U('taxi_client'), true, true)
TriggerEvent('rk_society:registerSociety', 'taxi', 'Taxi', 'society_taxi', 'society_taxi', 'society_taxi', {type = 'public'})

RegisterServerEvent('rk_taxijob:success')
AddEventHandler('rk_taxijob:success', function()
	local xPlayer = RKCore.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'taxi' then
		print(('rk_taxijob: %s attempted to trigger success!'):format(xPlayer.identifier))
		return
	end

	math.randomseed(os.time())

	local total = math.random(Config.NPCJobEarnings.min, Config.NPCJobEarnings.max)
	local societyAccount

	if xPlayer.job.grade >= 3 then
		total = total * 2
	end

	TriggerEvent('rk_addonaccount:getSharedAccount', 'society_taxi', function(account)
		societyAccount = account
	end)

	if societyAccount then
		local playerMoney  = RKCore.Math.Round(total / 100 * 30)
		local societyMoney = RKCore.Math.Round(total / 100 * 70)

		xPlayer.addMoney(playerMoney)
		societyAccount.addMoney(societyMoney)

		TriggerClientEvent('rk:showNotification', xPlayer.source, _U('comp_earned', societyMoney, playerMoney))
	else
		xPlayer.addMoney(total)
		TriggerClientEvent('rk:showNotification', xPlayer.source, _U('have_earned', total))
	end

end)

RegisterServerEvent('rk_taxijob:getStockItem')
AddEventHandler('rk_taxijob:getStockItem', function(itemName, count)
	local xPlayer = RKCore.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'taxi' then
		print(('rk_taxijob: %s attempted to trigger getStockItem!'):format(xPlayer.identifier))
		return
	end
	
	TriggerEvent('rk_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
		local item = inventory.getItem(itemName)
		local sourceItem = xPlayer.getInventoryItem(itemName)

		-- is there enough in the society?
		if count > 0 and item.count >= count then
		
			-- can the player carry the said amount of x item?
			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('rk:showNotification', xPlayer.source, _U('player_cannot_hold'))
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('rk:showNotification', xPlayer.source, _U('have_withdrawn', count, item.label))
			end
		else
			TriggerClientEvent('rk:showNotification', xPlayer.source, _U('quantity_invalid'))
		end
	end)
end)

RKCore.RegisterServerCallback('rk_taxijob:getStockItems', function(source, cb)
	TriggerEvent('rk_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('rk_taxijob:putStockItems')
AddEventHandler('rk_taxijob:putStockItems', function(itemName, count)
	local xPlayer = RKCore.GetPlayerFromId(source)

	if xPlayer.job.name ~= 'taxi' then
		print(('rk_taxijob: %s attempted to trigger putStockItems!'):format(xPlayer.identifier))
		return
	end

	TriggerEvent('rk_addoninventory:getSharedInventory', 'society_taxi', function(inventory)
		local item = inventory.getItem(itemName)

		if item.count >= 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('rk:showNotification', xPlayer.source, _U('have_deposited', count, item.label))
		else
			TriggerClientEvent('rk:showNotification', xPlayer.source, _U('quantity_invalid'))
		end

	end)

end)

RKCore.RegisterServerCallback('rk_taxijob:getPlayerInventory', function(source, cb)
	local xPlayer = RKCore.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb( { items = items } )
end)
