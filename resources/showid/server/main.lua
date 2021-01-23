RKCore = nil

TriggerEvent('rk:getSharedObject', function(obj)
    RKCore = obj
end)

RegisterCommand('id', function(source, args, raw)
    local player = RKCore.GetPlayerFromId(source)
    if Config.AdminOnly then
        if player.getGroup() == 'user' then
            return
        end
    end
    TriggerClientEvent('disc-showid:id', source)
end)