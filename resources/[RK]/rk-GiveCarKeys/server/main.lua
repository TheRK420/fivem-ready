
--- SERVER

RKCore               = nil
local cars 		  = {}

TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)

RKCore.RegisterServerCallback('rk-givecarkeys:requestPlayerCars', function(source, cb, plate)

	local xPlayer = RKCore.GetPlayerFromId(source)

	MySQL.Async.fetchAll(
		'SELECT * FROM owned_vehicles WHERE owner = @identifier',
		{
			['@identifier'] = xPlayer.identifier
		},
		function(result)

			local found = false

			for i=1, #result, 1 do

				local vehicleProps = json.decode(result[i].vehicle)

				if trim(vehicleProps.plate) == trim(plate) then
					found = true
					break
				end

			end

			if found then
				cb(true)
			else
				cb(false)
			end

		end
	)
end)

RegisterServerEvent('rk-givecarkeys:frommenu')
AddEventHandler('rk-givecarkeys:frommenu', function ()
	TriggerClientEvent('rk-givecarkeys:keys', source)
end)


RegisterServerEvent('rk-givecarkeys:setVehicleOwnedPlayerId')
AddEventHandler('rk-givecarkeys:setVehicleOwnedPlayerId', function (playerId, vehicleProps)
	local xPlayer = RKCore.GetPlayerFromId(playerId)

	MySQL.Async.execute('UPDATE owned_vehicles SET owner=@owner WHERE plate=@plate',
	{
		['@owner']   = xPlayer.identifier,
		['@plate']   = vehicleProps.plate
	},

	function (rowsChanged)
		TriggerClientEvent('rk:showNotification', playerId, 'You have got a new car with plate ~g~' ..vehicleProps.plate..'!', vehicleProps.plate)

	end)
end)

function trim(s)
    if s ~= nil then
		return s:match("^%s*(.-)%s*$")
	else
		return nil
    end
end



RegisterCommand('transferveh', function(source, args, user)
	TriggerClientEvent('rk-givecarkeys:keys', source)
end)
