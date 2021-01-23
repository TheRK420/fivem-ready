local steamIds = {
    ["steam:11000010aa15521"] = true --kevin
}

local RKCore = nil
-- RKCore
TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)

RegisterServerEvent('rk-doors:alterlockstate2')
AddEventHandler('rk-doors:alterlockstate2', function()
    --rk.DoorCoords[10]["lock"] = 0

    TriggerClientEvent('rk-doors:alterlockstateclient', source, rk.DoorCoords)

end)

RegisterServerEvent('rk-doors:alterlockstate')
AddEventHandler('rk-doors:alterlockstate', function(alterNum)
    print('lockstate:', alterNum)
    rk.alterState(alterNum)
end)

RegisterServerEvent('rk-doors:ForceLockState')
AddEventHandler('rk-doors:ForceLockState', function(alterNum, state)
    rk.DoorCoords[alterNum]["lock"] = state
    TriggerClientEvent('rk:Door:alterState', -1,alterNum,state)
end)

RegisterServerEvent('rk-doors:requestlatest')
AddEventHandler('rk-doors:requestlatest', function()
    local src = source 
    local steamcheck = RKCore.GetPlayerFromId(source).identifier
    if steamIds[steamcheck] then
        TriggerClientEvent('doors:HasKeys',src,true)
    end
    TriggerClientEvent('rk-doors:alterlockstateclient', source,rk.DoorCoords)
end)

function isDoorLocked(door)
    if rk.DoorCoords[door].lock == 1 then
        return true
    else
        return false
    end
end