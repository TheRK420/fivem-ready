HHCore = nil
TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)
local chicken = vehicleBaseRepairCost

RegisterServerEvent('hhrp-bennysmech:attemptPurchase')
AddEventHandler('hhrp-bennysmech:attemptPurchase', function(type, upgradeLevel)
    local source = source
    local xPlayer = HHCore.GetPlayerFromId(source)
    if type == "repair" then
        if xPlayer.getMoney() >= chicken then
            xPlayer.removeMoney(chicken)
            TriggerClientEvent('hhrp-bennysmech:purchaseSuccessful', source)
        else
            TriggerClientEvent('hhrp-bennysmech:purchaseFailed', source)
        end
    elseif type == "performance" then
        if xPlayer.getMoney() >= vehicleCustomisationPrices[type].prices[upgradeLevel] then
            TriggerClientEvent('hhrp-bennysmech:purchaseSuccessful', source)
            xPlayer.removeMoney(vehicleCustomisationPrices[type].prices[upgradeLevel])
        else
            TriggerClientEvent('hhrp-bennysmech:purchaseFailed', source)
        end
    else
        if xPlayer.getMoney() >= vehicleCustomisationPrices[type].price then
            TriggerClientEvent('hhrp-bennysmech:purchaseSuccessful', source)
            xPlayer.removeMoney(vehicleCustomisationPrices[type].price)
        else
            TriggerClientEvent('hhrp-bennysmech:purchaseFailed', source)
        end
    end
end)

RegisterServerEvent('hhrp-bennysmech:updateRepairCost')
AddEventHandler('hhrp-bennysmech:updateRepairCost', function(cost)
    chicken = cost
end)

RegisterServerEvent('hhrp-bennysmech:updateVehicle')
AddEventHandler('hhrp-bennysmech:updateVehicle', function(myCar)
    MySQL.Async.execute('UPDATE `owned_vehicles` SET `vehicle` = @vehicle WHERE `plate` = @plate',
	{
		['@plate']   = myCar.plate,
		['@vehicle'] = json.encode(myCar)
	})
end)