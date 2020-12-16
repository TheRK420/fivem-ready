ESX = nil

TriggerEvent('cc:getSharedObjectterabaap', function(obj) ESX = obj end)
-- Code

ESX.RegisterUsableItem('radio', function(source, item)
   local xPlayer = ESX.GetPlayerFromId(source)
   TriggerClientEvent('radio:itemradio', source)
end)

-- checking is player have item
Citizen.CreateThread(function()
    while true do
    Citizen.Wait(1000)
      local xPlayers = ESX.GetPlayers()
      for i=1, #xPlayers, 1 do
          local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if xPlayer ~= nil then
                if xPlayer.getInventoryItem('radio').count == 0 then
                  local source = xPlayers[i]
                  TriggerClientEvent('radio:ondrop', source)                                                      
               end
           end
       end
    end
end)
