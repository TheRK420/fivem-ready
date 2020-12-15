HHCore = nil

TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)

-- Make sure all Vehicles are Stored on restart
MySQL.ready(function()
	if Config.ParkVehicles then
		ParkVehicles()
	else
		print('hhrp_advancedgarage: Parking Vehicles on restart is currently set to false.')
	end
end)

function ParkVehicles()
	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = true WHERE `stored` = @stored', {
		['@stored'] = false
	}, function(rowsChanged)
		if rowsChanged > 0 then
			print(('hhrp_advancedgarage: %s vehicle(s) have been stored!'):format(rowsChanged))
		end
	end)
end

RegisterNetEvent("garages:CheckGarageForVeh")
AddEventHandler("garages:CheckGarageForVeh", function()
    local src = source
    local xPlayer = HHCore.GetPlayerFromId(src)
    local identifier = xPlayer.identifier
    
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @identifier', { ['@identifier'] = identifier }, function(vehicles)
		TriggerClientEvent('phone:Garage', src, vehicles)
		TriggerClientEvent('garages:getVehicles', 'vehicle')
    end)
end)
-- Get Owned Properties
HHCore.RegisterServerCallback('hhrp_advancedgarage:getOwnedProperties', function(source, cb)
	local xPlayer = HHCore.GetPlayerFromId(source)
	local properties = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_properties WHERE owner = @owner', {
		['@owner'] = xPlayer.identifier
	}, function(data)
		for _,v in pairs(data) do
			table.insert(properties, v.name)
		end
		cb(properties)
	end)
end)

-- Fetch Owned Aircrafts
HHCore.RegisterServerCallback('hhrp_advancedgarage:getOwnedAircrafts', function(source, cb)
	local ownedAircrafts = {}
	local xPlayer = HHCore.GetPlayerFromId(source)

	if Config.DontShowPoundCarsInGarage == true then
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', { -- job = NULL
			['@owner'] = xPlayer.identifier,
			['@Type'] = 'aircraft',
			['@job'] = 'civ',
			['@stored'] = true
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedAircrafts, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedAircrafts)
		end)
	else
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job', { -- job = NULL
			['@owner'] = xPlayer.identifier,
			['@Type'] = 'aircraft',
			['@job'] = 'civ'
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedAircrafts, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedAircrafts)
		end)
	end
end)

-- Fetch Owned Boats
HHCore.RegisterServerCallback('hhrp_advancedgarage:getOwnedBoats', function(source, cb)
	local ownedBoats = {}
	local xPlayer = HHCore.GetPlayerFromId(source)

	if Config.DontShowPoundCarsInGarage == true then
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', { -- job = NULL
			['@owner'] = xPlayer.identifier,
			['@Type'] = 'boat',
			['@job'] = 'civ',
			['@stored'] = true
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedBoats, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedBoats)
		end)
	else
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job', { -- job = NULL
			['@owner'] = xPlayer.identifier,
			['@Type'] = 'boat',
			['@job'] = 'civ'
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedBoats, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedBoats)
		end)
	end
end)

-- Fetch Owned Cars
--[[ HHCore.RegisterServerCallback('hhrp_advancedgarage:getOwnedCars', function(source, cb)
	local ownedCars = {}
	local xPlayer = HHCore.GetPlayerFromId(source)

	if Config.DontShowPoundCarsInGarage == true then
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', { -- job = NULL
			['@owner'] = xPlayer.identifier,
			['@Type'] = 'car',
			['@job'] = 'civ',
			['@stored'] = true
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedCars, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedCars)
		end)
	else
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job', { -- job = NULL
			['@owner'] = xPlayer.identifier,
			['@Type'] = 'car',
			['@job'] = 'civ'
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedCars, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedCars)
		end)
	end
end) ]]

