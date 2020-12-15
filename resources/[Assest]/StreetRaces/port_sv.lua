HHCore = nil
TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)

-- Helper function for getting player money
function getMoney(source)
    local xPlayer = HHCore.GetPlayerFromId(source)
    local getmoney = xPlayer.getMoney()
    return getmoney
end

-- Helper function for removing player money
function removeMoney(source, amount)
    local xPlayer = HHCore.GetPlayerFromId(source)
    xPlayer.removeMoney(amount)
end

-- Helper function for adding player money
function addMoney(source, amount)
    local xPlayer = HHCore.GetPlayerFromId(source)
    xPlayer.addMoney(amount)
end