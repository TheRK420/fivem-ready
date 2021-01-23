RKCore = nil

TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)

RegisterServerEvent('rk_taximeter:updatePassengerMeters')
AddEventHandler('rk_taximeter:updatePassengerMeters', function(player, meterAttrs)
  TriggerClientEvent('rk_taximeter:updatePassenger', player, meterAttrs)
end)


RegisterServerEvent('rk_taximeter:resetPassengerMeters')
AddEventHandler('rk_taximeter:resetPassengerMeters', function(player)
  TriggerClientEvent('rk_taximeter:resetMeter', player)
end)

RegisterServerEvent('rk_taximeter:updatePassengerLocation')
AddEventHandler('rk_taximeter:updatePassengerLocation', function(player)
  TriggerClientEvent('rk_taximeter:updateLocation', player)
end)
