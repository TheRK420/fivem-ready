TryToSell = function(pedId, coords)
    if not DoesEntityExist(pedId) or IsPedDeadOrDying(pedId) or IsPedAPlayer(pedId) or IsPedFalling(pedId) then
        Citizen.Trace("disc-drugsales: ped: " .. pedId .. " not able to sell to.")
        return
    end
    cachedPeds[pedId] = true

    ClearPedTasksImmediately(pedId)

    math.randomseed(GetGameTimer())

    local canSell = math.random(0, 100)

    if canSell > Config.NotifyCopsPercentage then
        TaskTurnPedToFaceEntity(pedId, PlayerPedId(), Config.DiscussTime)
        PlayAnim(PlayerPedId(), 'misscarsteal4@actor', 'actor_berating_loop')
        Citizen.Wait(Config.DiscussTime / 2)
        PlayAnim(pedId, 'mp_common', 'givetake1_a')
        Sell()
        Citizen.Wait(Config.DiscussTime / 6)
        PlayAnim(PlayerPedId(), 'mp_common', 'givetake1_a')
    else
        TaskTurnPedToFaceEntity(pedId, PlayerPedId(), Config.DiscussTime)
        PlayAnim(PlayerPedId(), 'misscarsteal4@actor', 'actor_berating_loop')
        Citizen.Wait(Config.DiscussTime / 2)
        serverId = GetPlayerServerId(PlayerId())
        --message = 'Dispatch Message: Drug Sale Attempt in progress'
        --TriggerServerEvent('hhrp_addons_gcphone:startCall', 'police', message, coords)
        --TriggerEvent("civilian:alertPolice",150,"drugsale",0,false)
        TriggerEvent('hhrp-dispatch:drugjob')
        local playerGender = 0
        local streetName = GetStreetAndZone()
        local pcoords = GetEntityCoords(PlayerPedId())
        TriggerServerEvent('hhrp_outlawalert:DrugSaleInProgress', {
            x = HHCore.Math.Round(pcoords.x, 1),
            y = HHCore.Math.Round(pcoords.y, 1),
            z = HHCore.Math.Round(pcoords.z, 1)
        }, streetName, playerGender)

        TriggerServerEvent("dispatch:svNotify", {
            dispatchCode = "10-38",
            firstStreet = GetStreetAndZone(),
            callSign = currentCallSign,
            isImportant = true,
            priority = 2,
            dispatchMessage = "Drugsale In Progress",
            origin = {
                x = pcoords.x,
                y = pcoords.y,
                z = pcoords.z
              }
        })
        exports['mythic_notify']:DoHudText('error', "Are you stupid? I'm calling the Cops!")
    end
    ClearPedTasks(PlayerPedId())
end
TryToSellcoke = function(pedId, coords)
    if not DoesEntityExist(pedId) or IsPedDeadOrDying(pedId) or IsPedAPlayer(pedId) or IsPedFalling(pedId) then
        Citizen.Trace("disc-drugsales: ped: " .. pedId .. " not able to sell to.")
        return
    end

    cachedPeds[pedId] = true

    ClearPedTasksImmediately(pedId)

    math.randomseed(GetGameTimer())

    local canSell = math.random(0, 100)

    if canSell > Config.NotifyCopsPercentage then
        TaskTurnPedToFaceEntity(pedId, PlayerPedId(), Config.DiscussTime)
        PlayAnim(PlayerPedId(), 'misscarsteal4@actor', 'actor_berating_loop')
        Citizen.Wait(Config.DiscussTime / 2)
        PlayAnim(pedId, 'mp_common', 'givetake1_a')
        Sellcoke()
        Citizen.Wait(Config.DiscussTime / 6)
        PlayAnim(PlayerPedId(), 'mp_common', 'givetake1_a')
    else
        TaskTurnPedToFaceEntity(pedId, PlayerPedId(), Config.DiscussTime)
        PlayAnim(PlayerPedId(), 'misscarsteal4@actor', 'actor_berating_loop')
        Citizen.Wait(Config.DiscussTime / 2)
        serverId = GetPlayerServerId(PlayerId())
        --message = 'Dispatch Message: Drug Sale Attempt in progress'
        --TriggerServerEvent('hhrp_addons_gcphone:startCall', 'police', message, coords)
        --TriggerEvent("civilian:alertPolice",150,"drugsale",0,false)
        TriggerEvent('hhrp-dispatch:drugjob')

        exports['mythic_notify']:DoHudText('error', "Are you stupid? I'm calling the Cops!")
        local playerGender = 0
        local streetName = GetStreetAndZone()
        local pcoords = GetEntityCoords(PlayerPedId())
        TriggerServerEvent('hhrp_outlawalert:DrugSaleInProgress', {
            x = HHCore.Math.Round(pcoords.x, 1),
            y = HHCore.Math.Round(pcoords.y, 1),
            z = HHCore.Math.Round(pcoords.z, 1)
        }, streetName, playerGender)

        TriggerServerEvent("dispatch:svNotify", {
            dispatchCode = "10-38",
            firstStreet = GetStreetAndZone(),
            callSign = currentCallSign,
            isImportant = true,
            priority = 2,
            dispatchMessage = "Drugsale In Progress",
            origin = {
                x = pcoords.x,
                y = pcoords.y,
                z = pcoords.z
              }
        })
    end
    ClearPedTasks(PlayerPedId())
