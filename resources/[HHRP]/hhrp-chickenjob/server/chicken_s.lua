HHCore = nil

TriggerEvent('hhrp:getSharedObject', function(obj)
	HHCore = obj
end)

RegisterServerEvent('chickenpayment:pay')
AddEventHandler('chickenpayment:pay', function()
local _source = source
local xPlayer = HHCore.GetPlayerFromId(source)
	xPlayer.addMoney(math.random(150,300))
end)