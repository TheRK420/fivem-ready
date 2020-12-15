vehsales = {}

vehsales.Version = '1.0.10'

TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj; end)
Citizen.CreateThread(function(...)
  while not HHCore do
    TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj; end)
    Citizen.Wait(0)
  end
end)