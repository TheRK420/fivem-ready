HHCore = nil
TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)
---------- Pawn Shop --------------

RegisterServerEvent('hhrp-pawnshop:selljewels')
AddEventHandler('hhrp-pawnshop:selljewels', function()
local _source = source
local xPlayer = HHCore.GetPlayerFromId(_source)
	xPlayer.addMoney(50)
end)

RegisterServerEvent('hhrp-pawnshop:sellgoldbar')
AddEventHandler('hhrp-pawnshop:sellgoldbar', function(amt)
local _source = source
local xPlayer = HHCore.GetPlayerFromId(_source)
local money = 1500*amt
	xPlayer.addMoney(money)
end)

RegisterServerEvent('hhrp-pawnshop:sellsteel')
AddEventHandler('hhrp-pawnshop:sellsteel', function(amt)
local _source = source
local xPlayer = HHCore.GetPlayerFromId(_source)
local money = 400*amt
	xPlayer.addMoney(money)
end)

RegisterServerEvent('hhrp-pawnshop:sellalu')
AddEventHandler('hhrp-pawnshop:sellalu', function(amt)
local _source = source
local xPlayer = HHCore.GetPlayerFromId(_source)
local money = 300*amt
	xPlayer.addMoney(money)
end)

RegisterServerEvent('hhrp-pawnshop:sellcopper')
AddEventHandler('hhrp-pawnshop:sellcopper', function(amt)
local _source = source
local xPlayer = HHCore.GetPlayerFromId(_source)
local money = 150*amt
	xPlayer.addMoney(money)
end)