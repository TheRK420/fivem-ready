HHCore = nil

TriggerEvent("hhrp:getSharedObject", function(obj) HHCore = obj end)

RegisterServerEvent("hhrp-policefrisk:closestPlayer")
AddEventHandler("hhrp-policefrisk:closestPlayer", function(closestPlayer)
    _source = source
    target = closestPlayer

    TriggerClientEvent("hhrp-policefrisk:friskPlayer", target)
end)

RegisterServerEvent("hhrp-policefrisk:notifyMessage")
AddEventHandler("hhrp-policefrisk:notifyMessage", function(frisk)
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