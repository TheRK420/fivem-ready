HHCore = nil
TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)

-- Code

HHCore.RegisterUsableItem('radio', function(source, item)
   local xPlayer = HHCore.GetPlayerFromId(source)
   TriggerClientEvent('radio:itemradio', source)
end)

-- checking is player have item
-- Citizen.CreateThread(function()
--     while true do
--     Citizen.Wait(120000)
--       local xPlayers = HHCore.GetPlayers()
--       for i=1, #xPlayers, 1 do
--           local xPlayer = HHCore.GetPlayerFromId(xPlayers[i])
--             if xPlayer ~= nil then
--                 if xPlayer.getInventoryItem('radio').count == 0 then
--                   local source = xPlayers[i]
--                   TriggerClientEvent('radio:ondrop', source)                                                      
--                end
--            end
--        end
--     end
-- end)
