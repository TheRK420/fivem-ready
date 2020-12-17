HHCore.RegisterServerCallback('pw-motels:getPlayerDressing', function(source, cb)
	local xPlayer  = HHCore.GetPlayerFromId(source)

	TriggerEvent('HHCore_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local count  = store.count('dressing')
		local labels = {}

		for i=1, count, 1 do
			local entry = store.get('dressing', i)
			table.insert(labels, entry.label)
		end

		cb(labels)
	end)
end)

HHCore.RegisterServerCallback('pw-motels:getPlayerOutfit', function(source, cb, num)
	local xPlayer  = HHCore.GetPlayerFromId(source)

	TriggerEvent('HHCore_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local outfit = store.get('dressing', num)
		cb(outfit.skin)
	end)
end)

RegisterServerEvent('pw-motels:removeOutfit')
AddEventHandler('pw-motels:removeOutfit', function(label)
	local xPlayer = HHCore.GetPlayerFromId(source)

	TriggerEvent('HHCore_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local dressing = store.get('dressing') or {}

		table.remove(dressing, label)
		store.set('dressing', dressing)
	end)
end)