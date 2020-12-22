HHCore                = nil

TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)

RegisterServerEvent('towtruck:giveCash')
AddEventHandler('towtruck:giveCash', function(cash)
  local source = source
  local xPlayer  = HHCore.GetPlayerFromId(source)
  xPlayer.addMoney(cash)
end)

RegisterServerEvent('hhrp-imp:mechCar')
AddEventHandler('hhrp-imp:mechCar', function(plate)
	local user = HHCore.GetPlayerFromId(source)
    local characterId = user.identifier
	garage = 'Impound Lot'
	state = 'Normal Impound'
	MySQL.Async.execute("UPDATE owned_vehicles SET garage = @garage, state = @state WHERE plate = @plate", {['garage'] = garage, ['state'] = state, ['plate'] = plate})
end)