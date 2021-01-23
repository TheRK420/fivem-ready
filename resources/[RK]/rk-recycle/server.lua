RKCore                = nil

TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)

RegisterServerEvent('mission:completed')
AddEventHandler('mission:completed', function(money)
    local source = source
    local xPlayer  = RKCore.GetPlayerFromId(source)
    if money ~= nil then
        xPlayer.addMoney(money)
        TriggerClientEvent('DoLongHudText', source, 'You got $'.. money .. ' for 5 Loose Buds of Weed.', 1)
    end
end)

RegisterServerEvent('missionSystem:caughtMoney')
AddEventHandler('missionSystem:caughtMoney', function(money)
    local source = source
    local xPlayer  = RKCore.GetPlayerFromId(source)
    if money ~= nil then
        xPlayer.addMoney(money)
    end
end)