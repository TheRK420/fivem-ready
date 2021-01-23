RKCore = nil
TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)
local chicken = vehicleBaseRepairCost

RegisterServerEvent('rk-bennysmech:attemptPurchase')
AddEventHandler('rk-bennysmech:attemptPurchase', function(type, upgradeLevel)
    local source = source
    local xPlayer = RKCore.GetPlayerFromId(source)
    if type == "repair" then
        if xPlayer.getMoney() >= chicken then
            xPlayer.removeMoney(chicken)
            TriggerClientEvent('rk-bennysmech:purchaseSuccessful', source)
        else
            TriggerClientEvent('rk-bennysmech:purchaseFailed', source)
        end
    elseif type == "performance" then
        if xPlayer.getMoney() >= vehicleCustomisationPrices[type].prices[upgradeLevel] then
            TriggerClientEvent('rk-bennysmech:purchaseSuccessful', source)
            xPlayer.removeMoney(vehicleCustomisationPrices[type].prices[upgradeLevel])
        else
            TriggerClientEvent('rk-bennysmech:purchaseFailed', source)
        end
    else
        if xPlayer.getMoney() >= vehicleCustomisationPrices[type].price then
            TriggerClientEvent('rk-bennysmech:purchaseSuccessful', source)
            xPlayer.removeMoney(vehicleCustomisationPrices[type].price)
        else
            TriggerClientEvent('rk-bennysmech:purchaseFailed', source)
        end
    end
end)

RegisterServerEvent('rk-bennysmech:updateRepairCost')
AddEventHandler('rk-bennysmech:updateRepairCost', function(cost)
    chicken = cost
end)

RegisterServerEvent('rk-bennysmech:updateVehicle')
AddEventHandler('rk-bennysmech:updateVehicle', function(myCar)
    MySQL.Async.execute('UPDATE `owned_vehicles` SET `vehicle` = @vehicle WHERE `plate` = @plate',
	{
		['@plate']   = myCar.plate,
		['@vehicle'] = json.encode(myCar)
	})
end)