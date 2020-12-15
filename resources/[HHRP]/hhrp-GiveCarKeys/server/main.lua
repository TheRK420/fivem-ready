
--- SERVER

HHCore               = nil
local cars 		  = {}

TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)

HHCore.RegisterServerCallback('hhrp-givecarkeys:requestPlayerCars', function(source, cb, plate)

	local xPlayer = HHCore.GetPlayerFromId(source)

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

RegisterServerEvent('hhrp-givecarkeys:frommenu')
AddEventHandler('hhrp-givecarkeys:frommenu', function ()
	TriggerClientEvent('hhrp-givecarkeys:keys', source)
end)


RegisterServerEvent('hhrp-givecarkeys:setVehicleOwnedPlayerId')
AddEventHandler('hhrp-givecarkeys:setVehicleOwnedPlayerId', function (playerId, vehicleProps)
	local xPlayer = HHCore.GetPlayerFromId(playerId)

	MySQL.Async.execute('UPDATE owned_vehicles SET owner=@owner WHERE plate=@plate',
	{
		['@owner']   = xPlayer.identifier,
		['@plate']   = vehicleProps.plate
	},

	function (rowsChanged)
		TriggerClientEvent('hhrp:showNotification', playerId, 'You have got a new car with plate ~g~' ..vehicleProps.plate..'!', vehicleProps.plate)

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
	TriggerClientEvent('hhrp-givecarkeys:keys', source)
end)
