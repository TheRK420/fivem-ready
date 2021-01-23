RKCore = nil

Citizen.CreateThread(function()
	while RKCore == nil do
		TriggerEvent("rk:getSharedObject", function(obj) RKCore = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent("rk:playerLoaded")
AddEventHandler("rk:playerLoaded", function(xPlayer)
	RKCore.PlayerData = xPlayer
end)

RegisterNetEvent("rk:setJob")
AddEventHandler("rk:setJob", function(job)
	RKCore.PlayerData.job = job
end)

--- Gun Shots ---

RegisterNetEvent('rk-outlawalert:gunshotInProgress')
AddEventHandler('rk-outlawalert:gunshotInProgress', function(targetCoords)
	if RKCore.GetPlayerData().job.name == 'police' then
		if Config.gunAlert then
			local alpha = 250
			local gunshotBlip = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

			SetBlipScale(gunshotBlip, 1.3)
			SetBlipSprite(gunshotBlip,  432)
			SetBlipColour(gunshotBlip,  1)
			SetBlipAlpha(gunshotBlip, alpha)
			SetBlipAsShortRange(gunshotBlip, true)
			BeginTextCommandSetBlipName("STRING")              -- set the blip's legend caption
			AddTextComponentString('10-71 Shots Fired')              -- to 'supermarket'
			EndTextCommandSetBlipName(gunshotBlip)
			SetBlipAsShortRange(gunshotBlip,  1)
			PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)

			while alpha ~= 0 do
				Citizen.Wait(Config.BlipGunTime * 4)
				alpha = alpha - 1
				SetBlipAlpha(gunshotBlip, alpha)

				if alpha == 0 then
					RemoveBlip(gunshotBlip)
					return
				end
			end

		end
	end
end)
RegisterNetEvent('rk-alerts:gunshot')
AddEventHandler('rk-alerts:gunshot', function()
	local pos = GetEntityCoords(PlayerPedId(), true)
	TriggerServerEvent('rk-alerts:shoot', {x = pos.x, y = pos.y, z = pos.z})
end)

---- Fight ----

RegisterNetEvent('rk-outlawalert:combatInProgress')
AddEventHandler('rk-outlawalert:combatInProgress', function(targetCoords)
	if RKCore.GetPlayerData().job.name == 'police' then	
		if Config.gunAlert then
			local alpha = 250
			local knife = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

			SetBlipScale(knife, 1.3)
			SetBlipSprite(knife,  437)
			SetBlipColour(knife,  1)
			SetBlipAlpha(knife, alpha)
			SetBlipAsShortRange(knife, true)
			BeginTextCommandSetBlipName("STRING")              -- set the blip's legend caption
			AddTextComponentString('10-11 Fight In Progress')              -- to 'supermarket'
			EndTextCommandSetBlipName(knife)
			SetBlipAsShortRange(knife,  1)
			PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)

			while alpha ~= 0 do
				Citizen.Wait(Config.BlipGunTime * 4)
				alpha = alpha - 1
				SetBlipAlpha(knife, alpha)

				if alpha == 0 then
					RemoveBlip(knife)
					return
				end
			end

		end
	end
end)

AddEventHandler('rk-alerts:fight', function()
	local pos = GetEntityCoords(PlayerPedId(), true)
	TriggerServerEvent('rk-alerts:figher', {x = pos.x, y = pos.y, z = pos.z})
end)

---- 10-13s Officer Down ----

