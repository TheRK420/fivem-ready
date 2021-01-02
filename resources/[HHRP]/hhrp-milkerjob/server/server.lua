HHCore = nil

TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)



RegisterNetEvent('hhrp_milkerjob::checkjob')
AddEventHandler('hhrp_milkerjob:checkjob', function(item, amount)
	local xPlayer  = HHCore.GetPlayerFromId(source)
	if xPlayer.job.name == "milker" then
		-- TODO
	else
		TriggerClientEvent('DoLongHudText', source, 'You are not a milker man', 2)
	end
end)

RegisterNetEvent('hhrp_milkerjob::removeitem')
AddEventHandler('hhrp_milkerjob:removeitem', function(item, amount)
	local xPlayer  = HHCore.GetPlayerFromId(source)
	xPlayer.removeInventoryItem(item, amount)
end)

RegisterNetEvent('hhrp_milkerjob:giveprize')
AddEventHandler('hhrp_milkerjob:giveprize', function()
	local amount = math.random(Config.PrizeMin,Config.PrizeMax)
	local xPlayer  = HHCore.GetPlayerFromId(source)
	--xPlayer.addInventoryItem(Config.PrizeItem, amount)
	TriggerClientEvent('player:receiveItem',source,Config.PrizeItem, amount)
	TriggerClientEvent('DoLongHudText', source, 'You Take ' .. amount .. 'x ' .. Config.PrizeLabel, 1)
end)

RegisterNetEvent('hhrp_milkerjob:sellitem')
AddEventHandler('hhrp_milkerjob:sellitem', function()
	local xPlayer  = HHCore.GetPlayerFromId(source)
	--local milk = xPlayer.getInventoryItem(Config.PrizeItem).count
	local totalprice = Config.ItemPrice

	if milk > 0 then
	xPlayer.removeInventoryItem(Config.PrizeItem, milk)
	xPlayer.addMoney(totalprice)
	TriggerClientEvent('DoLongHudText', source, 'You Sold ' .. milk .. 'x ' .. Config.PrizeLabel .. ' For $' .. totalprice .. '', 1)
	else
		TriggerClientEvent('DoLongHudText', source, 'You Dont Have A ' .. Config.PrizeLabel, 2)
	end
end)
