RKCore = nil
TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)
local chicken = vehicleBaseRepairCost

RegisterServerEvent('rk-bennys:attemptPurchase')
AddEventHandler('rk-bennys:attemptPurchase', function(type, upgradeLevel)
    local source = source
    local xPlayer = RKCore.GetPlayerFromId(source)
    if type == "repair" then
        if xPlayer.getMoney() >= chicken then
            xPlayer.removeMoney(chicken)
            TriggerClientEvent('rk-bennys:purchaseSuccessful', source)
        else
            TriggerClientEvent('rk-bennys:purchaseFailed', source)
        end
    elseif type == "performance" then
        if xPlayer.getMoney() >= vehicleCustomisationPrices[type].prices[upgradeLevel] then
            TriggerClientEvent('rk-bennys:purchaseSuccessful', source)
            xPlayer.removeMoney(vehicleCustomisationPrices[type].prices[upgradeLevel])
        else
            TriggerClientEvent('rk-bennys:purchaseFailed', source)
        end
    else
        if xPlayer.getMoney() >= vehicleCustomisationPrices[type].price then
            TriggerClientEvent('rk-bennys:purchaseSuccessful', source)
            xPlayer.removeMoney(vehicleCustomisationPrices[type].price)
        else
            TriggerClientEvent('rk-bennys:purchaseFailed', source)
        end
    end
end)

RegisterServerEvent('rk-bennys:updateRepairCost')
AddEventHandler('rk-bennys:updateRepairCost', function(cost)
    chicken = cost
end)

RegisterServerEvent('updateVehicle')
AddEventHandler('updateVehicle', function(myCar)
    MySQL.Async.execute('UPDATE `owned_vehicles` SET `vehicle` = @vehicle WHERE `plate` = @plate',
	{
		['@plate']   = myCar.plate,
		['@vehicle'] = json.encode(myCar)
	})
end)