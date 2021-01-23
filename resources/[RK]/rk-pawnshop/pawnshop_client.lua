local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
}

RKCore = nil 

local PlayerData              = {}

Citizen.CreateThread(function ()
    while RKCore == nil do
        TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)
        Citizen.Wait(1)
    end

    while RKCore.GetPlayerData() == nil do
        Citizen.Wait(10)
    end

    PlayerData = RKCore.GetPlayerData()
end) 

RegisterNetEvent('rk:playerLoaded')
AddEventHandler('rk:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

--------------  Pawn Shop ---------------------------
function hintToDisplay(text)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function DrawText3D(x, y, z, text, scale)
  local onScreen, _x, _y = World3dToScreen2d(x, y, z)
  local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

  SetTextScale(0.35, 0.35)
  SetTextFont(4)
  SetTextProportional(1)
  SetTextColour(255, 255, 255, 215)

  SetTextEntry("STRING")
  SetTextCentre(1)
  AddTextComponentString(text)
  DrawText(_x,_y)
  local factor = (string.len(text)) / 370
  DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

local gym = {
  {x = 412.31, y = 314.11, z = 103.02}
}

Citizen.CreateThread(function()
  while true do
      Citizen.Wait(0)
      for k in pairs(gym) do
          DrawMarker(21, gym[k].x, gym[k].y, gym[k].z, 0, 0, 0, 0, 0, 0, 0.301, 0.301, 0.3001, 0, 153, 255, 255, 0, 0, 0, 0)
      end
  end
end)

Citizen.CreateThread(function()
  while true do
      Citizen.Wait(0)
      for k in pairs(gym) do
        local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
        local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, gym[k].x, gym[k].y, gym[k].z)
        if dist <= 0.5 then
          DrawText3D(plyCoords.x, plyCoords.y, plyCoords.z, "~w~Press ~r~[E] ~w~ to use pawn shop!", 0.4)
          if IsControlJustPressed(0, Keys['E'])then
            OpenSellMenu()
          end
        end		
      end
  end
end)

function OpenSellMenu()
  RKCore.UI.Menu.CloseAll()

  RKCore.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'pawn_sell_menu',
      {
          title    = 'rk Pawnshop',
          elements = {
              {label = 'Goldbar ($1500)', value = 'goldbar'},
              {label = 'Steel ($400)', value = 'steel'},
              {label = 'Aluminium ($300)', value = 'alu'},
              {label = 'Copper ($150)', value = 'copper'},
          }
      },
      function(data, menu)
		      if data.current.value == 'goldbar' then
              TriggerEvent('rk-pawnshop:sellgoldbarscl')
          elseif data.current.value == 'steel' then
            TriggerEvent('rk-pawnshop:sellsteelscl')
          elseif data.current.value == 'alu' then
            TriggerEvent('rk-pawnshop:sellaluscl')
          elseif data.current.value == 'copper' then
            TriggerEvent('rk-pawnshop:sellcoppercl')
          end
      end,
      function(data, menu)
          menu.close()
      end
  )
end

RegisterNetEvent('rk-pawnshop:selljewelscl')
AddEventHandler('rk-pawnshop:selljewelscl', function()
  if exports['rk-inventory']:hasEnoughOfItem('water', 1) then
    TriggerServerEvent('rk-pawnshop:selljewels')
    TriggerEvent('OpenInv')
    TriggerEvent('inventory:removeItem', 'water', 1)
    TriggerEvent('DoLongHudText', 'You sold 1 jewel for $50', 1) 
  else 
    TriggerEvent('DoLongHudText', 'You don\'t enough jewels to sell!', 2) 
  end
end)

RegisterNetEvent('rk-pawnshop:sellgoldbarcl')
AddEventHandler('rk-pawnshop:sellgoldbarscl', function()
  if exports['rk-inventory']:hasEnoughOfItem('goldbar', 1) then
    local amt = exports['rk-inventory']:getQuantity('goldbar')
    TriggerServerEvent('rk-pawnshop:sellgoldbar', amt)
    TriggerEvent('OpenInv')
    TriggerEvent('inventory:removeItem', 'goldbar', amt)
    TriggerEvent('DoLongHudText', 'You sold '..amt..' goldbar for $'.. 1500*amt, 1) 
  else 
    TriggerEvent('DoLongHudText', 'You don\'t enough goldbar to sell!', 2) 
  end
end)

RegisterNetEvent('rk-pawnshop:sellsteelcl')
AddEventHandler('rk-pawnshop:sellsteelscl', function()
  if exports['rk-inventory']:hasEnoughOfItem('steel', 1) then
    local amt = exports['rk-inventory']:getQuantity('steel')
    TriggerServerEvent('rk-pawnshop:sellsteel', amt)
    TriggerEvent('OpenInv')
    TriggerEvent('inventory:removeItem', 'steel', amt)
    TriggerEvent('DoLongHudText', 'You sold '..amt..' steel for $'.. 400*amt, 1)
  else 
    TriggerEvent('DoLongHudText', 'You don\'t enough steel to sell!', 2) 
  end
end)

RegisterNetEvent('rk-pawnshop:sellalucl')
AddEventHandler('rk-pawnshop:sellaluscl', function()
  if exports['rk-inventory']:hasEnoughOfItem('aluminium', 1) then
    local amt = exports['rk-inventory']:getQuantity('aluminium')
    TriggerServerEvent('rk-pawnshop:sellalu', amt)
    TriggerEvent('OpenInv')
    TriggerEvent('inventory:removeItem', 'aluminium', amt)
    TriggerEvent('DoLongHudText', 'You sold '..amt..' aluminium for $'.. 300*amt, 1) 
  else 
    TriggerEvent('DoLongHudText', 'You don\'t enough aluminium to sell!', 2) 
  end
end)

RegisterNetEvent('rk-pawnshop:sellcoppercl')
AddEventHandler('rk-pawnshop:sellcoppercl', function()
  if exports['rk-inventory']:hasEnoughOfItem('copper', 1) then
    local amt = exports['rk-inventory']:getQuantity('copper')
    TriggerServerEvent('rk-pawnshop:sellcopper', amt)
    TriggerEvent('OpenInv')
    TriggerEvent('inventory:removeItem', 'copper', amt)
    TriggerEvent('DoLongHudText', 'You sold '..amt..' copper for $'.. 150*amt, 1) 
  else 
    TriggerEvent('DoLongHudText', 'You don\'t enough copper to sell!', 2) 
  end
end)