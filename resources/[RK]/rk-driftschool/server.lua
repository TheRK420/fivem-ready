RKCore = nil

TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)

RegisterServerEvent('rk-driftschool:takemoney')
AddEventHandler('rk-driftschool:takemoney', function(money)
    local source = source
    local xPlayer = RKCore.GetPlayerFromId(source)
    if xPlayer.getMoney() >= money then
        xPlayer.removeMoney(money)
        TriggerClientEvent('rk-driftschool:tookmoney', source, true)
    else
        TriggerClientEvent('DoLongHudText', source, 'Not enough money', 2)
    end
end)