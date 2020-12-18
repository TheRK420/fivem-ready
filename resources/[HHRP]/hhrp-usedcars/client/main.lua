HHCore = nil

PlayerData = {}

Citizen.CreateThread(function()
    while HHCore == nil do
        Citizen.Wait(10)

        TriggerEvent("hhrp:getSharedObject", function(response)
            HHCore = response
        end)
    end

    if HHCore.IsPlayerLoaded() then
		PlayerData = HHCore.GetPlayerData()

		RemoveVehicles()

		Citizen.Wait(500)

		LoadSellPlace()

		SpawnVehicles()
    end
end)

RegisterNetEvent("hhrp:playerLoaded")
AddEventHandler("hhrp:playerLoaded", function(response)
	PlayerData = response
	
	LoadSellPlace()

	SpawnVehicles()
end)

RegisterNetEvent("hhrp-qalle-sellvehicles:refreshVehicles")
AddEventHandler("hhrp-qalle-sellvehicles:refreshVehicles", function()
	RemoveVehicles()

	Citizen.Wait(500)

	SpawnVehicles()
end)

function LoadSellPlace()
	Citizen.CreateThread(function()

		local SellPos = Config.SellPosition

		local Blip = AddBlipForCoord(SellPos["x"], SellPos["y"], SellPos["z"])
		SetBlipSprite (Blip, 147)
		SetBlipDisplay(Blip, 4)
		SetBlipScale  (Blip, 0.8)
		SetBlipColour (Blip, 52)
		SetBlipAsShortRange(Blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Used Cars")
		EndTextCommandSetBlipName(Blip)

		while true do
			local sleepThread = 500

			local ped = PlayerPedId()
			local pedCoords = GetEntityCoords(ped)

			local dstCheck = GetDistanceBetweenCoords(pedCoords, SellPos["x"], SellPos["y"], SellPos["z"], true)

			if dstCheck <= 10.0 then
				sleepThread = 5

				if dstCheck <= 4.2 then
					HHCore.Game.Utils.DrawText3D(SellPos, "[E] Open Menu", 0.4)
					if IsControlJustPressed(0, 38) then
						if IsPedInAnyVehicle(ped, false) then
							OpenSellMenu(GetVehiclePedIsUsing(ped))
						else
							HHCore.ShowNotification("You must sit in a ~g~vehicle")
						end
					end
				end
			end

			for i = 1, #Config.VehiclePositions, 1 do
				if Config.VehiclePositions[i]["entityId"] ~= nil then
					local pedCoords = GetEntityCoords(ped)
					local vehCoords = GetEntityCoords(Config.VehiclePositions[i]["entityId"])

					local dstCheck = GetDistanceBetweenCoords(pedCoords, vehCoords, true)

					if dstCheck <= 2.0 then
						sleepThread = 5

						HHCore.Game.Utils.DrawText3D(vehCoords, "[E] " .. Config.VehiclePositions[i]["price"] .. ":-", 0.4)

						if IsControlJustPressed(0, 38) then
							if IsPedInVehicle(ped, Config.VehiclePositions[i]["entityId"], false) then
								OpenSellMenu(Config.VehiclePositions[i]["entityId"], Config.VehiclePositions[i]["price"], true, Config.VehiclePositions[i]["owner"])
							else
								HHCore.ShowNotification("You must sit in the ~g~vehicle~s~!")
							end
						end
					end
				end
			end

			Citizen.Wait(sleepThread)
		end
	end)
end

function OpenSellMenu(veh, price, buyVehicle, owner)
	local elements = {}

	if not buyVehicle then
		if price ~= nil then
			table.insert(elements, { ["label"] = "Change Price - " .. price .. " :-", ["value"] = "price" })
			table.insert(elements, { ["label"] = "Put out for sale", ["value"] = "sell" })
		else
			table.insert(elements, { ["label"] = "Set Price - :-", ["value"] = "price" })
		end
	else
		table.insert(elements, { ["label"] = "Buy " .. price .. " - :-", ["value"] = "buy" })

		if owner then
			table.insert(elements, { ["label"] = "Remove Vehicle", ["value"] = "remove" })
		end
	end

	HHCore.UI.Menu.Open('default', GetCurrentResourceName(), 'sell_veh',
		{
			title    = "Vehicle Menu",
			align    = 'top-right',
			elements = elements
		},
	function(data, menu)
		local action = data.current.value

		if action == "price" then
			HHCore.UI.Menu.Open('dialog', GetCurrentResourceName(), 'sell_veh_price',
				{
					title = "Vehicle Price"
				},
			function(data2, menu2)

				local vehPrice = tonumber(data2.value)

				menu2.close()
				menu.close()

				OpenSellMenu(veh, vehPrice)
			end, function(data2, menu2)
				menu2.close()
			end)
		elseif action == "sell" then
			local vehProps = HHCore.Game.GetVehicleProperties(veh)

			HHCore.TriggerServerCallback("hhrp-qalle-sellvehicles:isVehicleValid", function(valid)

				if valid then
					DeleteVehicle(veh)
					HHCore.ShowNotification("You put out the vehicle for sale - " .. price .. " :-")
					menu.close()
				else
					HHCore.ShowNotification("You must own the vehicle! or its Finance Isnt Cleared ")
				end
	
			end, vehProps, price)
		elseif action == "buy" then
			HHCore.TriggerServerCallback("hhrp-qalle-sellvehicles:buyVehicle", function(isPurchasable, totalMoney)
				if isPurchasable then
					DeleteVehicle(veh)
					HHCore.ShowNotification("You bought the vehicle for " .. price .. " :-")
					menu.close()
				else
					HHCore.ShowNotification("You don't have enough cash, it's missing " .. price - totalMoney .. " :-")
				end
			end, HHCore.Game.GetVehicleProperties(veh), price)
		elseif action == "remove" then
			HHCore.TriggerServerCallback("hhrp-qalle-sellvehicles:buyVehicle", function(isPurchasable, totalMoney)
				if isPurchasable then
					DeleteVehicle(veh)
					HHCore.ShowNotification("You removed the vehicle")
					menu.close()
				end
			end, HHCore.Game.GetVehicleProperties(veh), 0)
		end
		
	end, function(data, menu)
		menu.close()
	end)
end

function RemoveVehicles()
	local VehPos = Config.VehiclePositions

	for i = 1, #VehPos, 1 do
		local veh, distance = HHCore.Game.GetClosestVehicle(VehPos[i])

		if DoesEntityExist(veh) and distance <= 1.0 then
			DeleteEntity(veh)
		end
	end
end

function SpawnVehicles()
	local VehPos = Config.VehiclePositions

	HHCore.TriggerServerCallback("hhrp-qalle-sellvehicles:retrieveVehicles", function(vehicles)
		for i = 1, #vehicles, 1 do

			local vehicleProps = vehicles[i]["vehProps"]

			LoadModel(vehicleProps["model"])

			VehPos[i]["entityId"] = CreateVehicle(vehicleProps["model"], VehPos[i]["x"], VehPos[i]["y"], VehPos[i]["z"] - 0.975, VehPos[i]["h"], false)
			VehPos[i]["price"] = vehicles[i]["price"]
			VehPos[i]["owner"] = vehicles[i]["owner"]

			HHCore.Game.SetVehicleProperties(VehPos[i]["entityId"], vehicleProps)

			FreezeEntityPosition(VehPos[i]["entityId"], true)

			SetEntityAsMissionEntity(VehPos[i]["entityId"], true, true)
			SetModelAsNoLongerNeeded(vehicleProps["model"])
		end
	end)

end

Citizen.CreateThread(function()
    RequestModel(GetHashKey("ig_bankman"))    
    while not HasModelLoaded(GetHashKey("ig_bankman")) do
        Wait(1)
    end    
    local npc = CreatePed(4, GetHashKey("ig_bankman"), -18.19, -1674.72, 29.491722106934 - 0.90, 0, false, true)
        
	SetEntityHeading(npc,  124.37)
    FreezeEntityPosition(npc, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
end)

LoadModel = function(model)
	while not HasModelLoaded(model) do
		RequestModel(model)

		Citizen.Wait(1)
	end
end
