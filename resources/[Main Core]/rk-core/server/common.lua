RKCore                      = {}
RKCore.Players              = {}
RKCore.UsableItemsCallbacks = {}
RKCore.Items                = {}
RKCore.ServerCallbacks      = {}
RKCore.TimeoutCount         = -1
RKCore.CancelledTimeouts    = {}
RKCore.LastPlayerData       = {}
RKCore.Pickups              = {}
RKCore.PickupId             = 0
RKCore.Jobs                 = {}

AddEventHandler('rk:getSharedObject', function(cb)
	cb(RKCore)
end)

function getSharedObject()
	return RKCore
end

MySQL.ready(function()
	MySQL.Async.fetchAll('SELECT * FROM items', {}, function(result)
		for i=1, #result, 1 do
			RKCore.Items[result[i].name] = {
				label     = result[i].label,
				limit     = result[i].limit,
				rare      = (result[i].rare       == 1 and true or false),
				canRemove = (result[i].can_remove == 1 and true or false),
			}
		end
	end)

	local result = MySQL.Sync.fetchAll('SELECT * FROM jobs', {})

	for i=1, #result do
		RKCore.Jobs[result[i].name] = result[i]
		RKCore.Jobs[result[i].name].grades = {}
	end

	local result2 = MySQL.Sync.fetchAll('SELECT * FROM job_grades', {})

	for i=1, #result2 do
		if RKCore.Jobs[result2[i].job_name] then
			RKCore.Jobs[result2[i].job_name].grades[tostring(result2[i].grade)] = result2[i]
		else
			print(('rk-core: invalid job "%s" from table job_grades ignored!'):format(result2[i].job_name))
		end
	end

	for k,v in pairs(RKCore.Jobs) do
		if next(v.grades) == nil then
			RKCore.Jobs[v.name] = nil
			print(('rk-core: ignoring job "%s" due to missing job grades!'):format(v.name))
		end
	end
end)

AddEventHandler('rk:playerLoaded', function(source)
	local xPlayer         = RKCore.GetPlayerFromId(source)
	local accounts        = {}
	local items           = {}
	local xPlayerAccounts = xPlayer.getAccounts()

	for i=1, #xPlayerAccounts, 1 do
		accounts[xPlayerAccounts[i].name] = xPlayerAccounts[i].money
	end

	RKCore.LastPlayerData[source] = {
		accounts = accounts,
		items    = items
	}
end)

RegisterServerEvent('rk:clientLog')
AddEventHandler('rk:clientLog', function(msg)
	RconPrint(msg .. "\n")
end)

RegisterServerEvent('rk:triggerServerCallback')
AddEventHandler('rk:triggerServerCallback', function(name, requestId, ...)
	local _source = source

	RKCore.TriggerServerCallback(name, requestID, _source, function(...)
		TriggerClientEvent('rk:serverCallback', _source, requestId, ...)
	end, ...)
end)
