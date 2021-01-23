RKCore = nil

TriggerEvent("rk:getSharedObject", function(response)
    RKCore = response
end)

local VehiclesForSale = 0

RKCore.RegisterServerCallback("rk-qalle-sellvehicles:retrieveVehicles", function(source, cb)
	local src = source
	local xPlayer = RKCore.GetPlayerFromId(src)["identifier"]

    MySQL.Async.fetchAll("SELECT seller, vehicleProps, price FROM vehicles_for_sale", {}, function(result)
        local vehicleTable = {}

        VehiclesForSale = 0

        if result[1] ~= nil then
            for i = 1, #result, 1 do
                VehiclesForSale = VehiclesForSale + 1

				local seller = false

				if result[i]["seller"] == identifier then
					seller = true
				end

                table.insert(vehicleTable, { ["price"] = result[i]["price"], ["vehProps"] = json.decode(result[i]["vehicleProps"]), ["owner"] = seller })
            end
        end

        cb(vehicleTable)
    end)
end)

RKCore.RegisterServerCallback("rk-qalle-sellvehicles:isVehicleValid", function(source, cb, vehicleProps, price)
	local src = source
	local xPlayer = RKCore.GetPlayerFromId(src)
    
    local plate = vehicleProps["plate"]

	local isFound = false

	RetrievePlayerVehicles(xPlayer.identifier, function(ownedVehicles)

		for id, v in pairs(ownedVehicles) do

			if Trim(plate) == Trim(v.plate) and v.finance == 0 and #Config.VehiclePositions ~= VehiclesForSale then
                
                MySQL.Async.execute("INSERT INTO vehicles_for_sale (seller, vehicleProps, price) VALUES (@sellerIdentifier, @vehProps, @vehPrice)",
                    {
						["@sellerIdentifier"] = xPlayer["identifier"],
                        ["@vehProps"] = json.encode(vehicleProps),
                        ["@vehPrice"] = price
                    }
                )

				MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', { ["@plate"] = plate})

                TriggerClientEvent("rk-qalle-sellvehicles:refreshVehicles", -1)

				isFound = true
				break

			end		

		end

		cb(isFound)

	end)
end)

RKCore.RegisterServerCallback("rk-qalle-sellvehicles:buyVehicle", function(source, cb, vehProps, price)
	local src = source
	local xPlayer = RKCore.GetPlayerFromId(src)
    local dat = os.date('%Y-%m-%d')
	local price = price
	local plate = vehProps["plate"]

	if xPlayer.getAccount("bank")["money"] >= price or price == 0 then
		xPlayer.removeAccountMoney("bank", price)

		MySQL.Async.execute("INSERT INTO owned_vehicles (plate, owner, vehicle, paidprice, date) VALUES (@plate, @identifier, @vehProps, @price, @date)",
			{
				["@plate"] = plate,
				["@identifier"] = xPlayer["identifier"],
				["@vehProps"] = json.encode(vehProps),
				["@price"] = price,
				["@date"] = dat
			}
		)

		TriggerClientEvent("rk-qalle-sellvehicles:refreshVehicles", -1)

		MySQL.Async.fetchAll('SELECT seller FROM vehicles_for_sale WHERE vehicleProps LIKE "%' .. plate .. '%"', {}, function(result)
			if result[1] ~= nil and result[1]["seller"] ~= nil then
				UpdateCash(result[1]["seller"], price)
			else
				print("Something went wrong, there was no car.")
			end
		end)

		MySQL.Async.execute('DELETE FROM vehicles_for_sale WHERE vehicleProps LIKE "%' .. plate .. '%"', {})

		cb(true)
	else
		cb(false, xPlayer.getAccount("bank")["money"])
	end
end)

function RetrievePlayerVehicles(newIdentifier, cb)
	local identifier = newIdentifier

	local yourVehicles = {}

	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @identifier", {['@identifier'] = identifier}, function(result) 

		for id, values in pairs(result) do

			local vehicle = json.decode(values.vehicle)
			local plate = values.plate
			local finance = values.finance
			table.insert(yourVehicles, { vehicle = vehicle, plate = plate, finance = finance })
		end

		cb(yourVehicles)

	end)
end

function UpdateCash(identifier, cash)
	local xPlayer = RKCore.GetPlayerFromIdentifier(identifier)

	if xPlayer ~= nil then
		xPlayer.addAccountMoney("bank", cash)

		TriggerClientEvent("rk:showNotification", xPlayer.source, "Someone bought your vehicle and transferred $" .. cash)
	else
--[[ 		MySQL.Async.fetchAll('SELECT bank FROM users WHERE identifier = @identifier', { ["@identifier"] = identifier }, function(result)
			if result[1]["bank"] ~= nil then
				MySQL.Async.execute("UPDATE users SET bank = @newBank WHERE identifier = @identifier",
					{
						["@identifier"] = identifier,
						["@newBank"] = result[1]["bank"] + cash
					}
				)
			end
		end) ]]
		MySQL.Async.fetchScalar('SELECT accounts FROM users WHERE identifier = @identifier', {
			['@identifier'] = identifier
		}, function(accounts)
			if accounts then
				local playerAccounts = json.decode(accounts)

				if playerAccounts and playerAccounts.bank then
					playerAccounts.bank = playerAccounts.bank + cash
					MySQL.Async.execute('UPDATE users SET accounts = @accounts WHERE identifier = @identifier', {
						['@identifier'] = identifier,
						['@accounts'] = json.encode(playerAccounts)
					})
				end
			end
		end)
	end
end

Trim = function(word)
	if word ~= nil then
		return word:match("^%s*(.-)%s*$")
	else
		return nil
	end
end