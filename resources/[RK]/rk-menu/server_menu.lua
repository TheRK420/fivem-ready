RKCore = nil

TriggerEvent('rk:getSharedObject', function(obj)
    RKCore = obj
end)

RegisterServerEvent('rk-interactions:putInVehicle')
AddEventHandler('rk-interactions:putInVehicle', function(target)
    TriggerClientEvent('rk-interactions:putInVehicle', target)
end)

RegisterServerEvent('rk-interactions:outOfVehicle')
AddEventHandler('rk-interactions:outOfVehicle', function(target)
    TriggerClientEvent('rk-interactions:outOfVehicle', target)
end)
