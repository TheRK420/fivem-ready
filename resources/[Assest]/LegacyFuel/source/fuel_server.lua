RKCore = nil

if Config.UseRKCore then
	TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)

	RegisterServerEvent('fuel:pay')
	AddEventHandler('fuel:pay', function(price)
		local xPlayer = RKCore.GetPlayerFromId(source)
		local amount = RKCore.Math.Round(price)

		if price > 0 then
			xPlayer.removeMoney(amount)
		end
	end)
end
