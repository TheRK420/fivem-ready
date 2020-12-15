HHCore = nil

TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)

RegisterServerEvent('hhrp-uberkdshfksksdhfskdjjob:pay')
AddEventHandler('hhrp-uberkdshfksksdhfskdjjob:pay', function(amount)
	local _source = source
	local xPlayer = HHCore.GetPlayerFromId(_source)
	xPlayer.addMoney(tonumber(amount))
	TriggerClientEvent('chatMessagess', _source, '', 4, 'You got payed $' .. amount)
end)
