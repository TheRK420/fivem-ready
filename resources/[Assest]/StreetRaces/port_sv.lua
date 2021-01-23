RKCore = nil
TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)

-- Helper function for getting player money
function getMoney(source)
    local xPlayer = RKCore.GetPlayerFromId(source)
    local getmoney = xPlayer.getMoney()
    return getmoney
end

-- Helper function for removing player money
function removeMoney(source, amount)
    local xPlayer = RKCore.GetPlayerFromId(source)
    xPlayer.removeMoney(amount)
end

-- Helper function for adding player money
function addMoney(source, amount)
    local xPlayer = RKCore.GetPlayerFromId(source)
    xPlayer.addMoney(amount)
end