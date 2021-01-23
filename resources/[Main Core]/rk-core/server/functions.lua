RKCore.Trace = function(str)
	if Config.EnableDebug then
		print('RKCore> ' .. str)
	end
end

RKCore.SetTimeout = function(msec, cb)
	local id = RKCore.TimeoutCount + 1

	SetTimeout(msec, function()
		if RKCore.CancelledTimeouts[id] then
			RKCore.CancelledTimeouts[id] = nil
		else
			cb()
		end
	end)

	RKCore.TimeoutCount = id

	return id
end

RKCore.ClearTimeout = function(id)
	RKCore.CancelledTimeouts[id] = true
end

RKCore.RegisterServerCallback = function(name, cb)
	RKCore.ServerCallbacks[name] = cb
end

RKCore.TriggerServerCallback = function(name, requestId, source, cb, ...)
	if RKCore.ServerCallbacks[name] ~= nil then
		RKCore.ServerCallbacks[name](source, cb, ...)
	else
		print('rk-core: TriggerServerCallback => [' .. name .. '] does not exist')
	end
end

RKCore.SavePlayer = function(xPlayer, cb)
	local asyncTasks = {}
	xPlayer.setLastPosition(xPlayer.getCoords())

	-- User accounts
	for i=1, #xPlayer.accounts, 1 do
		if RKCore.LastPlayerData[xPlayer.source].accounts[xPlayer.accounts[i].name] ~= xPlayer.accounts[i].money then
			table.insert(asyncTasks, function(cb)
				MySQL.Async.execute('UPDATE user_accounts SET money = @money WHERE identifier = @identifier AND name = @name', {
					['@money']      = xPlayer.accounts[i].money,
					['@identifier'] = xPlayer.identifier,
					['@name']       = xPlayer.accounts[i].name
				}, function(rowsChanged)
					cb()
				end)
			end)
			local data2 = xPlayer.accounts[i].money
			TriggerEvent("rk:money", data2, xPlayer)
			RKCore.LastPlayerData[xPlayer.source].accounts[xPlayer.accounts[i].name] = xPlayer.accounts[i].money
		end
	end
	
	-- Job, loadout and position
	table.insert(asyncTasks, function(cb)
		MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @job_grade, loadout = @loadout, position = @position WHERE identifier = @identifier', {
			['@job']        = xPlayer.job.name,
			['@job_grade']  = xPlayer.job.grade,
			['@loadout']    = json.encode(xPlayer.getLoadout()),
			['@position']   = json.encode(xPlayer.getLastPosition()),
			['@identifier'] = xPlayer.identifier
		}, function(rowsChanged)
			cb()
		end)
	end)

	Async.parallel(asyncTasks, function(results)
		RconPrint('\27[32m[rk-core] [Saving Player]\27[0m ' .. xPlayer.name .. "^7\n")

		if cb ~= nil then
			cb()
		end
	end)
end

RKCore.SavePlayers = function(cb)
	local asyncTasks = {}
	local xPlayers   = RKCore.GetPlayers()

	for i=1, #xPlayers, 1 do
		table.insert(asyncTasks, function(cb)
			local xPlayer = RKCore.GetPlayerFromId(xPlayers[i])
			RKCore.SavePlayer(xPlayer, cb)
		end)
	end

	Async.parallelLimit(asyncTasks, 8, function(results)
		RconPrint('\27[32m[rk-core] [Saving All Players]\27[0m' .. "\n")

		if cb ~= nil then
			cb()
		end
	end)
end

RKCore.StartDBSync = function()
	function saveData()
		RKCore.SavePlayers()
		SetTimeout(10 * 60 * 1000, saveData)
	end

	SetTimeout(10 * 60 * 1000, saveData)
end

RKCore.GetPlayers = function()
	local sources = {}

	for k,v in pairs(RKCore.Players) do
		table.insert(sources, k)
	end

	return sources
end


RKCore.GetPlayerFromId = function(source)
	return RKCore.Players[tonumber(source)]
end

RKCore.GetPlayerFromIdentifier = function(identifier)
	for k,v in pairs(RKCore.Players) do
		if v.identifier == identifier then
			return v
		end
	end
end

RKCore.RegisterUsableItem = function(item, cb)
	RKCore.UsableItemsCallbacks[item] = cb
end

RKCore.UseItem = function(source, item)
	RKCore.UsableItemsCallbacks[item](source)
end

RKCore.GetItemLabel = function(item)
	if RKCore.Items[item] ~= nil then
		return RKCore.Items[item].label
	end
end

RKCore.CreatePickup = function(type, name, count, label, player)
	local pickupId = (RKCore.PickupId == 65635 and 0 or RKCore.PickupId + 1)

	RKCore.Pickups[pickupId] = {
		type  = type,
		name  = name,
		count = count
	}

	TriggerClientEvent('rk:pickup', -1, pickupId, label, player)
	RKCore.PickupId = pickupId
end

RKCore.DoesJobExist = function(job, grade)
	grade = tostring(grade)

	if job and grade then
		if RKCore.Jobs[job] and RKCore.Jobs[job].grades[grade] then
			return true
		end
	end

	return false
end