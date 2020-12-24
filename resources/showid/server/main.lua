HHCore = nil

TriggerEvent('hhrp:getSharedObject', function(obj)
    HHCore = obj
end)

RegisterCommand('id', function(source, args, raw)
    local player = HHCore.GetPlayerFromId(source)
    if Config.AdminOnly then
        if player.getGroup() == 'user' then
            return
        end
    end
    TriggerClientEvent('disc-showid:id', source)
end)