end
TryToSellmarijuana = function(pedId, coords)
    if not DoesEntityExist(pedId) or IsPedDeadOrDying(pedId) or IsPedAPlayer(pedId) or IsPedFalling(pedId) then
        Citizen.Trace("disc-drugsales: ped: " .. pedId .. " not able to sell to.")
        return
    end

    cachedPeds[pedId] = true

    ClearPedTasksImmediately(pedId)

    math.randomseed(GetGameTimer())

    local canSell = math.random(0, 100)

    if canSell > Config.NotifyCopsPercentage then
        TaskTurnPedToFaceEntity(pedId, PlayerPedId(), Config.DiscussTime)
        PlayAnim(PlayerPedId(), 'misscarsteal4@actor', 'actor_berating_loop')
        Citizen.Wait(Config.DiscussTime / 2)
        PlayAnim(pedId, 'mp_common', 'givetake1_a')
        Sellmarijuana()
        Citizen.Wait(Config.DiscussTime / 6)
        PlayAnim(PlayerPedId(), 'mp_common', 'givetake1_a')
    else
        TaskTurnPedToFaceEntity(pedId, PlayerPedId(), Config.DiscussTime)
        PlayAnim(PlayerPedId(), 'misscarsteal4@actor', 'actor_berating_loop')
        Citizen.Wait(Config.DiscussTime / 2)
        serverId = GetPlayerServerId(PlayerId())
        --message = 'Dispatch Message: Drug Sale Attempt in progress'
        --TriggerServerEvent('hhrp_addons_gcphone:startCall', 'police', message, coords)
        --TriggerEvent("civilian:alertPolice",150,"drugsale",0,false)
        TriggerEvent('hhrp-dispatch:drugjob')
        local playerGender = 0
        local streetName = GetStreetAndZone()
        local pcoords = GetEntityCoords(PlayerPedId())
        TriggerServerEvent('hhrp_outlawalert:DrugSaleInProgress', {
            x = HHCore.Math.Round(pcoords.x, 1),
            y = HHCore.Math.Round(pcoords.y, 1),
            z = HHCore.Math.Round(pcoords.z, 1)
        }, streetName, playerGender)

        TriggerServerEvent("dispatch:svNotify", {
            dispatchCode = "10-38",
            firstStreet = GetStreetAndZone(),
            callSign = currentCallSign,
            isImportant = true,
            priority = 2,
            dispatchMessage = "Drugsale In Progress",
            origin = {
                x = pcoords.x,
                y = pcoords.y,
                z = pcoords.z
              }
        })
        exports['mythic_notify']:DoHudText('error', "Are you stupid? I'm calling the Cops!")
    end
    ClearPedTasks(PlayerPedId())
