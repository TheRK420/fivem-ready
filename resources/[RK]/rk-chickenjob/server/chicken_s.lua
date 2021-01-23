RKCore = nil

TriggerEvent('rk:getSharedObject', function(obj)
	RKCore = obj
end)

RegisterServerEvent('chickenpayment:pay')
AddEventHandler('chickenpayment:pay', function()
local _source = source
local xPlayer = RKCore.GetPlayerFromId(source)
	xPlayer.addMoney(math.random(150,300))
end)