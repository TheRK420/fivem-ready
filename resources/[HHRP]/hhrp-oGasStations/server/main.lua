HHCore = nil

TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)

RegisterServerEvent('carfill:checkmoney')
AddEventHandler('carfill:checkmoney', function(cash)
    local source = source
    local xPlayer = HHCore.GetPlayerFromId(source)
    if cash > 0 then
        xPlayer.removeMoney(cash)
    end
end)