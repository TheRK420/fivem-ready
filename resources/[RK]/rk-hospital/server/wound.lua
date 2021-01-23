local playerInjury = {}

function GetCharsInjuries(source)
    return playerInjury[source]
end

RegisterServerEvent('rk-hospital:server:SyncInjuries')
AddEventHandler('rk-hospital:server:SyncInjuries', function(data)
    playerInjury[source] = data
end)