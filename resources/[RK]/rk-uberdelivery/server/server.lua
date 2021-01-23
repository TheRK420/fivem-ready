RKCore = nil

TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)

RegisterServerEvent('rk-uberkdshfksksdhfskdjjob:pay')
AddEventHandler('rk-uberkdshfksksdhfskdjjob:pay', function(amount)
	local _source = source
	local xPlayer = RKCore.GetPlayerFromId(_source)
	xPlayer.addMoney(tonumber(amount))
	TriggerClientEvent('chatMessagess', _source, '', 4, 'You got payed $' .. amount)
end)
