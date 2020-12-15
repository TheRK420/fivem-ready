HHCore                      = {}
HHCore.Players              = {}
HHCore.UsableItemsCallbacks = {}
HHCore.Items                = {}
HHCore.ServerCallbacks      = {}
HHCore.TimeoutCount         = -1
HHCore.CancelledTimeouts    = {}
HHCore.LastPlayerData       = {}
HHCore.Pickups              = {}
HHCore.PickupId             = 0
HHCore.Jobs                 = {}

AddEventHandler('hhrp:getSharedObject', function(cb)
	cb(HHCore)
end)

function getSharedObject()
	return HHCore
end

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM items', {}, function(result)
		for i=1, #result, 1 do
			HHCore.Items[result[i].name] = {
				label     = result[i].label,
				limit     = result[i].limit,
				rare      = (result[i].rare       == 1 and true or false),
				canRemove = (result[i].can_remove == 1 and true or false),
			}
		end
	end)

	local result = MySQL.Sync.fetchAll('SELECT * FROM jobs', {})

	for i=1, #result do
		HHCore.Jobs[result[i].name] = result[i]
		HHCore.Jobs[result[i].name].grades = {}
	end

	local result2 = MySQL.Sync.fetchAll('SELECT * FROM job_grades', {})

	for i=1, #result2 do
		if HHCore.Jobs[result2[i].job_name] then
			HHCore.Jobs[result2[i].job_name].grades[tostring(result2[i].grade)] = result2[i]
		else
			print(('hhrp-core: invalid job "%s" from table job_grades ignored!'):format(result2[i].job_name))
		end
	end

	for k,v in pairs(HHCore.Jobs) do
		if next(v.grades) == nil then
			HHCore.Jobs[v.name] = nil
			print(('hhrp-core: ignoring job "%s" due to missing job grades!'):format(v.name))
		end
	end
end)

AddEventHandler('hhrp:playerLoaded', function(source)
	local xPlayer         = HHCore.GetPlayerFromId(source)
	local accounts        = {}
	local items           = {}
	local xPlayerAccounts = xPlayer.getAccounts()

	for i=1, #xPlayerAccounts, 1 do
		accounts[xPlayerAccounts[i].name] = xPlayerAccounts[i].money
	end

	HHCore.LastPlayerData[source] = {
		accounts = accounts,
		items    = items
	}
end)

RegisterServerEvent('hhrp:clientLog')
AddEventHandler('hhrp:clientLog', function(msg)
	RconPrint(msg .. "\n")
end)

RegisterServerEvent('hhrp:triggerServerCallback')
AddEventHandler('hhrp:triggerServerCallback', function(name, requestId, ...)
	local _source = source

	HHCore.TriggerServerCallback(name, requestID, _source, function(...)
		TriggerClientEvent('hhrp:serverCallback', _source, requestId, ...)
	end, ...)
end)