RegisterNetEvent('rk-alerts:policealertA')
AddEventHandler('rk-alerts:policealertA', function(targetCoords)
  if RKCore.GetPlayerData().job.name == 'police' or RKCore.GetPlayerData().job.name == 'ambulance' then	
		local alpha = 250
		local policedown = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

		SetBlipSprite(policedown,  126)
		SetBlipColour(policedown,  1)
		SetBlipScale(policedown, 1.3)
		SetBlipAsShortRange(policedown,  1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('10-13A Officer Down')
		EndTextCommandSetBlipName(policedown)
		TriggerServerEvent('InteractSound_SV:PlayOnSource', 'polalert', 0.3)

		while alpha ~= 0 do
			Citizen.Wait(120 * 4)
			alpha = alpha - 1
			SetBlipAlpha(policedown, alpha)

		if alpha == 0 then
			RemoveBlip(policedown)
		return
      end
    end
  end
end)

AddEventHandler('rk-alerts:1013A', function()
	local pos = GetEntityCoords(PlayerPedId(), true)
	TriggerServerEvent('rk-alerts:teenA', {x = pos.x, y = pos.y, z = pos.z})
end)

RegisterNetEvent('rk-alerts:policealertB')
AddEventHandler('rk-alerts:policealertB', function(targetCoords)
if RKCore.GetPlayerData().job.name == 'police' or RKCore.GetPlayerData().job.name == 'ambulance' then	
		local alpha = 250
		local policedown2 = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

		SetBlipSprite(policedown2,  126)
		SetBlipColour(policedown2,  1)
		SetBlipScale(policedown2, 1.3)
		SetBlipAsShortRange(policedown2,  1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('10-13B Officer Down')
		EndTextCommandSetBlipName(policedown2)
		PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)

		while alpha ~= 0 do
			Citizen.Wait(120 * 4)
			alpha = alpha - 1
			SetBlipAlpha(policedown2, alpha)

		if alpha == 0 then
			RemoveBlip(policedown2)
		return
      end
    end
  end
end)

AddEventHandler('rk-alerts:1013B', function()
	local pos = GetEntityCoords(PlayerPedId(), true)
	TriggerServerEvent('rk-alerts:teenB', {x = pos.x, y = pos.y, z = pos.z})
end)


RegisterNetEvent('rk-alerts:panic')
AddEventHandler('rk-alerts:panic', function(targetCoords)
if RKCore.GetPlayerData().job.name == 'police' or RKCore.GetPlayerData().job.name == 'ambulance' then	
		local alpha = 250
		local panic = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

		SetBlipSprite(panic,  126)
		SetBlipColour(panic,  1)
		SetBlipScale(panic, 1.3)
		SetBlipAsShortRange(panic,  1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('10-78 Officer Panic Botton')
		EndTextCommandSetBlipName(panic)
		TriggerServerEvent('InteractSound_SV:PlayOnSource', 'polalert', 0.3)

		while alpha ~= 0 do
			Citizen.Wait(120 * 4)
			alpha = alpha - 1
			SetBlipAlpha(panic, alpha)

		if alpha == 0 then
			RemoveBlip(panic)
		return
      end
    end
  end
end)

AddEventHandler('rk-alerts:policepanic', function()
	local pos = GetEntityCoords(PlayerPedId(), true)
	TriggerServerEvent('rk-alerts:teenpanic', {x = pos.x, y = pos.y, z = pos.z})
end)


---- 10-14 EMS ----

RegisterNetEvent('rk-alerts:tenForteenA')
AddEventHandler('rk-alerts:tenForteenA', function(targetCoords)
  if RKCore.GetPlayerData().job.name == 'police' or RKCore.GetPlayerData().job.name == 'ambulance' then	
		local alpha = 250
		local medicDown = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

		SetBlipSprite(medicDown,  126)
		SetBlipColour(medicDown,  1)
		SetBlipScale(medicDown, 1.3)
		SetBlipAsShortRange(medicDown,  1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('10-14A Medic Down')
		EndTextCommandSetBlipName(medicDown)
		TriggerServerEvent('InteractSound_SV:PlayOnSource', 'polalert', 0.3)

		while alpha ~= 0 do
			Citizen.Wait(120 * 4)
			alpha = alpha - 1
			SetBlipAlpha(medicDown, alpha)

		if alpha == 0 then
			RemoveBlip(medicDown)
		return
      end
    end
  end
end)

AddEventHandler('rk-alerts:1014A', function()
	local pos = GetEntityCoords(PlayerPedId(), true)
	TriggerServerEvent('rk-alerts:fourA', {x = pos.x, y = pos.y, z = pos.z})
end)


RegisterNetEvent('rk-alerts:tenForteenB')
AddEventHandler('rk-alerts:tenForteenB', function(targetCoords)
if RKCore.GetPlayerData().job.name == 'police' or RKCore.GetPlayerData().job.name == 'ambulance' then	
		local alpha = 250
		local medicDown2 = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

		SetBlipSprite(medicDown2,  126)
		SetBlipColour(medicDown2,  1)
		SetBlipScale(medicDown2, 1.3)
		SetBlipAsShortRange(medicDown2,  1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('10-14B Officer Down')
		EndTextCommandSetBlipName(medicDown2)
		PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)

		while alpha ~= 0 do
			Citizen.Wait(120 * 4)
			alpha = alpha - 1
			SetBlipAlpha(medicDown2, alpha)

		if alpha == 0 then
			RemoveBlip(medicDown2)
		return
      end
    end
  end
end)

AddEventHandler('rk-alerts:1014B', function()
	local pos = GetEntityCoords(PlayerPedId(), true)
	TriggerServerEvent('rk-alerts:fourB', {x = pos.x, y = pos.y, z = pos.z})
end)

---- Down Person ----

RegisterNetEvent('rk-alerts:downalert')
AddEventHandler('rk-alerts:downalert', function(targetCoords)
if RKCore.GetPlayerData().job.name == 'police' or RKCore.GetPlayerData().job.name == 'ambulance' then	
		local alpha = 250
		local injured = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

		SetBlipSprite(injured,  126)
		SetBlipColour(injured,  18)
		SetBlipScale(injured, 1.5)
		SetBlipAsShortRange(injured,  1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('10-47 Injured Person')
		EndTextCommandSetBlipName(injured)
		TriggerServerEvent('InteractSound_SV:PlayOnSource', 'dispatch', 0.1)

		while alpha ~= 0 do
			Citizen.Wait(120 * 4)
			alpha = alpha - 1
			SetBlipAlpha(injured, alpha)

		if alpha == 0 then
			RemoveBlip(injured)
		return
      end
    end
  end
end)

AddEventHandler('rk-alerts:downguy', function()
	local pos = GetEntityCoords(PlayerPedId(), true)
	TriggerServerEvent('rk-alerts:downperson', {x = pos.x, y = pos.y, z = pos.z})
end)

---- Car Crash ----

RegisterNetEvent('rk-alerts:vehiclecrash')
AddEventHandler('rk-alerts:vehiclecrash', function()
if RKCore.GetPlayerData().job.name == 'police' or RKCore.GetPlayerData().job.name == 'ambulance' then	
		local alpha = 250
		local targetCoords = GetEntityCoords(PlayerPedId(), true)
		local recket = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

		SetBlipSprite(recket,  488)
		SetBlipColour(recket,  1)
		SetBlipScale(recket, 1.5)
		SetBlipAsShortRange(recket,  1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('10-50 Vehicle Crash')
		EndTextCommandSetBlipName(recket)
		PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)

		while alpha ~= 0 do
			Citizen.Wait(120 * 4)
			alpha = alpha - 1
			SetBlipAlpha(recket, alpha)

		if alpha == 0 then
			RemoveBlip(recket)
		return
      end
    end
  end
end)
---- Vehicle Theft ----

RegisterNetEvent('rk-alerts:vehiclesteal')
AddEventHandler('rk-alerts:vehiclesteal', function(targetCoords)
if RKCore.GetPlayerData().job.name == 'police' then	
		local alpha = 250
		local thiefBlip = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

		SetBlipSprite(thiefBlip,  488)
		SetBlipColour(thiefBlip,  1)
		SetBlipScale(thiefBlip, 1.5)
		SetBlipAsShortRange(thiefBlip,  1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('10-60 Vehicle Theft')
		EndTextCommandSetBlipName(thiefBlip)
		PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)

		while alpha ~= 0 do
			Citizen.Wait(120 * 4)
			alpha = alpha - 1
			SetBlipAlpha(thiefBlip, alpha)

		if alpha == 0 then
			RemoveBlip(thiefBlip)
		return
      end
    end
  end
end)

AddEventHandler('rk-alerts:stolenveh', function()
	local pos = GetEntityCoords(PlayerPedId(), true)
	TriggerServerEvent('rk-alerts:sveh', {x = pos.x, y = pos.y, z = pos.z})
end)


---- Store Robbery ----

RegisterNetEvent('rk-alerts:storerobbery')
AddEventHandler('rk-alerts:storerobbery', function(targetCoords)
if RKCore.GetPlayerData().job.name == 'police' then	
		local alpha = 250
		local store = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

		SetBlipHighDetail(store, true)
		SetBlipSprite(store,  52)
		SetBlipColour(store,  1)
		SetBlipScale(store, 1.3)
		SetBlipAsShortRange(store,  1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('10-31B Robbery In Progress')
		EndTextCommandSetBlipName(store)
		TriggerServerEvent('InteractSound_SV:PlayOnSource', 'bankalarm', 0.3)

		while alpha ~= 0 do
			Citizen.Wait(120 * 4)
			alpha = alpha - 1
			SetBlipAlpha(store, alpha)

		if alpha == 0 then
			RemoveBlip(store)
		return
      end
    end
  end
end)

AddEventHandler('rk-alerts:robstore', function()
	local pos = GetEntityCoords(PlayerPedId(), true)
	TriggerServerEvent('rk-alerts:storerob', {x = pos.x, y = pos.y, z = pos.z})
end)

---- House Robbery ----

RegisterNetEvent('rk-alerts:houserobbery')
AddEventHandler('rk-alerts:houserobbery', function(targetCoords)
if RKCore.GetPlayerData().job.name == 'police' then	
		local alpha = 250
		local burglary = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

		SetBlipHighDetail(burglary, true)
		SetBlipSprite(burglary,  411)
		SetBlipColour(burglary,  1)
		SetBlipScale(burglary, 1.3)
		SetBlipAsShortRange(burglary,  1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('10-31A Burglary')
		EndTextCommandSetBlipName(burglary)
		PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)

		while alpha ~= 0 do
			Citizen.Wait(120 * 4)
			alpha = alpha - 1
			SetBlipAlpha(burglary, alpha)

		if alpha == 0 then
			RemoveBlip(burglary)
		return
      end
    end
  end
end)

AddEventHandler('rk-alerts:robhouse', function()
	local pos = GetEntityCoords(PlayerPedId(), true)
	TriggerServerEvent('rk-alerts:houserob', {x = pos.x, y = pos.y, z = pos.z})
end)

---- Bank Truck ----

RegisterNetEvent('rk-alerts:banktruck')
AddEventHandler('rk-alerts:banktruck', function(targetCoords)
	if RKCore.GetPlayerData().job.name == 'police' then	
		local alpha = 250
		local truck = AddBlipForCoord(targetCoords.x, targetCoords.y, targetCoords.z)

		SetBlipSprite(truck,  477)
		SetBlipColour(truck,  47)
		SetBlipScale(truck, 1.5)
		SetBlipAsShortRange(Blip,  1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('10-90 Bank Truck In Progress')
		EndTextCommandSetBlipName(truck)
		TriggerServerEvent('InteractSound_SV:PlayOnSource', 'bankalarm', 0.3)

		while alpha ~= 0 do
			Citizen.Wait(120 * 4)
			alpha = alpha - 1
			SetBlipAlpha(truck, alpha)

		if alpha == 0 then
			RemoveBlip(truck)
		return
      end
    end
  end
end)

AddEventHandler('rk-alerts:bankt', function()
	local pos = GetEntityCoords(PlayerPedId(), true)
	TriggerServerEvent('rk-alerts:tbank', {x = pos.x, y = pos.y, z = pos.z})
end)

---- Jewerly Store ----

RegisterNetEvent('rk-alerts:jewelrobbey')
AddEventHandler('rk-alerts:jewelrobbey', function()
	if RKCore.GetPlayerData().job.name == 'police' then	
		local alpha = 250
		local jew = AddBlipForCoord(-634.02, -239.49, 38)

		SetBlipSprite(jew,  487)
		SetBlipColour(jew,  4)
		SetBlipScale(jew, 1.8)
		SetBlipAsShortRange(Blip,  1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('10-90 In Progress')
		EndTextCommandSetBlipName(jew)
		TriggerServerEvent('InteractSound_SV:PlayOnSource', 'bankalarm', 0.3)

		while alpha ~= 0 do
			Citizen.Wait(120 * 4)
			alpha = alpha - 1
			SetBlipAlpha(jew, alpha)

		if alpha == 0 then
			RemoveBlip(jew)
		return
      end
    end
  end
end)

AddEventHandler('rk-alerts:jewrob', function()
	TriggerServerEvent('rk-alerts:robjew')
end)

---- Jail Break ----

RegisterNetEvent('rk-alerts:jailbreak')
AddEventHandler('rk-alerts:jailbreak', function()
	if RKCore.GetPlayerData().job.name == 'police' then	
		local alpha = 250
		local jail = AddBlipForCoord(1779.65, 2590.39, 50.49)

		SetBlipSprite(jail,  487)
		SetBlipColour(jail,  4)
		SetBlipScale(jail, 1.8)
		SetBlipAsShortRange(jail,  1)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('10-98 Jail Break')
		EndTextCommandSetBlipName(jail)
		TriggerServerEvent('InteractSound_SV:PlayOnSource', 'bankalarm', 0.3)

		while alpha ~= 0 do
			Citizen.Wait(120 * 4)
			alpha = alpha - 1
			SetBlipAlpha(jail, alpha)

		if alpha == 0 then
			RemoveBlip(jail)
		return
      end
    end
  end
end)

AddEventHandler('rk-alerts:jailb', function()
	TriggerServerEvent('rk-alerts:bjail')
end)