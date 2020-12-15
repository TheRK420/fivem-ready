HHCore             = nil

TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)

RegisterServerEvent('mythic_hospital:server:HealSomeShit')
AddEventHandler('mythic_hospital:server:HealSomeShit', function()
    local src = source

	-- YOU NEED TO IMPLEMENT YOUR FRAMEWORKS BILLING HERE
	local xPlayer = HHCore.GetPlayerFromId(src)
	xPlayer.removeBank(1000)
        TriggerClientEvent('hhrp:showNotification', src, '~w~You Were Billed For ~r~$1,000 ~w~For Medical Services & Expenses')
end)