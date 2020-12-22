HHCore = nil

Citizen.CreateThread(function()
	while HHCore == nil do
		TriggerEvent("hhrp:getSharedObject", function(obj) HHCore = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent("hhrp:playerLoaded")
AddEventHandler("hhrp:playerLoaded", function(xPlayer)
	HHCore.PlayerData = xPlayer
end)

RegisterNetEvent("hhrp:setJob")
AddEventHandler("hhrp:setJob", function(job)
	HHCore.PlayerData.job = job
end)


-- // FRISK FUNCTION // --
RegisterCommand("frisk", function()
	if HHCore.PlayerData.job.name == "police" then
		local closestPlayer, closestDistance = HHCore.Game.GetClosestPlayer()
	
		if closestPlayer == -1 or closestDistance > 2.0 then
			TriggerEvent('DoLongHudText', 'There is no player(s) nearby!', 2)
		else
			TriggerServerEvent("hhrp-policefrisk:closestPlayer", GetPlayerServerId(closestPlayer))
		end
	end
end, false)

RegisterNetEvent("hhrp-policefrisk:menuEvent") -- Call this event if you want to add it to your police menu
AddEventHandler("hhrp-policefrisk:menuEvent", function()
	local closestPlayer, closestDistance = HHCore.Game.GetClosestPlayer()
	if closestPlayer == -1 or closestDistance > 2.0 then
		TriggerEvent('DoLongHudText', 'There is no player(s) nearby!', 2)
	else
		TriggerServerEvent("hhrp-policefrisk:closestPlayer", GetPlayerServerId(closestPlayer))
	end
end)

local weapons = {
	-- PISTOLS --
	"WEAPON_PISTOL",
	"WEAPON_PISTOL_MK2",
	"WEAPON_COMBATPISTOL",
	"WEAPON_PISTOL50",
	"WEAPON_SNSPISTOL",
	"WEAPON_HEAVYPISTOL",
	"WEAPON_VINTAGEPISTOL",
	"WEAPON_MARKSMANPISTOL",
	"WEAPON_REVOLVER",
	"WEAPON_APPISTOL",
	"WEAPON_STUNGUN",
	"WEAPON_FLAREGUN",
	-- SMGS --
	"WEAPON_MICROSMG",
	"WEAPON_MACHINEPISTOL",
	"WEAPON_SMG",
	"WEAPON_SMG_MK2",
	"WEAPON_ASSAULTSMG",
	"WEAPON_COMBATPDW",
	"WEAPON_MG",
	"WEAPON_COMBATMG",
	"WEAPON_COMBATMG_MK2",
	"WEAPON_GUSENBERG",
	"WEAPON_MINISMG",
	-- RIFLES --
	"WEAPON_ASSAULTRIFLE",
	"WEAPON_ASSAULTRIFLE_MK2",
	"WEAPON_CARBINERIFLE",
	"WEAPON_CARBINERIFLE_MK2",
	"WEAPON_ADVANCEDRIFLE",
	"WEAPON_SPECIALCARBINE",
	"WEAPON_BULLPUPRIFLE",
	"WEAPON_COMPACTRIFLE",
	-- SNIPER RIFLES --
	"WEAPON_SNIPERRIFLE",
	"WEAPON_HEAVYSNIPER",
	"WEAPON_HEAVYSNIPER_MK2",
	"WEAPON_MARKSMANRIFLE",
	-- SHOTGUNS --
	"WEAPON_PUMPSHOTGUN",
	"WEAPON_SAWNOFFSHOTGUN",
	"WEAPON_BULLPUPSHOTGUN",
	"WEAPON_ASSAULTSHOTGUN",
	"WEAPON_MUSKET",
	"WEAPON_HEAVYSHOTGUN",
	"WEAPON_DOUBLEBARRELSHOTGUN",
	"WEAPON_AUTOSHOTGUN",
}

function isWeapon(name)
    return string.find(name, 'WEAPON_') ~= nil
end

RegisterNetEvent('hhrp-policefrisk:friskPlayer') 
AddEventHandler('hhrp-policefrisk:friskPlayer', function()
	local ped = PlayerPedId()
	local inventory = HHCore.GetPlayerData().inventory
	
	for i=1, #inventory, 1 do
        if isWeapon(inventory[i].name) and inventory[i].count > 0 then
			TriggerServerEvent("hhrp-policefrisk:notifyMessage", true)
			return
		end
	end
	for i=1, #inventory, 1 do
		if not isWeapon(inventory[i].name) and inventory[i].count <= 0 then
			TriggerServerEvent("hhrp-policefrisk:notifyMessage", false)
			return
		end
	end
end)