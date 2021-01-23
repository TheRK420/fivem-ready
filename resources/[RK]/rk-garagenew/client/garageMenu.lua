RKCore = nil

Citizen.CreateThread(function()
	while not RKCore do
		TriggerEvent("rk:getSharedObject", function(library) 
			RKCore = library 
		end)

		Citizen.Wait(0)
	end
end)

local ultimaAccion = nil
local currentGarage = nil
local fetchedVehicles = {}
local fueravehicles = {}


function MenuGarage(action)
    if not action then action = ultimaAccion; elseif not action and not ultimaAccion then action = "menu"; end
    ped = GetPlayerPed(-1);
    MenuTitle = "Garage"
    ClearMenu()
    ultimaAccion = action
    Citizen.Wait(150)
    DeleteActualVeh()
    if action == "menu" then
        Menu.addButton("See Vehicles","ListeVehicule",nil)
        Menu.addButton("Recover","recuperar",nil)
        Menu.addButton("Close","CloseMenu",nil) 
    elseif action == "vehicle" then
        PutInVehicle()
    end
end

function EnvioVehLocal(veh)
    local slots = {}
    for c,v in pairs(veh) do
        table.insert(slots,{["garage"] = v.garage, ["vehiculo"] = json.decode(v.vehicle)})
    end
    fetchedVehicles = slots
end

function EnvioVehFuera(data)
    local slots = {}
    for c,v in pairs(data) do
        if v.state == 0 or v.state == 2 or v.state == false or v.garage == nil then
            table.insert(slots,{["vehiculo"] = json.decode(v.vehicle),["state"] = v.state})
        end
    end
    fueravehicles = slots
end

function recuperar()
    currentGarage = cachedData["currentGarage"]

    if not currentGarage then
        CloseMenu()
        return 
    end

   HandleCamera(currentGarage, true)
   ped = GetPlayerPed(-1);
   MenuTitle = "Recover :"
   ClearMenu()
   Menu.addButton("return","MenuGarage",nil)
    for c,v in pairs(fueravehicles) do
        local vehicle = v.vehiculo
        if v.state == 0 or v.state == false then
            Menu.addButton("RECOVER | "..GetDisplayNameFromVehicleModel(vehicle.model), "pagorecupero", vehicle, "IN RECOVERY", " Engine : " .. round(vehicle.engineHealth) /10 .. "%", " Fuel : " .. round(vehicle.fuelLevel) .. "%","SpawnLocalVehicle")
        end
    end 
end

function pagorecupero(data)
    RKCore.TriggerServerCallback('betrayed_garage:checkMoney', function(hasEnoughMoney) 
    
        if hasEnoughMoney == true then
            SpawnVehicle({data,nil},nil)            
            exports['mythic_notify']:DoHudText('success', 'You Paid $2000 towards Impound Charges')	
        else
            recuperar()
            exports['mythic_notify']:DoHudText('error', 'You dont have enough money')							
        end
    end)
end


function AbrirMenuGuardar()
    currentGarage = cachedData["currentGarage"]
    if not currentGarage then
        CloseMenu()
        return 
    end
   ped = GetPlayerPed(-1);
   MenuTitle = "Save :"
   ClearMenu()
   Menu.addButton("Close","CloseMenu",nil)
   Menu.addButton("GARAGE: "..currentGarage.." | SAVE", "SaveInGarage", currentGarage, "", "", "","DeleteActualVeh")
end

function ListeVehicule()
    currentGarage = cachedData["currentGarage"]

    if not currentGarage then
        CloseMenu()
        return 
    end

   HandleCamera(currentGarage, true)
   ped = GetPlayerPed(-1);
   MenuTitle = "My vehicles :"
   ClearMenu()
   Menu.addButton("Return","MenuGarage",nil)
    for c,v in pairs(fetchedVehicles) do
        if v then
            local vehicle = v.vehiculo
            Menu.addButton("" ..(vehicle.plate).." | "..GetDisplayNameFromVehicleModel(vehicle.model), "OptionVehicle", {vehicle,nil}, "STORED - Garage: "..currentGarage.."", " Engine : " .. round(vehicle.engineHealth) /10 .. "%", " Fuel : " .. round(vehicle.fuelLevel) .. "%","SpawnLocalVehicle")
        end
    end
end

function round(n)
    if not n then return 0; end
    return n % 1 >= 0.5 and math.ceil(n) or math.floor(n)
end

function OptionVehicle(data)      
   MenuTitle = "Options :"
   ClearMenu()
   print(json.encode(data))
   Menu.addButton("Take", "SpawnVehicle", data)
   Menu.addButton("Return", "ListeVehicule", nil)
end

function CloseMenu()
    HandleCamera(currentGarage, false)
	TriggerEvent("inmenu",false)
    Menu.hidden = true
end

function LocalPed()
	return GetPlayerPed(-1)
end
