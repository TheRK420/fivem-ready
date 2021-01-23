RKCore               = nil

TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)

----
RKCore.RegisterUsableItem('gauze', function(source)
	local xPlayer = RKCore.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('gauze', 1)

	TriggerClientEvent('rk-hospital:items:gauze', source)
end)

RKCore.RegisterUsableItem('bandaids', function(source)
	local xPlayer = RKCore.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('bandaids', 1)

	TriggerClientEvent('rk-hospital:items:bandage', source)
end)

RKCore.RegisterUsableItem('firstaid', function(source)
	local xPlayer = RKCore.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firstaid', 1)

	TriggerClientEvent('rk-hospital:items:firstaid', source)
end)

RKCore.RegisterUsableItem('vicodin', function(source)
	local xPlayer = RKCore.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('vicodin', 1)

	TriggerClientEvent('rk-hospital:items:vicodin', source)
end)

RKCore.RegisterUsableItem('ifak', function(source)
	local xPlayer = RKCore.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('ifak', 1)

	TriggerClientEvent('rk-hospital:items:ifak', source)
end)

RKCore.RegisterUsableItem('hydrocodone', function(source)
	local xPlayer = RKCore.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('hydrocodone', 1)

	TriggerClientEvent('rk-hospital:items:hydrocodone', source)
end)

RKCore.RegisterUsableItem('morphine', function(source)
	local xPlayer = RKCore.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('morphine', 1)

	TriggerClientEvent('rk-hospital:items:morphine', source)
end)
