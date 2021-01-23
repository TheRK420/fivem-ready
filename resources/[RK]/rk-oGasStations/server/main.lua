RKCore = nil

TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)

RegisterServerEvent('carfill:checkmoney')
AddEventHandler('carfill:checkmoney', function(cash)
    local source = source
    local xPlayer = RKCore.GetPlayerFromId(source)
    if cash > 0 then
        xPlayer.removeMoney(cash)
    end
end)