-- Store Vehicles
--[[ HHCore.RegisterServerCallback('hhrp_advancedgarage:storeVehicle', function (source, cb, vehicleProps , damage)
	local ownedCars = {}
	local vehplate = vehicleProps.plate:match("^%s*(.-)%s*$")
	local vehiclemodel = vehicleProps.model
	local xPlayer = HHCore.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND plate = @plate AND damage = @damage', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = vehicleProps.plate
	}, function (result)
		if result[1] ~= nil then
			local originalvehprops = json.decode(result[1].vehicle)
			if originalvehprops.model == vehiclemodel then
				MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE owner = @owner AND plate = @plate AND damage = @damage', {
					['@owner'] = xPlayer.identifier,
					['@vehicle'] = json.encode(vehicleProps),
					['@plate'] = vehicleProps.plate
				}, function (rowsChanged)
					if rowsChanged == 0 then
						print(('hhrp_advancedgarage: %s attempted to store an vehicle they don\'t own!'):format(xPlayer.identifier))
					end
					cb(true)
				end)
			else
				if Config.KickPossibleCheaters == true then
					if Config.UseCustomKickMessage == true then
						print(('hhrp_advancedgarage: %s attempted to Cheat! Tried Storing: ' .. vehiclemodel .. '. Original Vehicle: ' .. originalvehprops.model):format(xPlayer.identifier))
						DropPlayer(source, _U('custom_kick'))
						cb(false)
					else
						print(('hhrp_advancedgarage: %s attempted to Cheat! Tried Storing: ' .. vehiclemodel .. '. Original Vehicle: ' .. originalvehprops.model):format(xPlayer.identifier))
						DropPlayer(source, 'You have been Kicked from the Server for Possible Garage Cheating!!!')
						cb(false)
					end
				else
					print(('hhrp_advancedgarage: %s attempted to Cheat! Tried Storing: ' .. vehiclemodel .. '. Original Vehicle: '.. originalvehprops.model):format(xPlayer.identifier))
					cb(false)
				end
			end
		else
			print(('hhrp_advancedgarage: %s attempted to store an vehicle they don\'t own!'):format(xPlayer.identifier))
			cb(false)
		end
	end)
end) ]]

 --------old----------------------
 HHCore.RegisterServerCallback('hhrp_advancedgarage:getOwnedCars', function(source, cb)
	local ownedCars = {}
	local xPlayer = HHCore.GetPlayerFromId(source)

	if Config.DontShowPoundCarsInGarage == true then
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', { -- job = NULL
			['@owner'] = xPlayer.identifier,
			['@Type'] = 'car',
			['@job'] = 'civ',
			['@stored'] = true
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedCars, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedCars)
		end)
	else
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job', { -- job = NULL
			['@owner'] = xPlayer.identifier,
			['@Type'] = 'car',
			['@job'] = 'civ'
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedCars, {vehicle = vehicle, stored = v.stored, plate = v.plate})
				local p = plate
				print(plate)
			end
			cb(ownedCars)
		end)
	end
end)

--[[ HHCore.RegisterServerCallback('tiger_cardealer:GetOwnedVehByPlate',function(source, cb, plate)	
	local ownedCars = {}
	local xPlayer = HHCore.GetPlayerFromId(source)

	local vehPlate, vehPrice, vehHash, vehFinance, vehRepaytime, stored = nil, 0, nil, 0, 0, 0
	
	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier",{['@identifier'] = xPlayer.identifier}, function(vehData) 
		local vehFound = false
		for k,v in pairs(vehData) do
			if plate == v.plate then
				local vehicle = json.decode(v.vehicle)
				stored			= v.stored
				vehHash 		= vehicle.model
				vehPrice 		= v.paidprice
				vehPlate 		= v.plate
				vehFinance 		= v.finance
				vehRepaytime 	= v.repaytime
				vehFound 		= true
			end
		end

		for k,v in pairs(vehData) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedCars, {vehicle = vehicle, stored = v.stored, plate = v.plate})
		end
		cb(ownedCars)
	end)
	
end) ]]

