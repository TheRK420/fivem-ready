HHCore = nil

TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)

HHCore.RegisterServerCallback('hhrp-carwash:canAfford', function(source, cb)
	local xPlayer = HHCore.GetPlayerFromId(source)

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