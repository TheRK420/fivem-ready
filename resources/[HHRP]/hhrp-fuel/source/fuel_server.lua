HHCore = nil

TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)

RegisterServerEvent('fuel:pay')
AddEventHandler('fuel:pay', function(price)
	local xPlayer = HHCore.GetPlayerFromId(source)
	local amount = HHCore.Math.Round(price)

	if price > 0 then
		xPlayer.removeMoney(amount)
	end
end)

RegisterServerEvent('fuel:givecan')
AddEventHandler('fuel:givecan', function()
	local xPlayer = HHCore.GetPlayerFromId(source)

	xPlayer.addInventoryItem('WEAPON_PETROLCAN', 1)
end)