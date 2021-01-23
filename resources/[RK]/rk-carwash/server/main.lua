RKCore = nil

TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)

RKCore.RegisterServerCallback('rk-carwash:canAfford', function(source, cb)
	local xPlayer = RKCore.GetPlayerFromId(source)

	if Config.EnablePrice then
		if xPlayer.getMoney() >= Config.Price then
			xPlayer.removeMoney(Config.Price)
			cb(true)
		else
			cb(false)
		end
	else
		cb(true)
	end
end)