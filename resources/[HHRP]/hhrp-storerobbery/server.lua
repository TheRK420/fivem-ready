HHCore = nil
TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)

local deadPeds = {}

RegisterServerEvent('hhrp-storerobbery:pedDead')
AddEventHandler('hhrp-storerobbery:pedDead', function(store)
    if not deadPeds[store] then
        deadPeds[store] = 'deadlol'
        TriggerClientEvent('hhrp-storerobbery:onPedDeath', -1, store)
        local second = 1000
        local minute = 60 * second
        local hour = 60 * minute
        local cooldown = Config.Shops[store].cooldown
        local wait = cooldown.hour * hour + cooldown.minute * minute + cooldown.second * second
        Wait(wait)
        if not Config.Shops[store].robbed then
            for k, v in pairs(deadPeds) do if k == store then table.remove(deadPeds, k) end end
            TriggerClientEvent('hhrp-storerobbery:resetStore', -1, store)
        end
    end
end)

RegisterServerEvent('hhrp-storerobbery:handsUp')
AddEventHandler('hhrp-storerobbery:handsUp', function(store)
    TriggerClientEvent('hhrp-storerobbery:handsUp', -1, store)
end)

RegisterServerEvent('hhrp-storerobbery:pickUp')
AddEventHandler('hhrp-storerobbery:pickUp', function(store)
    local xPlayer = HHCore.GetPlayerFromId(source)
    local randomAmount = math.random(Config.Shops[store].money[1], Config.Shops[store].money[2])
    xPlayer.addMoney(randomAmount)
    TriggerClientEvent('DoLongHudText', source, 'You got: $' .. randomAmount, 2) 
    TriggerClientEvent('hhrp-storerobbery:removePickup', -1, store) 
end)

HHCore.RegisterServerCallback('hhrp-storerobbery:canRob', function(source, cb, store)
    local cops = 0
    local xPlayers = HHCore.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = HHCore.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            cops = cops + 1
        end
    end
    if cops >= Config.Shops[store].cops then
        if not Config.Shops[store].robbed and not deadPeds[store] then
            cb(true)
        else
            cb(false)
        end
    else
        cb('no_cops')
    end
end)

RegisterServerEvent('hhrp-storerobbery:notif')
AddEventHandler('hhrp-storerobbery:notif', function(store)
    local src = source
    local xPlayers = HHCore.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = HHCore.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            TriggerClientEvent('hhrp-storerobbery:msgPolice', src, store)
            return
        end
    end
end)

RegisterServerEvent('hhrp-storerobbery:rob')
AddEventHandler('hhrp-storerobbery:rob', function(store)
    local src = source
    Config.Shops[store].robbed = true
    TriggerClientEvent('hhrp-storerobbery:rob', -1, store)
    Wait(30000)
    TriggerClientEvent('hhrp-storerobbery:robberyOver', src)

    local second = 1000
    local minute = 60 * second
    local hour = 60 * minute
    local cooldown = Config.Shops[store].cooldown
    local wait = cooldown.hour * hour + cooldown.minute * minute + cooldown.second * second
    Wait(wait)
    Config.Shops[store].robbed = false
    for k, v in pairs(deadPeds) do if k == store then table.remove(deadPeds, k) end end
    TriggerClientEvent('hhrp-storerobbery:resetStore', -1, store)
end)

Citizen.CreateThread(function()
    while true do
        for i = 1, #deadPeds do TriggerClientEvent('hhrp-storerobbery:pedDead', -1, i) end -- update dead peds
        Citizen.Wait(500)
    end
end)
