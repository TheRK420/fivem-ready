local HasAlreadyEnteredMarker, OnJob, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, IsDead, CurrentActionData = false, false, false, false, false, false, {}
local CurrentCustomer, CurrentCustomerBlip, DestinationBlip, targetCoords, LastZone, CurrentAction, CurrentActionMsg

RKCore = nil

Citizen.CreateThread(function()
	while RKCore == nil do
		TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)
		Citizen.Wait(0)
	end

	while RKCore.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	RKCore.PlayerData = RKCore.GetPlayerData()
end)

function DrawSub(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, 1)
end

function ShowLoadingPromt(msg, time, type)
	Citizen.CreateThread(function()
		Citizen.Wait(0)

		BeginTextCommandBusyString('STRING')
		AddTextComponentSubstringPlayerName(msg)
		EndTextCommandBusyString(type)
		Citizen.Wait(time)

		RemoveLoadingPrompt()
	end)
end

function GetRandomWalkingNPC()
	local search = {}
	local peds   = RKCore.Game.GetPeds()

	for i=1, #peds, 1 do
		if IsPedHuman(peds[i]) and IsPedWalking(peds[i]) and not IsPedAPlayer(peds[i]) then
			table.insert(search, peds[i])
		end
	end

	if #search > 0 then
		return search[GetRandomIntInRange(1, #search)]
	end

	for i=1, 250, 1 do
		local ped = GetRandomPedAtCoord(0.0, 0.0, 0.0, math.huge + 0.0, math.huge + 0.0, math.huge + 0.0, 26)

		if DoesEntityExist(ped) and IsPedHuman(ped) and IsPedWalking(ped) and not IsPedAPlayer(ped) then
			table.insert(search, ped)
		end
	end

	if #search > 0 then
		return search[GetRandomIntInRange(1, #search)]
	end
end

function ClearCurrentMission()
	if DoesBlipExist(CurrentCustomerBlip) then
		RemoveBlip(CurrentCustomerBlip)
	end

	if DoesBlipExist(DestinationBlip) then
		RemoveBlip(DestinationBlip)
	end

	CurrentCustomer           = nil
	CurrentCustomerBlip       = nil
	DestinationBlip           = nil
	IsNearCustomer            = false
	CustomerIsEnteringVehicle = false
	CustomerEnteredVehicle    = false
	targetCoords              = nil
end

function StartTaxiJob()
	ShowLoadingPromt(_U('taking_service'), 5000, 3)
	ClearCurrentMission()

	OnJob = true
end

function StopTaxiJob()
	local playerPed = PlayerPedId()

	if IsPedInAnyVehicle(playerPed, false) and CurrentCustomer ~= nil then
		local vehicle = GetVehiclePedIsIn(playerPed,  false)
		TaskLeaveVehicle(CurrentCustomer,  vehicle,  0)

		if CustomerEnteredVehicle then
			TaskGoStraightToCoord(CurrentCustomer,  targetCoords.x,  targetCoords.y,  targetCoords.z,  1.0,  -1,  0.0,  0.0)
		end
	end

	ClearCurrentMission()
	OnJob = false
	DrawSub(_U('mission_complete'), 5000)
end

function OpenCloakroom()
	RKCore.UI.Menu.CloseAll()

	RKCore.UI.Menu.Open('default', GetCurrentResourceName(), 'taxi_cloakroom',
	{
		title    = _U('cloakroom_menu'),
		align    = 'top-left',
		elements = {
			{ label = _U('wear_citizen'), value = 'wear_citizen' },
			{ label = _U('wear_work'),    value = 'wear_work'}
		}
	}, function(data, menu)
		if data.current.value == 'wear_citizen' then
			RKCore.TriggerServerCallback('rk_skin:getPlayerSkin', function(skin)
				TriggerEvent('skinchanger:loadSkin', skin)
			end)
		elseif data.current.value == 'wear_work' then
			RKCore.TriggerServerCallback('rk_skin:getPlayerSkin', function(skin, jobSkin)
				if skin.sex == 0 then
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
				else
					TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
				end
			end)
		end
	end, function(data, menu)
		menu.close()

		CurrentAction     = 'cloakroom'
		CurrentActionMsg  = _U('cloakroom_prompt')
		CurrentActionData = {}
	end)
end


function OpenVehicleSpawnerMenu()
	RKCore.UI.Menu.CloseAll()

	local elements = {}

	if Config.EnableSocietyOwnedVehicles then

		RKCore.TriggerServerCallback('rk-society:getVehiclesInGarage', function(vehicles)

			for i=1, #vehicles, 1 do
				table.insert(elements, {
					label = GetDisplayNameFromVehicleModel(vehicles[i].model) .. ' [' .. vehicles[i].plate .. ']',
					value = vehicles[i]
				})
			end

			RKCore.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
			{
				title    = _U('spawn_veh'),
				align    = 'top-left',
				elements = elements
			}, function(data, menu)
				if not RKCore.Game.IsSpawnPointClear(Config.Zones.VehicleSpawnPoint.Pos, 5.0) then
					RKCore.ShowNotification(_U('spawnpoint_blocked'))
					return
				end

				menu.close()

				local vehicleProps = data.current.value
				RKCore.Game.SpawnVehicle(vehicleProps.model, Config.Zones.VehicleSpawnPoint.Pos, Config.Zones.VehicleSpawnPoint.Heading, function(vehicle)
					RKCore.Game.SetVehicleProperties(vehicle, vehicleProps)
					local playerPed = PlayerPedId()
					TaskWarpPedIntoVehicle(playerPed, vehicle, -1)

					TriggerEvent('keys:addNew',vehicle,GetVehicleNumberPlateText(vehicle))

				end)

				TriggerServerEvent('rk-society:removeVehicleFromGarage', 'taxi', vehicleProps)

			end, function(data, menu)
				CurrentAction     = 'vehicle_spawner'
				CurrentActionMsg  = _U('spawner_prompt')
				CurrentActionData = {}

				menu.close()
			end)
		end, 'taxi')

	else -- not society vehicles

		RKCore.UI.Menu.Open('default', GetCurrentResourceName(), 'vehicle_spawner',
		{
			title		= _U('spawn_veh'),
			align		= 'top-left',
			elements	= Config.AuthorizedVehicles
		}, function(data, menu)
			if not RKCore.Game.IsSpawnPointClear(Config.Zones.VehicleSpawnPoint.Pos, 5.0) then
				RKCore.ShowNotification(_U('spawnpoint_blocked'))
				return
			end

			menu.close()
			RKCore.Game.SpawnVehicle(data.current.model, Config.Zones.VehicleSpawnPoint.Pos, Config.Zones.VehicleSpawnPoint.Heading, function(vehicle)
				local playerPed = PlayerPedId()
				TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
				SetVehicleNumberPlateText(vehicle, 'TAXI')
			end)
			TriggerEvent('notification', 'Vehicle Spawned', 1)
		end, function(data, menu)
			CurrentAction     = 'vehicle_spawner'
			CurrentActionMsg  = _U('spawner_prompt')
			CurrentActionData = {}

			menu.close()
		end)
	end
end

function DeleteJobVehicle()
	local playerPed = PlayerPedId()

	if Config.EnableSocietyOwnedVehicles then
		local vehicleProps = RKCore.Game.GetVehicleProperties(CurrentActionData.vehicle)
		TriggerServerEvent('rk-society:putVehicleInGarage', 'taxi', vehicleProps)
		RKCore.Game.DeleteVehicle(CurrentActionData.vehicle)
	else
		if IsInAuthorizedVehicle() then
			RKCore.Game.DeleteVehicle(CurrentActionData.vehicle)

			if Config.MaxInService ~= -1 then
				TriggerServerEvent('rk_service:disableService', 'taxi')
			end
		else
			RKCore.ShowNotification(_U('only_taxi'))
		end
	end
end

function OpenTaxiActionsMenu()
	local elements = {
		-- {label = _U('deposit_stock'), value = 'put_stock'},
	 {label = _U('take_stock'), value = 'get_stock'}
	}

	if Config.EnablePlayerManagement and RKCore.PlayerData.job ~= nil and RKCore.PlayerData.job.grade_name == 'boss' then
		table.insert(elements, {label = _U('boss_actions'), value = 'boss_actions'})
	end

	RKCore.UI.Menu.CloseAll()

	RKCore.UI.Menu.Open('default', GetCurrentResourceName(), 'taxi_actions', {
		title    = 'Taxi',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		--if data.current.value == 'put_stock' then
			--OpenPutStocksMenu()
		if data.current.value == 'get_stock' then
			TriggerEvent("server-inventory-open", "1", "Taxi_inventory_items")
			--OpenGetStocksMenu()
		elseif data.current.value == 'boss_actions' then
			TriggerEvent('rk-society:openBossMenu', 'taxi', function(data, menu)
				menu.close()
			end)
		end

	end, function(data, menu)
		menu.close()

		CurrentAction     = 'taxi_actions_menu'
		CurrentActionMsg  = _U('press_to_open')
		CurrentActionData = {}
	end)
end

function OpenMobileTaxiActionsMenu()
	RKCore.UI.Menu.CloseAll()

	RKCore.UI.Menu.Open('default', GetCurrentResourceName(), 'mobile_taxi_actions', {
		title    = 'Taxi',
		align    = 'top-left',
		elements = {
			{label = _U('billing'),   value = 'billing'},
			{label = _U('start_job'), value = 'start_job'}
	}}, function(data, menu)
		if data.current.value == 'billing' then

			RKCore.UI.Menu.Open('dialog', GetCurrentResourceName(), 'billing', {
				title = _U('invoice_amount')
			}, function(data, menu)

				local amount = tonumber(data.value)
				if amount == nil then
					RKCore.ShowNotification(_U('amount_invalid'))
				else
					menu.close()
					local closestPlayer, closestDistance = RKCore.Game.GetClosestPlayer()
					if closestPlayer == -1 or closestDistance > 3.0 then
						RKCore.ShowNotification(_U('no_players_near'))
					else
						TriggerServerEvent('rk_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_taxi', 'Taxi', amount)
						RKCore.ShowNotification(_U('billing_sent'))
					end

				end

			end, function(data, menu)
				menu.close()
			end)

		elseif data.current.value == 'start_job' then
			if OnJob then
				StopTaxiJob()
			else
				if RKCore.PlayerData.job ~= nil and RKCore.PlayerData.job.name == 'taxi' then
					local playerPed = PlayerPedId()
					local vehicle   = GetVehiclePedIsIn(playerPed, false)

					if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
						if tonumber(RKCore.PlayerData.job.grade) >= 3 then
							StartTaxiJob()
						else
							if IsInAuthorizedVehicle() then
								StartTaxiJob()
							else
								RKCore.ShowNotification(_U('must_in_taxi'))
							end
						end
					else
						if tonumber(RKCore.PlayerData.job.grade) >= 3 then
							RKCore.ShowNotification(_U('must_in_vehicle'))
						else
							RKCore.ShowNotification(_U('must_in_taxi'))
						end
					end
				end
			end
		end
	end, function(data, menu)
		menu.close()
	end)
end

function IsInAuthorizedVehicle()
	local playerPed = PlayerPedId()
	local vehModel  = GetEntityModel(GetVehiclePedIsIn(playerPed, false))

	for i=1, #Config.AuthorizedVehicles, 1 do
		if vehModel == GetHashKey(Config.AuthorizedVehicles[i].model) then
			return true
		end
	end
	
	return false
end

function OpenGetStocksMenu()
	RKCore.TriggerServerCallback('rk_taxijob:getStockItems', function(items)
		local elements = {}

		for i=1, #items, 1 do
			table.insert(elements, {
				label = 'x' .. items[i].count .. ' ' .. items[i].label,
				value = items[i].name
			})
		end

		RKCore.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = 'Taxi Stock',
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			RKCore.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					RKCore.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()

					-- todo: refresh on callback
					TriggerServerEvent('rk_taxijob:getStockItem', itemName, count)
					Citizen.Wait(1000)
					OpenGetStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

function OpenPutStocksMenu()
	RKCore.TriggerServerCallback('rk_taxijob:getPlayerInventory', function(inventory)

		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard', -- not used
					value = item.name
				})
			end
		end

		RKCore.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = _U('inventory'),
			align    = 'top-left',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			RKCore.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = _U('quantity')
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					RKCore.ShowNotification(_U('quantity_invalid'))
				else
					menu2.close()
					menu.close()

					-- todo: refresh on callback
					TriggerServerEvent('rk_taxijob:putStockItems', itemName, count)
					Citizen.Wait(1000)
					OpenPutStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

RegisterNetEvent('rk:playerLoaded')
AddEventHandler('rk:playerLoaded', function(xPlayer)
	RKCore.PlayerData = xPlayer
end)

RegisterNetEvent('rk:setJob')
AddEventHandler('rk:setJob', function(job)
	RKCore.PlayerData.job = job
end)

AddEventHandler('rk_taxijob:hasEnteredMarker', function(zone)
	if zone == 'VehicleSpawner' then
		CurrentAction     = 'vehicle_spawner'
		CurrentActionMsg  = _U('spawner_prompt')
		CurrentActionData = {}
	elseif zone == 'VehicleDeleter' then
		local playerPed = PlayerPedId()
		local vehicle   = GetVehiclePedIsIn(playerPed, false)

		if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
			CurrentAction     = 'delete_vehicle'
			CurrentActionMsg  = _U('store_veh')
			CurrentActionData = { vehicle = vehicle }
		end
	elseif zone == 'TaxiActions' then
		CurrentAction     = 'taxi_actions_menu'
		CurrentActionMsg  = _U('press_to_open')
		CurrentActionData = {}

	elseif zone == 'Cloakroom' then
		CurrentAction     = 'cloakroom'
		CurrentActionMsg  = _U('cloakroom_prompt')
		CurrentActionData = {}
	end
end)

AddEventHandler('rk_taxijob:hasExitedMarker', function(zone)
	RKCore.UI.Menu.CloseAll()
	CurrentAction = nil
end)

RegisterNetEvent('rk_phone:loaded')
AddEventHandler('rk_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = _U('phone_taxi'),
		number     = 'taxi',
		base64Icon = 'data:image/png;base64,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',
	}

	TriggerEvent('rk_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)

-- Create Blips
Citizen.CreateThread(function()
	local blip = AddBlipForCoord(Config.Zones.TaxiActions.Pos.x, Config.Zones.TaxiActions.Pos.y, Config.Zones.TaxiActions.Pos.z)

	SetBlipSprite (blip, 198)
	SetBlipDisplay(blip, 4)
	SetBlipScale  (blip, 0.7)
	SetBlipColour (blip, 5)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(_U('blip_taxi'))
	EndTextCommandSetBlipName(blip)
end)

-- Enter / Exit marker events, and draw markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if RKCore.PlayerData.job and RKCore.PlayerData.job.name == 'taxi' then
			local coords = GetEntityCoords(PlayerPedId())
			local isInMarker, letSleep, currentZone = false, true

			for k,v in pairs(Config.Zones) do
				local distance = GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true)

				if v.Type ~= -1 and distance < Config.DrawDistance then
					letSleep = false
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, false, 2, v.Rotate, nil, nil, false)
				end

				if distance < v.Size.x then
					isInMarker, currentZone = true, k
				end
			end

			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
				HasAlreadyEnteredMarker, LastZone = true, currentZone
				TriggerEvent('rk_taxijob:hasEnteredMarker', currentZone)
			end

			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('rk_taxijob:hasExitedMarker', LastZone)
			end

			if letSleep then
				Citizen.Wait(500)
			end
		else
			Citizen.Wait(1000)
		end
	end
end)

-- Taxi Job
Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if OnJob then
			if CurrentCustomer == nil then
				DrawSub(_U('drive_search_pass'), 5000)

				if IsPedInAnyVehicle(playerPed, false) and GetEntitySpeed(playerPed) > 0 then
					local waitUntil = GetGameTimer() + GetRandomIntInRange(30000, 45000)

					while OnJob and waitUntil > GetGameTimer() do
						Citizen.Wait(0)
					end

					if OnJob and IsPedInAnyVehicle(playerPed, false) and GetEntitySpeed(playerPed) > 0 then
						CurrentCustomer = GetRandomWalkingNPC()

						if CurrentCustomer ~= nil then
							CurrentCustomerBlip = AddBlipForEntity(CurrentCustomer)

							SetBlipAsFriendly(CurrentCustomerBlip, true)
							SetBlipColour(CurrentCustomerBlip, 2)
							SetBlipCategory(CurrentCustomerBlip, 3)
							SetBlipRoute(CurrentCustomerBlip, true)

							SetEntityAsMissionEntity(CurrentCustomer, true, false)
							ClearPedTasksImmediately(CurrentCustomer)
							SetBlockingOfNonTemporaryEvents(CurrentCustomer, true)

							local standTime = GetRandomIntInRange(60000, 180000)
							TaskStandStill(CurrentCustomer, standTime)

							RKCore.ShowNotification(_U('customer_found'))
						end
					end
				end
			else
				if IsPedFatallyInjured(CurrentCustomer) then
					RKCore.ShowNotification(_U('client_unconcious'))

					if DoesBlipExist(CurrentCustomerBlip) then
						RemoveBlip(CurrentCustomerBlip)
					end

					if DoesBlipExist(DestinationBlip) then
						RemoveBlip(DestinationBlip)
					end

					SetEntityAsMissionEntity(CurrentCustomer, false, true)

					CurrentCustomer, CurrentCustomerBlip, DestinationBlip, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, targetCoords = nil, nil, nil, false, false, false, nil
				end

				if IsPedInAnyVehicle(playerPed, false) then
					local vehicle          = GetVehiclePedIsIn(playerPed, false)
					local playerCoords     = GetEntityCoords(playerPed)
					local customerCoords   = GetEntityCoords(CurrentCustomer)
					local customerDistance = #(playerCoords - customerCoords)

					if IsPedSittingInVehicle(CurrentCustomer, vehicle) then
						if CustomerEnteredVehicle then
							local targetDistance = #(playerCoords - targetCoords)

							if targetDistance <= 10.0 then
								TaskLeaveVehicle(CurrentCustomer, vehicle, 0)

								RKCore.ShowNotification(_U('arrive_dest'))

								TaskGoStraightToCoord(CurrentCustomer, targetCoords.x, targetCoords.y, targetCoords.z, 1.0, -1, 0.0, 0.0)
								SetEntityAsMissionEntity(CurrentCustomer, false, true)
								TriggerServerEvent('rk_taxijob:success')
								RemoveBlip(DestinationBlip)

								local scope = function(customer)
									RKCore.SetTimeout(60000, function()
										DeletePed(customer)
									end)
								end

								scope(CurrentCustomer)

								CurrentCustomer, CurrentCustomerBlip, DestinationBlip, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle, targetCoords = nil, nil, nil, false, false, false, nil
							end

							if targetCoords then
								DrawMarker(36, targetCoords.x, targetCoords.y, targetCoords.z + 1.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 234, 223, 72, 155, false, false, 2, true, nil, nil, false)
							end
						else
							RemoveBlip(CurrentCustomerBlip)
							CurrentCustomerBlip = nil
							targetCoords = Config.JobLocations[GetRandomIntInRange(1, #Config.JobLocations)]
							local distance = #(playerCoords - targetCoords)
							while distance < Config.MinimumDistance do
								Citizen.Wait(5)

								targetCoords = Config.JobLocations[GetRandomIntInRange(1, #Config.JobLocations)]
								distance = #(playerCoords - targetCoords)
							end

							local street = table.pack(GetStreetNameAtCoord(targetCoords.x, targetCoords.y, targetCoords.z))
							local msg    = nil

							if street[2] ~= 0 and street[2] ~= nil then
								msg = string.format(_U('take_me_to_near', GetStreetNameFromHashKey(street[1]), GetStreetNameFromHashKey(street[2])))
							else
								msg = string.format(_U('take_me_to', GetStreetNameFromHashKey(street[1])))
							end

							RKCore.ShowNotification(msg)

							DestinationBlip = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

							BeginTextCommandSetBlipName('STRING')
							AddTextComponentSubstringPlayerName('Destination')
							EndTextCommandSetBlipName(blip)
							SetBlipRoute(DestinationBlip, true)

							CustomerEnteredVehicle = true
						end
					else
						DrawMarker(36, customerCoords.x, customerCoords.y, customerCoords.z + 1.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 234, 223, 72, 155, false, false, 2, true, nil, nil, false)

						if not CustomerEnteredVehicle then
							if customerDistance <= 40.0 then

								if not IsNearCustomer then
									RKCore.ShowNotification(_U('close_to_client'))
									IsNearCustomer = true
								end

							end

							if customerDistance <= 20.0 then
								if not CustomerIsEnteringVehicle then
									ClearPedTasksImmediately(CurrentCustomer)

									local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

									for i=maxSeats - 1, 0, -1 do
										if IsVehicleSeatFree(vehicle, i) then
											freeSeat = i
											break
										end
									end

									if freeSeat then
										TaskEnterVehicle(CurrentCustomer, vehicle, -1, freeSeat, 2.0, 0)
										CustomerIsEnteringVehicle = true
									end
								end
							end
						end
					end
				else
					DrawSub(_U('return_to_veh'), 5000)
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction and not IsDead then
			RKCore.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) and RKCore.PlayerData.job and RKCore.PlayerData.job.name == 'taxi' then
				if CurrentAction == 'taxi_actions_menu' then
					OpenTaxiActionsMenu()
				elseif CurrentAction == 'vehicle_spawner' then
					OpenVehicleSpawnerMenu()
				elseif CurrentAction == 'delete_vehicle' then
					DeleteJobVehicle()
				end

				CurrentAction = nil
			end
		end

		if IsControlJustReleased(0, 167) and IsInputDisabled(0) and not IsDead and Config.EnablePlayerManagement and RKCore.PlayerData.job and RKCore.PlayerData.job.name == 'taxi' then
			OpenMobileTaxiActionsMenu()
		end
	end
end)

AddEventHandler('rk:onPlayerDeath', function()
	IsDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
	IsDead = false
end)

------------------------------------------------------------------------------------------------------------------------------------
-- local guiEnabled = false
-- local Total = 10
-- local PerMinute = 1
-- local BaseFare = 10
-- local taxiFreeze = false

-- DecorRegister("totalCost", 3)
-- DecorRegister("costPerMinute", 3)
-- DecorRegister("taxiFreeze", 2)

-- function openGui()
--  guiEnabled = true
--  SendNUIMessage({openSection = "openTaxiMeter"})
-- end

-- function closeGui()
--  if guiEnabled then
--   SendNUIMessage({openSection = "closeTaxiMeter"})
--   guiEnabled = false
--   SetPlayerControl(PlayerId(), 1, 0)
-- end
-- end

-- Citizen.CreateThread(function()
--  while true do
--   Citizen.Wait(500)
--   local isInVehicle = IsPedInAnyVehicle(PlayerPedId(), false)
--   if isInVehicle then
--    local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
--    if IsPedInAnyTaxi(PlayerPedId()) then
--     PerMinute = DecorGetInt(currentVehicle, 'costPerMinute')
--     openGui()
--     updateDriverMeter()
--    else
--     Citizen.Wait(2500)
--    end
--   else
--    closeGui()
--    Citizen.Wait(2500)
--   end
--  end
-- end)

-- Citizen.CreateThread(function()
--  while true do
--   if guiEnabled then
--    Citizen.Wait(6000)
--    local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
--    if not DecorGetBool(currentVehicle, 'taxiFreeze') then
--     local totalFare = DecorGetInt(currentVehicle, 'totalCost')
--     local newFare = totalFare + math.ceil(PerMinute / 10)
--     DecorSetInt(currentVehicle, 'totalCost', newFare)
--     updateDriverMeter()
--    end
--   else
--    Citizen.Wait(5000)
--   end
--  end
-- end)


-- function updateDriverMeter()
--  local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
--  local updateTotal = DecorGetInt(currentVehicle, 'totalCost')

--  SendNUIMessage({openSection = "updateTotal", sentnumber = "$"..updateTotal..".00" })
--  SendNUIMessage({openSection = "updatePerMinute", sentnumber = "$"..PerMinute..".00" })
--  SendNUIMessage({openSection = "updateBaseFare", sentnumber = "$"..BaseFare..".00" })
-- end


-- RegisterCommand("taximin", function(source, args)
--  local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)

--  if IsPedInAnyTaxi(PlayerPedId()) then
--   DecorSetInt(currentVehicle, 'costPerMinute', tonumber(args[1]))
--  end
-- end)

-- RegisterCommand("taxibase", function(source, args)
--  local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)

--  if IsPedInAnyTaxi(PlayerPedId()) then
--   BaseFare = tonumber(args[1])
--  end
-- end)

-- RegisterCommand("taxireset", function(source, args)
--  local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
--  local driverPed = GetPedInVehicleSeat(currentVehicle, -1)
--  if IsPedInAnyTaxi(PlayerPedId()) then
--   if GetPlayerPed(-1) == driverPed then
--    DecorSetInt(currentVehicle, 'totalCost', 0)
--    DecorSetInt(currentVehicle, 'costPerMinute', 0)
--    DecorSetInt(currentVehicle, 'totalCost', BaseFare)
--   end
--  end
-- end)

-- RegisterCommand("taxifreeze", function(source, args)
--  local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
--  local driverPed = GetPedInVehicleSeat(currentVehicle, -1)
--  if IsPedInAnyTaxi(PlayerPedId()) then
--   if GetPlayerPed(-1) == driverPed then
--    taxiFreeze = not DecorGetBool(currentVehicle, 'taxiFreeze')
--    DecorSetBool(currentVehicle, 'taxiFreeze', taxiFreeze)
--   end
--  end
-- end)
