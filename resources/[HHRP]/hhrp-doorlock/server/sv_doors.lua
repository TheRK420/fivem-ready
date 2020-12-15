local steamIds = {
    ["steam:11000010aa15521"] = true --kevin
}

local HHCore = nil
-- HHCore
TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)

RegisterServerEvent('hhrp-doors:alterlockstate2')
AddEventHandler('hhrp-doors:alterlockstate2', function()
    --hhrp.DoorCoords[10]["lock"] = 0

    TriggerClientEvent('hhrp-doors:alterlockstateclient', source, hhrp.DoorCoords)

end)

RegisterServerEvent('hhrp-doors:alterlockstate')
AddEventHandler('hhrp-doors:alterlockstate', function(alterNum)
    print('lockstate:', alterNum)
    hhrp.alterState(alterNum)
end)

RegisterServerEvent('hhrp-doors:ForceLockState')
AddEventHandler('hhrp-doors:ForceLockState', function(alterNum, state)
    hhrp.DoorCoords[alterNum]["lock"] = state
    TriggerClientEvent('hhrp:Door:alterState', -1,alterNum,state)
end)

RegisterServerEvent('hhrp-doors:requestlatest')
AddEventHandler('hhrp-doors:requestlatest', function()
    local src = source 
    local steamcheck = HHCore.GetPlayerFromId(source).identifier
    if steamIds[steamcheck] then
        TriggerClientEvent('doors:HasKeys',src,true)
    end
    TriggerClientEvent('hhrp-doors:alterlockstateclient', source,hhrp.DoorCoords)
end)

function isDoorLocked(door)
    if hhrp.DoorCoords[door].lock == 1 then
        return true
    else
        return false
    end
end