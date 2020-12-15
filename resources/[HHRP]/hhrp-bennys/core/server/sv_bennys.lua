HHCore = nil
TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)
local chicken = vehicleBaseRepairCost

RegisterServerEvent('hhrp-bennys:attemptPurchase')
AddEventHandler('hhrp-bennys:attemptPurchase', function(type, upgradeLevel)
    local source = source
    local xPlayer = HHCore.GetPlayerFromId(source)
    if type == "repair" then
        if xPlayer.getMoney() >= chicken then
            xPlayer.removeMoney(chicken)
            TriggerClientEvent('hhrp-bennys:purchaseSuccessful', source)
        else
            TriggerClientEvent('hhrp-bennys:purchaseFailed', source)
        end
    elseif type == "performance" then
        if xPlayer.getMoney() >= vehicleCustomisationPrices[type].prices[upgradeLevel] then
            TriggerClientEvent('hhrp-bennys:purchaseSuccessful', source)
            xPlayer.removeMoney(vehicleCustomisationPrices[type].prices[upgradeLevel])
        else
            TriggerClientEvent('hhrp-bennys:purchaseFailed', source)
        end
    else
        if xPlayer.getMoney() >= vehicleCustomisationPrices[type].price then
            TriggerClientEvent('hhrp-bennys:purchaseSuccessful', source)
            xPlayer.removeMoney(vehicleCustomisationPrices[type].price)
        else
            TriggerClientEvent('hhrp-bennys:purchaseFailed', source)
        end
    end
end)

RegisterServerEvent('hhrp-bennys:updateRepairCost')
AddEventHandler('hhrp-bennys:updateRepairCost', function(cost)
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