end
TryToSelloxy = function(pedId, coords)
    if not DoesEntityExist(pedId) or IsPedDeadOrDying(pedId) or IsPedAPlayer(pedId) or IsPedFalling(pedId) then
        Citizen.Trace("disc-drugsales: ped: " .. pedId .. " not able to sell to.")
        return
    end

    cachedPeds[pedId] = true

    ClearPedTasksImmediately(pedId)

    math.randomseed(GetGameTimer())

    local canSell = math.random(0, 100)

    if canSell > 50 then
        TaskTurnPedToFaceEntity(pedId, PlayerPedId(), Config.DiscussTime)
        PlayAnim(PlayerPedId(), 'misscarsteal4@actor', 'actor_berating_loop')
        Citizen.Wait(Config.DiscussTime / 2)
        PlayAnim(pedId, 'mp_common', 'givetake1_a')
        Selloxy()
        Citizen.Wait(Config.DiscussTime / 6)
        PlayAnim(PlayerPedId(), 'mp_common', 'givetake1_a')
    else
        TaskTurnPedToFaceEntity(pedId, PlayerPedId(), Config.DiscussTime)
        PlayAnim(PlayerPedId(), 'misscarsteal4@actor', 'actor_berating_loop')
        Citizen.Wait(Config.DiscussTime / 2)
        serverId = GetPlayerServerId(PlayerId())
        --message = 'Dispatch Message: Drug Sale Attempt in progress'
        --TriggerServerEvent('hhrp_addons_gcphone:startCall', 'police', message, coords)
        --TriggerEvent("civilian:alertPolice",150,"drugsale",0,false)
        TriggerEvent('hhrp-dispatch:drugjob')
        local playerGender = 0
        local streetName = GetStreetAndZone()
        local pcoords = GetEntityCoords(PlayerPedId())
        TriggerServerEvent('hhrp_outlawalert:DrugSaleInProgress', {
            x = HHCore.Math.Round(pcoords.x, 1),
            y = HHCore.Math.Round(pcoords.y, 1),
            z = HHCore.Math.Round(pcoords.z, 1)
        }, streetName, playerGender)
        exports['mythic_notify']:DoHudText('error', "Are you stupid? I'm calling the Cops!")
    end
    ClearPedTasks(PlayerPedId())
end

Sell = function()
    if exports['hhrp-inventory']:hasEnoughOfItem('methbag', 1) then
        TriggerEvent("inventory:removeItem", "methbag", 1)
        HHCore.TriggerServerCallback("disc-drugsales:sellDrug", function(soldDrug)
            if soldDrug then
                exports['mythic_notify']:DoHudText('success', "Thanks! Here's $" .. soldDrug)
            end
        end)
    else
        exports['mythic_notify']:DoHudText('error', "Well don't try to waste my time if you don't even have something to sell?")
    end
end
Sellcoke = function()
    if exports['hhrp-inventory']:hasEnoughOfItem('1gcocaine', 1) then
        TriggerEvent("inventory:removeItem", "1gcocaine", 1)
        HHCore.TriggerServerCallback("disc-drugsales:sellDrugcoke", function(soldDrug)
            if soldDrug then
                exports['mythic_notify']:DoHudText('success', "Thanks! Here's $" .. soldDrug)
            end
        end)
    else
        exports['mythic_notify']:DoHudText('error', "Well don't try to waste my time if you don't even have something to sell?")
    end
end
Sellmarijuana = function()
    if exports['hhrp-inventory']:hasEnoughOfItem('weedq', 1) then
        TriggerEvent("inventory:removeItem", "weedq", 1)
        HHCore.TriggerServerCallback("disc-drugsales:sellDrugmarijuana", function(soldDrug)
            if soldDrug then
                exports['mythic_notify']:DoHudText('success', "Thanks! Here's $" .. soldDrug)
            end
        end)
    else
        exports['mythic_notify']:DoHudText('error', "Well don't try to waste my time if you don't even have something to sell?")
    end
end
Selloxy = function()
    if exports['hhrp-inventory']:hasEnoughOfItem('oxy', 1) then
        TriggerEvent("inventory:removeItem", "oxy", 1)
        HHCore.TriggerServerCallback("disc-drugsales:sellDrugoxy", function(soldDrug)
            if soldDrug then
                exports['mythic_notify']:DoHudText('success', "Thanks! Here's $" .. soldDrug)
            end
        end)
    else
        exports['mythic_notify']:DoHudText('error', "Well don't try to waste my time if you don't even have something to sell?")
    end
end

function PlayAnim(ped, lib, anim, r)
    HHCore.Streaming.RequestAnimDict(lib, function()
        TaskPlayAnim(ped, lib, anim, 8.0, -8, -1, r and 49 or 0, 0, 0, 0, 0)
    end)
end


function GetStreetAndZone()
	local plyPos = GetEntityCoords(PlayerPedId(), true)
	local s1, s2 = Citizen.InvokeNative( 0x2EB41072B4C1E4C0, plyPos.x, plyPos.y, plyPos.z, Citizen.PointerValueInt(), Citizen.PointerValueInt() )
	local street1 = GetStreetNameFromHashKey(s1)
	local street2 = GetStreetNameFromHashKey(s2)
	local zone = GetLabelText(GetNameOfZone(plyPos.x, plyPos.y, plyPos.z))
	local street = street1 .. ", " .. zone
	return street
end