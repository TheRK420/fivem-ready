RKCore = nil

TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)

local hiddenprocess = vector3(1389.32, 3604.86, 38.94) -- Change this to whatever location you want. This is server side to prevent people from dumping the coords
local hiddenstart = vector3(438.37, 3570.58, 33.88) -- Change this to whatever location you want. This is server side to prevent people from dumping the coords

RegisterNetEvent('coke:updateTable')
AddEventHandler('coke:updateTable', function(bool)
    TriggerClientEvent('coke:syncTable', -1, bool)
end)

--[[ RKCore.RegisterUsableItem('coke', function(source)
	local xPlayer = RKCore.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('coke', 1)
	TriggerClientEvent('coke:onUse', source)
end) ]]

RKCore.RegisterServerCallback('coke:processcoords', function(source, cb)
    cb(hiddenprocess)
end)

RKCore.RegisterServerCallback('coke:startcoords', function(source, cb)
    cb(hiddenstart)
end)

RKCore.RegisterServerCallback('coke:pay', function(source, cb)
	local _source = source
	local xPlayer = RKCore.GetPlayerFromId(_source)
	local price = Config.price
	local check = xPlayer.getMoney()
	if check >= price then
		xPlayer.removeMoney(price)
    	cb(true)
    else
      if Config.useMythic then
    	 TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = _U'no_money'})
      end
    	cb(false)
    end
end)

RegisterServerEvent("coke:processed")
AddEventHandler("coke:processed", function(x,y,z)
  	local _source = source
  	local xPlayer = RKCore.GetPlayerFromId(_source)
  	local pick = Config.randBrick
	xPlayer.removeInventoryItem('cokebrick', Config.takeBrick)
	xPlayer.addInventoryItem('coke', pick)
end)

RKCore.RegisterServerCallback('coke:process', function(source, cb)
	local _source = source
	local xPlayer = RKCore.GetPlayerFromId(_source)
	local check = xPlayer.getInventoryItem('cokebrick').count
	if check >= 1 then
    	cb(true)
    else
      if Config.useMythic then
    	 TriggerClientEvent('mythic_notify:client:SendAlert:long', _source, { type = 'error', text = _U'no_brick'})
      end
    	cb(false)
    end
end)

RegisterServerEvent("coke:GiveItem")
AddEventHandler("coke:GiveItem", function()
  	local _source = source
	local xPlayer = RKCore.GetPlayerFromId(_source)
	local br = math.random( 1, 6 )
	local repay = Config.price  
	--xPlayer.addInventoryItem('cokebrick', br)
	xPlayer.addMoney(repay)
end)
