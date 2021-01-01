HHCore = nil

if Config.UseHHcore then
	TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)

	RegisterServerEvent('fuel:pay')
	AddEventHandler('fuel:pay', function(price)
		local xPlayer = HHCore.GetPlayerFromId(source)
		local amount = HHCore.Math.Round(price)

		if price > 0 then
			xPlayer.removeMoney(amount)
		end
	end)
end
