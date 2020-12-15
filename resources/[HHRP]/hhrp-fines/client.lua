HHCore = nil

Citizen.CreateThread(function()
	while HHCore == nil do
		TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)
		Citizen.Wait(0)
	end

	while HHCore.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = HHCore.GetPlayerData()
end)

RegisterNetEvent('hhrp-fines:Anim')
AddEventHandler('hhrp-fines:Anim', function()
	RequestAnimDict('mp_common')
    while not HasAnimDictLoaded('mp_common') do
        Citizen.Wait(5)
    end
    TaskPlayAnim(PlayerPedId(), "mp_common", "givetake1_a", 8.0, -8, -1, 12, 1, 0, 0, 0)
end)