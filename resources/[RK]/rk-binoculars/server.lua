RKCore               = nil

TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)

RKCore.RegisterUsableItem('binoculars', function(source)
    local xPlayer = RKCore.GetPlayerFromId(source)
    local drill = xPlayer.getInventoryItem('binoculars')

    TriggerClientEvent('binoculars:Activate', source)
end)