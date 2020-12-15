HHCore = nil
TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)
---------- Pawn Shop --------------

RegisterServerEvent('hhrp-pawnshop:selljewels')
AddEventHandler('hhrp-pawnshop:selljewels', function()
local _source = source
local xPlayer = HHCore.GetPlayerFromId(_source)
	xPlayer.addMoney(50)
end)