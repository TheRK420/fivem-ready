RKCore = nil

Citizen.CreateThread(function()
	while RKCore == nil do
		TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)
		Citizen.Wait(0)
	end

	while RKCore.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = RKCore.GetPlayerData()
end)

RegisterNetEvent('rk-fines:Anim')
AddEventHandler('rk-fines:Anim', function()
	RequestAnimDict('mp_common')
    while not HasAnimDictLoaded('mp_common') do
        Citizen.Wait(5)
    end
    TaskPlayAnim(PlayerPedId(), "mp_common", "givetake1_a", 8.0, -8, -1, 12, 1, 0, 0, 0)
end)