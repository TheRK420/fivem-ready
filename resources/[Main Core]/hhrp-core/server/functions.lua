HHCore.Trace = function(str)
	if Config.EnableDebug then
		print('HHCore> ' .. str)
	end
end

HHCore.SetTimeout = function(msec, cb)
	local id = HHCore.TimeoutCount + 1

	SetTimeout(msec, function()
		if HHCore.CancelledTimeouts[id] then
			HHCore.CancelledTimeouts[id] = nil
		else
			cb()
		end
	end)

	HHCore.TimeoutCount = id

	return id
end

HHCore.ClearTimeout = function(id)
	HHCore.CancelledTimeouts[id] = true
end

HHCore.RegisterServerCallback = function(name, cb)
	HHCore.ServerCallbacks[name] = cb
end

HHCore.TriggerServerCallback = function(name, requestId, source, cb, ...)
	if HHCore.ServerCallbacks[name] ~= nil then
		HHCore.ServerCallbacks[name](source, cb, ...)
	else
		print('hhrp-core: TriggerServerCallback => [' .. name .. '] does not exist')
	end
end

HHCore.SavePlayer = function(xPlayer, cb)
	local asyncTasks = {}
	xPlayer.setLastPosition(xPlayer.getCoords())

	-- User accounts
	for i=1, #xPlayer.accounts, 1 do
		if HHCore.LastPlayerData[xPlayer.source].accounts[xPlayer.accounts[i].name] ~= xPlayer.accounts[i].money then
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
			TriggerEvent("hhrp:money", data2, xPlayer)
			HHCore.LastPlayerData[xPlayer.source].accounts[xPlayer.accounts[i].name] = xPlayer.accounts[i].money
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
		RconPrint('\27[32m[hhrp-core] [Saving Player]\27[0m ' .. xPlayer.name .. "^7\n")

		if cb ~= nil then
			cb()
		end
	end)
end

HHCore.SavePlayers = function(cb)
	local asyncTasks = {}
	local xPlayers   = HHCore.GetPlayers()

	for i=1, #xPlayers, 1 do
		table.insert(asyncTasks, function(cb)
			local xPlayer = HHCore.GetPlayerFromId(xPlayers[i])
			HHCore.SavePlayer(xPlayer, cb)
		end)
	end

	Async.parallelLimit(asyncTasks, 8, function(results)
		RconPrint('\27[32m[hhrp-core] [Saving All Players]\27[0m' .. "\n")

		if cb ~= nil then
			cb()
		end
	end)
end

HHCore.StartDBSync = function()
	function saveData()
		HHCore.SavePlayers()
		SetTimeout(10 * 60 * 1000, saveData)
	end

	SetTimeout(10 * 60 * 1000, saveData)
end

HHCore.GetPlayers = function()
	local sources = {}

	for k,v in pairs(HHCore.Players) do
		table.insert(sources, k)
	end

	return sources
end


HHCore.GetPlayerFromId = function(source)
	return HHCore.Players[tonumber(source)]
end

HHCore.GetPlayerFromIdentifier = function(identifier)
	for k,v in pairs(HHCore.Players) do
		if v.identifier == identifier then
			return v
		end
	end
end

HHCore.RegisterUsableItem = function(item, cb)
	HHCore.UsableItemsCallbacks[item] = cb
end

HHCore.UseItem = function(source, item)
	HHCore.UsableItemsCallbacks[item](source)
end

HHCore.GetItemLabel = function(item)
	if HHCore.Items[item] ~= nil then
		return HHCore.Items[item].label
	end
end

HHCore.CreatePickup = function(type, name, count, label, player)
	local pickupId = (HHCore.PickupId == 65635 and 0 or HHCore.PickupId + 1)

	HHCore.Pickups[pickupId] = {
		type  = type,
		name  = name,
		count = count
	}

	TriggerClientEvent('hhrp:pickup', -1, pickupId, label, player)
	HHCore.PickupId = pickupId
end

HHCore.DoesJobExist = function(job, grade)
	grade = tostring(grade)

	if job and grade then
		if HHCore.Jobs[job] and HHCore.Jobs[job].grades[grade] then
			return true
		end
	end

	return false
end