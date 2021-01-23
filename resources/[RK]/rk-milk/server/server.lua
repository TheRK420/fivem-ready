RKCore = nil

TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)



RegisterNetEvent('rk_milkerjob::checkjob')
AddEventHandler('rk_milkerjob:checkjob', function(item, amount)
	local xPlayer  = RKCore.GetPlayerFromId(source)
	if xPlayer.job.name == "milker" then
		-- TODO
	else
		TriggerClientEvent('DoLongHudText', source, 'You are not a milker man', 2)
	end
end)

RegisterNetEvent('rk_milkerjob::removeitem')
AddEventHandler('rk_milkerjob:removeitem', function(item, amount)
	local xPlayer  = RKCore.GetPlayerFromId(source)
	xPlayer.removeInventoryItem(item, amount)
end)

RegisterNetEvent('rk_milkerjob:giveprize')
AddEventHandler('rk_milkerjob:giveprize', function()
	local amount = math.random(Config.PrizeMin,Config.PrizeMax)
	local xPlayer  = RKCore.GetPlayerFromId(source)
	--xPlayer.addInventoryItem(Config.PrizeItem, amount)
	TriggerClientEvent('player:receiveItem',source,Config.PrizeItem, amount)
	TriggerClientEvent('DoLongHudText', source, 'You Take ' .. amount .. 'x ' .. Config.PrizeLabel, 1)
end)

RegisterNetEvent('rk_milkerjob:sellitem')
AddEventHandler('rk_milkerjob:sellitem', function()
	local xPlayer  = RKCore.GetPlayerFromId(source)
	local milk = 1
	local totalprice = Config.ItemPrice
	--xPlayer.removeInventoryItem(Config.PrizeItem, milk)
	xPlayer.addMoney(totalprice)
	TriggerClientEvent('DoLongHudText', source, 'You Sold ' .. milk .. 'x ' .. Config.PrizeLabel .. ' For $' .. totalprice .. '', 1)
end)
