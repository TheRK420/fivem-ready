HHCore = nil

TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)

RegisterServerEvent('hhrp_taximeter:updatePassengerMeters')
AddEventHandler('hhrp_taximeter:updatePassengerMeters', function(player, meterAttrs)
  TriggerClientEvent('hhrp_taximeter:updatePassenger', player, meterAttrs)
end)


RegisterServerEvent('hhrp_taximeter:resetPassengerMeters')
AddEventHandler('hhrp_taximeter:resetPassengerMeters', function(player)
  TriggerClientEvent('hhrp_taximeter:resetMeter', player)
end)

RegisterServerEvent('hhrp_taximeter:updatePassengerLocation')
AddEventHandler('hhrp_taximeter:updatePassengerLocation', function(player)
  TriggerClientEvent('hhrp_taximeter:updateLocation', player)
end)
