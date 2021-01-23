RKCore = nil

local hasDrugs = false

cachedPeds = {}

--Clean ped cache to avoid memory leaks
Citizen.CreateThread(function()
    while true do
        cachedPeds = {}
        Citizen.Wait(300000)
    end
end)

Citizen.CreateThread(function()
    while RKCore == nil do
        TriggerEvent('rk:getSharedObject', function(obj)
            RKCore = obj
        end)
        Citizen.Wait(0)
    end

    while RKCore.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    PlayerData = RKCore.GetPlayerData()
end)

function canSell(pedId)
    return not IsPedSittingInAnyVehicle(pedId)
end

function canSellcoke(pedId)
    return not IsPedSittingInAnyVehicle(pedId)
end

function CanSellTo(pedId)
    return DoesEntityExist(pedId) and not IsPedDeadOrDying(pedId) and not IsPedAPlayer(pedId) and not IsPedFalling(pedId) and not cachedPeds[pedId] and not IsEntityAMissionEntity(ped)
end

function GetPedInFront()
    local player = PlayerId()
    local plyPed = GetPlayerPed(player)
    local plyPos = GetEntityCoords(plyPed, false)
    local plyOffset = GetOffsetFromEntityInWorldCoords(plyPed, 0.0, 1.3, 0.0)
    local rayHandle = StartShapeTestCapsule(plyPos.x, plyPos.y, plyPos.z, plyOffset.x, plyOffset.y, plyOffset.z, 1.0, 12, plyPed, 7)
    local _, _, _, _, ped = GetShapeTestResult(rayHandle)
    return ped
end

Citizen.CreateThread(function()
    Citizen.Wait(0)

    while true do
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        local closestPed = GetPedInFront()
        local closestpedCoords = GetEntityCoords(closestPed)
        local zone = GetNameOfZone(1135.37, -728.37, 56.74)
        local zone2 = GetNameOfZone(295.38, 179.25, 104.22)
        local zone3 = GetNameOfZone(89.23, -1926.78, 20.8)
        local zone4 = GetNameOfZone(36.98, -986.38, 29.52)
        local zoneforum = GetNameOfZone(-66.03,-1553.53, 31.46)
        local pedsel = GetEntityCoords(closestPed)
        local pedselzone = GetNameOfZone(pedsel)
        local dist = GetDistanceBetweenCoords(pedCoords.x, pedCoords.y, pedCoords.z, closestpedCoords.x, closestpedCoords.y, closestpedCoords.z, true)
        if dist <= 2 and pedselzone == zone or pedselzone == zone2 or pedselzone == zone3 or pedselzone == zoneforum  then

            local cs = canSell(PlayerPedId())
            local cst = CanSellTo(closestPed)


            if cs and cst then
                RKCore.ShowHelpNotification("~INPUT_CONTEXT~ to Sell Drugs")
            end

            if IsControlJustReleased(0, 38) and cs and cst then
                RKCore.TriggerServerCallback('disc-drugsales:getOnlinePolice',
                        function(online)
                                if not cachedPeds[closestPed] then
                                    if zone == pedselzone then
                                        if Config.CopsNeeded > online then
                                            exports['mythic_notify']:DoHudText('error', "Not enough cops in town! Need " .. Config.CopsNeeded)
                                        else
                                            showNotification = false
                                            TryToSell(closestPed, pedCoords)
                                            print(zone)
                                        end
                                    elseif zone2 == pedselzone then
                                        showNotification = false
                                        TryToSellcoke(closestPed, pedCoords)
                                        print(zone2)
                                    elseif zone3 == pedselzone or zoneforum == pedselzone then
                                        showNotification = false
                                        TryToSellmarijuana(closestPed, pedCoords)
                                        print(zone3)
                                        print(zoneforum)
                                    elseif zone4 == pedselzone then
                                        if 0 >= online then
                                            exports['mythic_notify']:DoHudText('error', "Not enough cops in town! Need 4! ")
                                        else
                                            showNotification = false
                                            TryToSelloxy(closestPed, pedCoords)
                                            print(zone4)
                                        end
                                    else
                                        exports['mythic_notify']:DoHudText('inform', "Are you sure you're at the right place?")
                                    end

                                else
                                    exports['mythic_notify']:DoHudText('inform', "You've already talked to me? Don't come up to me again.")
                                end
                        end)
            end
        end
        Citizen.Wait(0)
    end
end)

