local playerInjury = {}

function GetCharsInjuries(source)
    return playerInjury[source]
end

RegisterServerEvent('hhrp-hospital:server:SyncInjuries')
AddEventHandler('hhrp-hospital:server:SyncInjuries', function(data)
    playerInjury[source] = data
end)