-- Store Vehicles
HHCore.RegisterServerCallback('hhrp_advancedgarage:storeVehicle', function (source, cb, vehicleProps)
	local ownedCars = {}
	local vehplate = vehicleProps.plate:match("^%s*(.-)%s*$")
	local vehiclemodel = vehicleProps.model
	local xPlayer = HHCore.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = vehicleProps.plate
	}, function (result)
		if result[1] ~= nil then
			local originalvehprops = json.decode(result[1].vehicle)
			if originalvehprops.model == vehiclemodel then
				MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE owner = @owner AND plate = @plate', {
					['@owner'] = xPlayer.identifier,
					['@vehicle'] = json.encode(vehicleProps),
					['@plate'] = vehicleProps.plate
				}, function (rowsChanged)
					if rowsChanged == 0 then
						print('hi')
						print(('hhrp_advancedgarage: %s attempted to store an vehicle they don\'t own!'):format(xPlayer.identifier))
					end
					cb(true)
				end)
			else
				if Config.KickPossibleCheaters == true then
					if Config.UseCustomKickMessage == true then
						print(('hhrp_advancedgarage: %s attempted to Cheat! Tried Storing: ' .. vehiclemodel .. '. Original Vehicle: ' .. originalvehprops.model):format(xPlayer.identifier))
						DropPlayer(source, _U('custom_kick'))
						cb(false)
					else
						print(('hhrp_advancedgarage: %s attempted to Cheat! Tried Storing: ' .. vehiclemodel .. '. Original Vehicle: ' .. originalvehprops.model):format(xPlayer.identifier))
						DropPlayer(source, 'You have been Kicked from the Server for Possible Garage Cheating!!!')
						cb(false)
					end
				else
					print(('hhrp_advancedgarage: %s attempted to Cheat! Tried Storing: ' .. vehiclemodel .. '. Original Vehicle: '.. originalvehprops.model):format(xPlayer.identifier))
					cb(false)
				end
			end
		else
			print('why')
			--print(('hhrp_advancedgarage: %s attempted to store an vehicle they don\'t own!'):format(xPlayer.identifier))
			cb(false)
		end
	end)
end)
 ---------------------------------
-- Fetch Pounded Aircrafts
HHCore.RegisterServerCallback('hhrp_advancedgarage:getOutOwnedAircrafts', function(source, cb)
	local ownedAircrafts = {}
	local xPlayer = HHCore.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', { -- job = NULL
		['@owner'] = xPlayer.identifier,
		['@Type'] = 'aircraft',
		['@job'] = 'civ',
		['@stored'] = false
	}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedAircrafts, vehicle)
		end
		cb(ownedAircrafts)
	end)
end)

-- Fetch Pounded Boats
HHCore.RegisterServerCallback('hhrp_advancedgarage:getOutOwnedBoats', function(source, cb)
	local ownedBoats = {}
	local xPlayer = HHCore.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', { -- job = NULL
		['@owner'] = xPlayer.identifier,
		['@Type'] = 'boat',
		['@job'] = 'civ',
		['@stored'] = false
	}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedBoats, vehicle)
		end
		cb(ownedBoats)
	end)
end)

-- Fetch Pounded Cars
HHCore.RegisterServerCallback('hhrp_advancedgarage:getOutOwnedCars', function(source, cb)
	local ownedCars = {}
	local xPlayer = HHCore.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', { -- job = NULL
		['@owner'] = xPlayer.identifier,
		['@Type'] = 'car',
		['@job'] = 'civ',
		['@stored'] = false
	}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedCars, vehicle)
		end
		cb(ownedCars)
	end)
end)

-- Fetch Pounded Policing Vehicles
HHCore.RegisterServerCallback('hhrp_advancedgarage:getOutOwnedPolicingCars', function(source, cb)
	local ownedPolicingCars = {}
	local xPlayer = HHCore.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND job = @job AND `stored` = @stored', {
		['@owner'] = xPlayer.identifier,
		['@job'] = 'police',
		['@stored'] = false
	}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedPolicingCars, vehicle)
		end
		cb(ownedPolicingCars)
	end)
