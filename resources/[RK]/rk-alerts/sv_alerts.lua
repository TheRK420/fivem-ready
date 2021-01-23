RegisterServerEvent("rk-alerts:teenA")
AddEventHandler("rk-alerts:teenA",function(targetCoords)
    TriggerClientEvent('rk-alerts:policealertA', -1, targetCoords)
	return
end)

RegisterServerEvent("rk-alerts:teenB")
AddEventHandler("rk-alerts:teenB",function(targetCoords)
    TriggerClientEvent('rk-alerts:policealertB', -1, targetCoords)
	return
end)

RegisterServerEvent("rk-alerts:teenpanic")
AddEventHandler("rk-alerts:teenpanic",function(targetCoords)
    TriggerClientEvent('rk-alerts:panic', -1, targetCoords)
	return
end)

RegisterServerEvent("rk-alerts:fourA")
AddEventHandler("rk-alerts:fourA",function(targetCoords)
    TriggerClientEvent('rk-alerts:tenForteenA', -1, targetCoords)
	return
end)

RegisterServerEvent("rk-alerts:fourB")
AddEventHandler("rk-alerts:fourB",function(targetCoords)
    TriggerClientEvent('rk-alerts:tenForteenB', -1, targetCoords)
	return
end)

RegisterServerEvent("rk-alerts:downperson")
AddEventHandler("rk-alerts:downperson",function(targetCoords)
    TriggerClientEvent('rk-alerts:downalert', -1, targetCoords)
	return
end)

RegisterServerEvent("rk-alerts:sveh")
AddEventHandler("rk-alerts:sveh",function(targetCoords)
    TriggerClientEvent('rk-alerts:vehiclesteal', -1, targetCoords)
	return
end)

RegisterServerEvent("rk-alerts:shoot")
AddEventHandler("rk-alerts:shoot",function(targetCoords)
    TriggerClientEvent('rk-outlawalert:gunshotInProgress', -1, targetCoords)
	return
end)

RegisterServerEvent("rk-alerts:figher")
AddEventHandler("rk-alerts:figher",function(targetCoords)
    TriggerClientEvent('rk-outlawalert:combatInProgress', -1, targetCoords)
	return
end)

RegisterServerEvent("rk-alerts:storerob")
AddEventHandler("rk-alerts:storerob",function(targetCoords)
    TriggerClientEvent('rk-alerts:storerobbery', -1, targetCoords)
	return
end)

RegisterServerEvent("rk-alerts:houserob")
AddEventHandler("rk-alerts:houserob",function(targetCoords)
    TriggerClientEvent('rk-alerts:houserobbery', -1, targetCoords)
	return
end)

RegisterServerEvent("rk-alerts:tbank")
AddEventHandler("rk-alerts:tbank",function(targetCoords)
    TriggerClientEvent('rk-alerts:banktruck', -1, targetCoords)
	return
end)

RegisterServerEvent("rk-alerts:robjew")
AddEventHandler("rk-alerts:robjew",function()
    TriggerClientEvent('rk-alerts:jewelrobbey', -1)
	return
end)

RegisterServerEvent("rk-alerts:bjail")
AddEventHandler("rk-alerts:bjail",function()
    TriggerClientEvent('rk-alerts:jewelrobbey', -1)
	return
end)

RegisterServerEvent("rk-alerts:gunshots")
AddEventHandler("rk-alerts:gunshots", function(targetCoords)
    TriggerClientEvent('rk-outlawalert:gunshotInProgress', -1, targetCoords)
end)