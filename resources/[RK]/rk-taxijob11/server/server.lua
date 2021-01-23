RKCore                = nil

TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)

RegisterServerEvent('towtruck:giveCash')
AddEventHandler('towtruck:giveCash', function(cash)
  local source = source
  local xPlayer  = RKCore.GetPlayerFromId(source)
  xPlayer.addMoney(cash)
end)

RegisterServerEvent('rk-imp:mechCar')
AddEventHandler('rk-imp:mechCar', function(plate)
	local user = RKCore.GetPlayerFromId(source)
    local characterId = user.identifier
	garage = 'Impound Lot'
	state = 'Normal Impound'
	MySQL.Async.execute("UPDATE owned_vehicles SET garage = @garage, state = @state WHERE plate = @plate", {['garage'] = garage, ['state'] = state, ['plate'] = plate})
end)