HHCore  = nil

TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)

HHCore.RegisterUsableItem('radio', function(source)
	local xPlayer = HHCore.GetPlayerFromId(source)
	TriggerClientEvent('ls-radio:use', source)

end)

-- checking is player have item

-- Citizen.CreateThread(function()
--   while true do
--     Citizen.Wait(1000)
--     local xPlayers = HHCore.GetPlayers()
--     for i=1, #xPlayers, 1 do
--         local xPlayer = HHCore.GetPlayerFromId(xPlayers[i])
--           if xPlayer ~= nil then
--               if xPlayer.getInventoryItem('radio').count == 0 then
--                 local source = xPlayers[i]                
--                 TriggerClientEvent('ls-radio:onRadioDrop', source)
--                 break
--               end
--             end
--           end
--         end
--       end)
