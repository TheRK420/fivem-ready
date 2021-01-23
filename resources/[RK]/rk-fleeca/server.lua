RKCore = nil
TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)

RegisterServerEvent("rk-fleeca:startcheck")
AddEventHandler("rk-fleeca:startcheck", function(bank)
    local _source = source
    local copcount = 0
    local Players = RKCore.GetPlayers()

    for i = 1, #Players, 1 do
        local xPlayer = RKCore.GetPlayerFromId(Players[i])

        if xPlayer.job.name == "police" then
            copcount = copcount + 0
        end
    end
    local xPlayer = RKCore.GetPlayerFromId(_source)

    if copcount >= fleeca.mincops then
        if not fleeca.Banks[bank].onaction == true then
            if (os.time() - fleeca.cooldown) > fleeca.Banks[bank].lastrobbed then
                fleeca.Banks[bank].onaction = true
                TriggerClientEvent('inventory:removeItem', _source, 'thermite', 1)
                TriggerClientEvent("rk-fleeca:outcome", _source, true, bank)
                TriggerClientEvent("rk-fleeca:policenotify", -1, bank)
                TriggerClientEvent('rk-dispatch:bankrobbery', -1)
                    return
                else
                    TriggerClientEvent("rk-fleeca:outcome", _source, false, "This bank recently robbed. You need to wait "..math.floor((fleeca.cooldown - (os.time() - fleeca.Banks[bank].lastrobbed)) / 60)..":"..math.fmod((fleeca.cooldown - (os.time() - fleeca.Banks[bank].lastrobbed)), 60))
                end
            else
            TriggerClientEvent("rk-fleeca:outcome", _source, false, "This bank is currently being robbed.")
        end
    else
        TriggerClientEvent("rk-fleeca:outcome", _source, false, "There is not enough police in the city.")
    end
end)

RegisterServerEvent("rk-fleeca:lootup")
AddEventHandler("rk-fleeca:lootup", function(var, var2)
    TriggerClientEvent("rk-fleeca:lootup_c", -1, var, var2)
end)

RegisterServerEvent("rk-fleeca:openDoor")
AddEventHandler("rk-fleeca:openDoor", function(coords, method)
    TriggerClientEvent("rk-fleeca:openDoor_c", -1, coords, method)
end)

RegisterServerEvent("rk-fleeca:startLoot")
AddEventHandler("rk-fleeca:startLoot", function(data, name, players)
    local _source = source

    for i = 1, #players, 1 do
        TriggerClientEvent("rk-fleeca:startLoot_c", players[i], data, name)
    end
    TriggerClientEvent("rk-fleeca:startLoot_c", _source, data, name)
end)

RegisterServerEvent("rk-fleeca:stopHeist")
AddEventHandler("rk-fleeca:stopHeist", function(name)
    TriggerClientEvent("rk-fleeca:stopHeist_c", -1, name)
end)

RegisterServerEvent("rk-fleeca:rewardCash")
AddEventHandler("rk-fleeca:rewardCash", function()
    local xPlayer = RKCore.GetPlayerFromId(source)
    local reward = math.random(1, 2)
    local mathfunc = math.random(200)
    local payout = math.random(2,4)
    if mathfunc == 15 then
      TriggerClientEvent('player:receiveItem', source, 'goldbar', payout)
    end
    TriggerClientEvent("player:receiveItem", source, "band", reward)
end)

RegisterServerEvent("rk-fleeca:setCooldown")
AddEventHandler("rk-fleeca:setCooldown", function(name)
    fleeca.Banks[name].lastrobbed = os.time()
    fleeca.Banks[name].onaction = false
    TriggerClientEvent("rk-fleeca:resetDoorState", -1, name)
end)

RKCore.RegisterServerCallback("rk-fleeca:getBanks", function(source, cb)
    cb(fleeca.Banks)
end)