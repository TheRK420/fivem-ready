isLoggedIn = true
PlayerJob = {}

RKCore = nil
Citizen.CreateThread(function()
	while RKCore == nil do
		TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)
		Citizen.Wait(0)
	end
end)