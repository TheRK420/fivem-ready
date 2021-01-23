RKCore = nil

TriggerEvent("rk:getSharedObject", function(obj) RKCore = obj end)

RegisterServerEvent("rk-policefrisk:closestPlayer")
AddEventHandler("rk-policefrisk:closestPlayer", function(closestPlayer)
    _source = source
    target = closestPlayer

    TriggerClientEvent("rk-policefrisk:friskPlayer", target)
end)

RegisterServerEvent("rk-policefrisk:notifyMessage")
AddEventHandler("rk-policefrisk:notifyMessage", function(frisk)
    if frisk == true then
        --TriggerClientEvent('chatMessagess', _source, 'Information: ', 4, "I could feel something that reminds of a firearm")
        TriggerClientEvent('DoLongHudText', _source,  "I could feel something that reminds of a firearm", 2)
        return
    elseif frisk == false then
        --TriggerClientEvent('chatMessagess', _source, 'Information: ', 4, "I could not feel anything")
        TriggerClientEvent('DoLongHudText', _source,  "I could not feel anything", 2)
        return
    end
end)