RKCore = nil
TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)

-- Code

RKCore.RegisterUsableItem('radio', function(source, item)
   local xPlayer = RKCore.GetPlayerFromId(source)
   TriggerClientEvent('radio:itemradio', source)
end)

-- checking is player have item
-- Citizen.CreateThread(function()
--     while true do
--     Citizen.Wait(120000)
--       local xPlayers = RKCore.GetPlayers()
--       for i=1, #xPlayers, 1 do
--           local xPlayer = RKCore.GetPlayerFromId(xPlayers[i])
--             if xPlayer ~= nil then
--                 if xPlayer.getInventoryItem('radio').count == 0 then
--                   local source = xPlayers[i]
--                   TriggerClientEvent('radio:ondrop', source)                                                      
--                end
--            end
--        end
--     end
-- end)
