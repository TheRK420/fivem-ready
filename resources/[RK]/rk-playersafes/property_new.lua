local isPlayerSafe = false

RegisterNetEvent("rk_inventoryhud:openPropertyInventory")
AddEventHandler("rk_inventoryhud:openPropertyInventory", function(data, playerSafe)
    if playerSafe then isPlayerSafe = playerSafe; else isPlayerSafe = false; end
    setPropertyInventoryData(data)
    openPropertyInventory()
    end
)

function refreshPropertyInventory()
    if isPlayerSafe then
        RKCore.TriggerServerCallback('MF_PlayerSafes:GetSafeInventory', function(inventory) 
            setPropertyInventoryData(inventory); 
        end,isPlayerSafe.safeid)
    else
        RKCore.TriggerServerCallback("rk_property:getPropertyInventory",function(inventory)
            setPropertyInventoryData(inventory)
        end,RKCore.GetPlayerData().identifier)
    end
end

function setPropertyInventoryData(data)
    items = {}

    local blackMoney = data.blackMoney
    local propertyItems = data.items
    local propertyWeapons = data.weapons

    if blackMoney > 0 then
        accountData = {
            label = _U("black_money"),
            count = blackMoney,
            type = "item_account",
            name = "black_money",
            usable = false,
            rare = false,
            limit = -1,
            canRemove = false
        }
        table.insert(items, accountData)
    end

    for i = 1, #propertyItems, 1 do
        local item = propertyItems[i]

        if item.count > 0 then
            item.type = "item_standard"
            item.usable = false
            item.rare = false
            item.limit = -1
            item.canRemove = false

            table.insert(items, item)
        end
    end

    for i = 1, #propertyWeapons, 1 do
        local weapon = propertyWeapons[i]

        if propertyWeapons[i].name ~= "WEAPON_UNARMED" then
            table.insert(
                items,
                {
                    label = RKCore.GetWeaponLabel(weapon.name),
                    count = weapon.ammo,
                    limit = -1,
                    type = "item_weapon",
                    name = weapon.name,
                    usable = false,
                    rare = false,
                    canRemove = false
                }
            )
        end
    end

    SendNUIMessage(
        {
            action = "setSecondInventoryItems",
            itemList = items
        }
    )
end

function openPropertyInventory()
    loadPlayerInventory()
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "property"
        }
    )

    SetNuiFocus(true, true)
end

RegisterNUICallback(
    "PutIntoProperty",
    function(data, cb) 
        if IsPedSittingInAnyVehicle(playerPed) then
            return
        end

        print(data)
        for k,v in pairs(data) do print(k,v); end

        if type(data.number) == "number" and math.floor(data.number) == data.number then
            local count = tonumber(data.number)
            local isWeapon = false
            if data.item.type == "item_weapon" then
                isWeapon = true
                count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
            end

            if isPlayerSafe then       
                print("DOPUTSAFE")     
                TriggerServerEvent("MF_PlayerSafes:PutItem", RKCore.GetPlayerData().identifier, data.item.type, data.item.name, count, isPlayerSafe.safeid, isWeapon)
            else
                TriggerServerEvent("rk_property:putItem", RKCore.GetPlayerData().identifier, data.item.type, data.item.name, count)
            end
        end

        Wait(150)
        refreshPropertyInventory()
        Wait(150)
        loadPlayerInventory()

        cb("ok")
    end
)

RegisterNUICallback(
    "TakeFromProperty",
    function(data, cb)
        if IsPedSittingInAnyVehicle(playerPed) then
            return
        end

        if type(data.number) == "number" and math.floor(data.number) == data.number then
            if isPlayerSafe then
                TriggerServerEvent("MF_PlayerSafes:GetItem", RKCore.GetPlayerData().identifier, data.item.type, data.item.name, tonumber(data.number), isPlayerSafe.safeid)
            else
                TriggerServerEvent("rk_property:getItem", RKCore.GetPlayerData().identifier, data.item.type, data.item.name, tonumber(data.number))
            end
        end

        Wait(150)
        refreshPropertyInventory()
        Wait(150)
        loadPlayerInventory()

        cb("ok")
    end
)
