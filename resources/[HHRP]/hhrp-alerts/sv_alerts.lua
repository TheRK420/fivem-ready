RegisterServerEvent("hhrp-alerts:teenA")
AddEventHandler("hhrp-alerts:teenA",function(targetCoords)
    TriggerClientEvent('hhrp-alerts:policealertA', -1, targetCoords)
	return
end)

RegisterServerEvent("hhrp-alerts:teenB")
AddEventHandler("hhrp-alerts:teenB",function(targetCoords)
    TriggerClientEvent('hhrp-alerts:policealertB', -1, targetCoords)
	return
end)

RegisterServerEvent("hhrp-alerts:teenpanic")
AddEventHandler("hhrp-alerts:teenpanic",function(targetCoords)
    TriggerClientEvent('hhrp-alerts:panic', -1, targetCoords)
	return
end)

RegisterServerEvent("hhrp-alerts:fourA")
AddEventHandler("hhrp-alerts:fourA",function(targetCoords)
    TriggerClientEvent('hhrp-alerts:tenForteenA', -1, targetCoords)
	return
end)

RegisterServerEvent("hhrp-alerts:fourB")
AddEventHandler("hhrp-alerts:fourB",function(targetCoords)
    TriggerClientEvent('hhrp-alerts:tenForteenB', -1, targetCoords)
	return
end)

RegisterServerEvent("hhrp-alerts:downperson")
AddEventHandler("hhrp-alerts:downperson",function(targetCoords)
    TriggerClientEvent('hhrp-alerts:downalert', -1, targetCoords)
	return
end)

RegisterServerEvent("hhrp-alerts:sveh")
AddEventHandler("hhrp-alerts:sveh",function(targetCoords)
    TriggerClientEvent('hhrp-alerts:vehiclesteal', -1, targetCoords)
	return
end)

RegisterServerEvent("hhrp-alerts:shoot")
AddEventHandler("hhrp-alerts:shoot",function(targetCoords)
    TriggerClientEvent('hhrp-outlawalert:gunshotInProgress', -1, targetCoords)
	return
end)

RegisterServerEvent("hhrp-alerts:figher")
AddEventHandler("hhrp-alerts:figher",function(targetCoords)
    TriggerClientEvent('hhrp-outlawalert:combatInProgress', -1, targetCoords)
	return
end)

RegisterServerEvent("hhrp-alerts:storerob")
AddEventHandler("hhrp-alerts:storerob",function(targetCoords)
    TriggerClientEvent('hhrp-alerts:storerobbery', -1, targetCoords)
	return
end)

RegisterServerEvent("hhrp-alerts:houserob")
AddEventHandler("hhrp-alerts:houserob",function(targetCoords)
    TriggerClientEvent('hhrp-alerts:houserobbery', -1, targetCoords)
	return
end)

RegisterServerEvent("hhrp-alerts:tbank")
AddEventHandler("hhrp-alerts:tbank",function(targetCoords)
    TriggerClientEvent('hhrp-alerts:banktruck', -1, targetCoords)
	return
end)

RegisterServerEvent("hhrp-alerts:robjew")
AddEventHandler("hhrp-alerts:robjew",function()
    TriggerClientEvent('hhrp-alerts:jewelrobbey', -1)
	return
end)

RegisterServerEvent("hhrp-alerts:bjail")
AddEventHandler("hhrp-alerts:bjail",function()
    TriggerClientEvent('hhrp-alerts:jewelrobbey', -1)
	return
end)