end)

-- Fetch Pounded Ambulance Vehicles
HHCore.RegisterServerCallback('hhrp_advancedgarage:getOutOwnedAmbulanceCars', function(source, cb)
	local ownedAmbulanceCars = {}
	local xPlayer = HHCore.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND job = @job AND `stored` = @stored', {
		['@owner'] = xPlayer.identifier,
		['@job'] = 'ambulance',
		['@stored'] = false
	}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedAmbulanceCars, vehicle)
		end
		cb(ownedAmbulanceCars)
	end)
end)

-- Check Money for Pounded Aircrafts
HHCore.RegisterServerCallback('hhrp_advancedgarage:checkMoneyAircrafts', function(source, cb)
	local xPlayer = HHCore.GetPlayerFromId(source)
	if xPlayer.getMoney() >= Config.AircraftPoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

-- Check Money for Pounded Boats
HHCore.RegisterServerCallback('hhrp_advancedgarage:checkMoneyBoats', function(source, cb)
	local xPlayer = HHCore.GetPlayerFromId(source)
	if xPlayer.getMoney() >= Config.BoatPoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

-- Check Money for Pounded Cars
HHCore.RegisterServerCallback('hhrp_advancedgarage:checkMoneyCars', function(source, cb)
	local xPlayer = HHCore.GetPlayerFromId(source)
	if xPlayer.getMoney() >= Config.CarPoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

-- Check Money for Pounded Policing
HHCore.RegisterServerCallback('hhrp_advancedgarage:checkMoneyPolicing', function(source, cb)
	local xPlayer = HHCore.GetPlayerFromId(source)
	if xPlayer.getMoney() >= Config.PolicingPoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

-- Check Money for Pounded Ambulance
HHCore.RegisterServerCallback('hhrp_advancedgarage:checkMoneyAmbulance', function(source, cb)
	local xPlayer = HHCore.GetPlayerFromId(source)
	if xPlayer.getMoney() >= Config.AmbulancePoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

-- Pay for Pounded Aircrafts
RegisterServerEvent('hhrp_advancedgarage:payAircraft')
AddEventHandler('hhrp_advancedgarage:payAircraft', function()
	local xPlayer = HHCore.GetPlayerFromId(source)
	xPlayer.removeMoney(Config.AircraftPoundPrice)
	TriggerClientEvent('HHCore:showNotification', source, _U('you_paid') .. Config.AircraftPoundPrice)

	if Config.GiveSocietyMoney then
		TriggerEvent('hhrp_addonaccount:getSharedAccount', 'society_mechanic', function(account)
			account.addMoney(Config.AircraftPoundPrice)
		end)
	end
end)

-- Pay for Pounded Boats
RegisterServerEvent('hhrp_advancedgarage:payBoat')
AddEventHandler('hhrp_advancedgarage:payBoat', function()
	local xPlayer = HHCore.GetPlayerFromId(source)
	xPlayer.removeMoney(Config.BoatPoundPrice)
	TriggerClientEvent('HHCore:showNotification', source, _U('you_paid') .. Config.BoatPoundPrice)

	if Config.GiveSocietyMoney then
		TriggerEvent('hhrp_addonaccount:getSharedAccount', 'society_mechanic', function(account)
			account.addMoney(Config.BoatPoundPrice)
		end)
	end
end)

-- Pay for Pounded Cars
RegisterServerEvent('hhrp_advancedgarage:payCar')
AddEventHandler('hhrp_advancedgarage:payCar', function()
	local xPlayer = HHCore.GetPlayerFromId(source)
	xPlayer.removeMoney(Config.CarPoundPrice)
	TriggerClientEvent('HHCore:showNotification', source, _U('you_paid') .. Config.CarPoundPrice)

	if Config.GiveSocietyMoney then
		TriggerEvent('hhrp_addonaccount:getSharedAccount', 'society_mechanic', function(account)
			account.addMoney(Config.CarPoundPrice)
		end)
	end
end)

-- Pay for Pounded Policing
RegisterServerEvent('hhrp_advancedgarage:payPolicing')
AddEventHandler('hhrp_advancedgarage:payPolicing', function()
	local xPlayer = HHCore.GetPlayerFromId(source)
	xPlayer.removeMoney(Config.PolicingPoundPrice)
	TriggerClientEvent('HHCore:showNotification', source, _U('you_paid') .. Config.PolicingPoundPrice)

	if Config.GiveSocietyMoney then
		TriggerEvent('hhrp_addonaccount:getSharedAccount', 'society_mechanic', function(account)
			account.addMoney(Config.PolicingPoundPrice)
		end)
	end
end)

-- Pay for Pounded Ambulance
RegisterServerEvent('hhrp_advancedgarage:payAmbulance')
AddEventHandler('hhrp_advancedgarage:payAmbulance', function()
	local xPlayer = HHCore.GetPlayerFromId(source)
	xPlayer.removeMoney(Config.AmbulancePoundPrice)
	TriggerClientEvent('HHCore:showNotification', source, _U('you_paid') .. Config.AmbulancePoundPrice)

	if Config.GiveSocietyMoney then
		TriggerEvent('hhrp_addonaccount:getSharedAccount', 'society_mechanic', function(account)
			account.addMoney(Config.AmbulancePoundPrice)
		end)
	end
end)

-- Pay to Return Broken Vehicles
RegisterServerEvent('hhrp_advancedgarage:payhealth')
AddEventHandler('hhrp_advancedgarage:payhealth', function(price)
	local xPlayer = HHCore.GetPlayerFromId(source)
	xPlayer.removeMoney(price)
	TriggerClientEvent('HHCore:showNotification', source, _U('you_paid') .. price)

	if Config.GiveSocietyMoney then
		TriggerEvent('hhrp_addonaccount:getSharedAccount', 'society_mechanic', function(account)
			account.addMoney(price)
		end)
	end
end)

-- Modify State of Vehicles
RegisterServerEvent('hhrp_advancedgarage:setVehicleState')
AddEventHandler('hhrp_advancedgarage:setVehicleState', function(plate, state, damage)
	local xPlayer = HHCore.GetPlayerFromId(source)

	damage = damage or nil

	if damage ~= nil then

		MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored, damage = @damage, body_damage = @bd, engine_damage = @ed WHERE plate = @plate', {
			['@stored'] = state,
			['@plate'] = plate,
			['@damage'] = json.encode(damage),
			['@bd'] = damage.engineHealth,
			['@ed'] = damage.bodyHealth
		}, function(rowsChanged)
			if rowsChanged == 0 then
				print(('hhrp_advancedgarage: %s exploited the garage!'):format(xPlayer.identifier))
			end
		end)
	else

		MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored, body_damage = @bd, engine_damage = @ed WHERE plate = @plate', {
			['@stored'] = state,
			['@plate'] = plate,
			['@bd'] = 1000,
			['@ed'] = 1000
		}, function(rowsChanged)
			if rowsChanged == 0 then
				print(('hhrp_advancedgarage: %s exploited the garage!'):format(xPlayer.identifier))
			end
		end)

	end
end)


HHCore.RegisterServerCallback('hhrp_advancedgarage:getVehicledamage', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		if result[1].damage ~= nil then
			cb(json.decode(result[1].damage))
			return
		else
			cb(nil)
			return
		end
	end)
end)
------------old-------------
--[[ RegisterServerEvent('hhrp_advancedgarage:setVehicleState')
AddEventHandler('hhrp_advancedgarage:setVehicleState', function(plate, state)
	local xPlayer = HHCore.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE plate = @plate', {
		['@stored'] = state,
		['@plate'] = plate
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('hhrp_advancedgarage: %s exploited the garage!'):format(xPlayer.identifier))
		end
	end)
end) ]]
-------------------------------