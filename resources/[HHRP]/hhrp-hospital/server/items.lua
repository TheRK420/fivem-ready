HHCore               = nil

TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)

----
HHCore.RegisterUsableItem('gauze', function(source)
	local xPlayer = HHCore.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('gauze', 1)

	TriggerClientEvent('hhrp-hospital:items:gauze', source)
end)

HHCore.RegisterUsableItem('bandaids', function(source)
	local xPlayer = HHCore.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('bandaids', 1)

	TriggerClientEvent('hhrp-hospital:items:bandage', source)
end)

HHCore.RegisterUsableItem('firstaid', function(source)
	local xPlayer = HHCore.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('firstaid', 1)

	TriggerClientEvent('hhrp-hospital:items:firstaid', source)
end)

HHCore.RegisterUsableItem('vicodin', function(source)
	local xPlayer = HHCore.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('vicodin', 1)

	TriggerClientEvent('hhrp-hospital:items:vicodin', source)
end)

HHCore.RegisterUsableItem('ifak', function(source)
	local xPlayer = HHCore.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('ifak', 1)

	TriggerClientEvent('hhrp-hospital:items:ifak', source)
end)

HHCore.RegisterUsableItem('hydrocodone', function(source)
	local xPlayer = HHCore.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('hydrocodone', 1)

	TriggerClientEvent('hhrp-hospital:items:hydrocodone', source)
end)

HHCore.RegisterUsableItem('morphine', function(source)
	local xPlayer = HHCore.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('morphine', 1)

	TriggerClientEvent('hhrp-hospital:items:morphine', source)
end)
