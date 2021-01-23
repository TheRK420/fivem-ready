RKCore = nil

TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)

RegisterServerEvent('rk-fish:payShit')
AddEventHandler('rk-fish:payShit', function(money)
    local source = source
    local xPlayer  = RKCore.GetPlayerFromId(source)
    if money ~= nil then
        xPlayer.addMoney(money)
    end
end)

RegisterServerEvent('fish:checkAndTakeDepo')
AddEventHandler('fish:checkAndTakeDepo', function()
local source = source
local xPlayer  = RKCore.GetPlayerFromId(source)
    xPlayer.removeMoney(500)
end)

RegisterServerEvent('fish:returnDepo')
AddEventHandler('fish:returnDepo', function()
local source = source
local xPlayer  = RKCore.GetPlayerFromId(source)
    xPlayer.addMoney(500)
end)

RegisterServerEvent('rk-fish:getFish')
AddEventHandler('rk-fish:getFish', function()
local source = source
    TriggerClientEvent('player:receiveItem', source, "fish", math.random(1,2))
end)