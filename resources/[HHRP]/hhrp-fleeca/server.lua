HHCore = nil
TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)

RegisterServerEvent("hhrp-fleeca:startcheck")
AddEventHandler("hhrp-fleeca:startcheck", function(bank)
    local _source = source
    local copcount = 0
    local Players = HHCore.GetPlayers()

    for i = 1, #Players, 1 do
        local xPlayer = HHCore.GetPlayerFromId(Players[i])

        if xPlayer.job.name == "police" then
            copcount = copcount + 0
        end
    end
    local xPlayer = HHCore.GetPlayerFromId(_source)

    if copcount >= fleeca.mincops then
        if not fleeca.Banks[bank].onaction == true then
            if (os.time() - fleeca.cooldown) > fleeca.Banks[bank].lastrobbed then
                fleeca.Banks[bank].onaction = true
                TriggerClientEvent('inventory:removeItem', _source, 'thermite', 1)
                TriggerClientEvent("hhrp-fleeca:outcome", _source, true, bank)
                TriggerClientEvent("hhrp-fleeca:policenotify", -1, bank)
                TriggerClientEvent('hhrp-dispatch:bankrobbery', -1)
                    return
                else
                    TriggerClientEvent("hhrp-fleeca:outcome", _source, false, "This bank recently robbed. You need to wait "..math.floor((fleeca.cooldown - (os.time() - fleeca.Banks[bank].lastrobbed)) / 60)..":"..math.fmod((fleeca.cooldown - (os.time() - fleeca.Banks[bank].lastrobbed)), 60))
                end
            else
            TriggerClientEvent("hhrp-fleeca:outcome", _source, false, "This bank is currently being robbed.")
        end
    else
        TriggerClientEvent("hhrp-fleeca:outcome", _source, false, "There is not enough police in the city.")
    end
end)

RegisterServerEvent("hhrp-fleeca:lootup")
AddEventHandler("hhrp-fleeca:lootup", function(var, var2)
    TriggerClientEvent("hhrp-fleeca:lootup_c", -1, var, var2)
end)

RegisterServerEvent("hhrp-fleeca:openDoor")
AddEventHandler("hhrp-fleeca:openDoor", function(coords, method)
    TriggerClientEvent("hhrp-fleeca:openDoor_c", -1, coords, method)
end)

RegisterServerEvent("hhrp-fleeca:startLoot")
AddEventHandler("hhrp-fleeca:startLoot", function(data, name, players)
    local _source = source

    for i = 1, #players, 1 do
        TriggerClientEvent("hhrp-fleeca:startLoot_c", players[i], data, name)
    end
    TriggerClientEvent("hhrp-fleeca:startLoot_c", _source, data, name)
end)

RegisterServerEvent("hhrp-fleeca:stopHeist")
AddEventHandler("hhrp-fleeca:stopHeist", function(name)
    TriggerClientEvent("hhrp-fleeca:stopHeist_c", -1, name)
end)

RegisterServerEvent("hhrp-fleeca:rewardCash")
AddEventHandler("hhrp-fleeca:rewardCash", function()
    local xPlayer = HHCore.GetPlayerFromId(source)
    local reward = math.random(1, 2)
    local mathfunc = math.random(200)
    local payout = math.random(2,4)
    if mathfunc == 15 then
      TriggerClientEvent('player:receiveItem', source, 'goldbar', payout)
    end
    TriggerClientEvent("player:receiveItem", source, "band", reward)
end)

RegisterServerEvent("hhrp-fleeca:setCooldown")
AddEventHandler("hhrp-fleeca:setCooldown", function(name)
    fleeca.Banks[name].lastrobbed = os.time()
    fleeca.Banks[name].onaction = false
    TriggerClientEvent("hhrp-fleeca:resetDoorState", -1, name)
end)

HHCore.RegisterServerCallback("hhrp-fleeca:getBanks", function(source, cb)
    cb(fleeca.Banks)
end)