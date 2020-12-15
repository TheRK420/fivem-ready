HHCore               = nil

TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)

HHCore.RegisterUsableItem('binoculars', function(source)
    local xPlayer = HHCore.GetPlayerFromId(source)
    local drill = xPlayer.getInventoryItem('binoculars')

    TriggerClientEvent('binoculars:Activate', source)
end)