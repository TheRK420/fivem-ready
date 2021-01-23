RKCore = nil
TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)
---------- Pawn Shop --------------

RegisterServerEvent('rk-pawnshop:selljewels')
AddEventHandler('rk-pawnshop:selljewels', function()
local _source = source
local xPlayer = RKCore.GetPlayerFromId(_source)
	xPlayer.addMoney(50)
end)

RegisterServerEvent('rk-pawnshop:sellgoldbar')
AddEventHandler('rk-pawnshop:sellgoldbar', function(amt)
local _source = source
local xPlayer = RKCore.GetPlayerFromId(_source)
local money = 1500*amt
	xPlayer.addMoney(money)
end)

RegisterServerEvent('rk-pawnshop:sellsteel')
AddEventHandler('rk-pawnshop:sellsteel', function(amt)
local _source = source
local xPlayer = RKCore.GetPlayerFromId(_source)
local money = 400*amt
	xPlayer.addMoney(money)
end)

RegisterServerEvent('rk-pawnshop:sellalu')
AddEventHandler('rk-pawnshop:sellalu', function(amt)
local _source = source
local xPlayer = RKCore.GetPlayerFromId(_source)
local money = 300*amt
	xPlayer.addMoney(money)
end)

RegisterServerEvent('rk-pawnshop:sellcopper')
AddEventHandler('rk-pawnshop:sellcopper', function(amt)
local _source = source
local xPlayer = RKCore.GetPlayerFromId(_source)
local money = 150*amt
	xPlayer.addMoney(money)
end)