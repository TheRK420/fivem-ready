HHCore = nil
TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)

RegisterServerEvent('hhrp_moneywash:withdraw')
AddEventHandler('hhrp_moneywash:withdraw', function(amount)
	local _source = source
	local xPlayer = HHCore.GetPlayerFromId(_source)
	amount = tonumber(amount)
	local accountMoney = 0
	TriggerEvent("hhrp:washingmoneyalert",xPlayer.name,amount)
	xPlayer.addMoney(amount)
	TriggerClientEvent('hhrp:showNotification', _source, _U('wash_money') .. amount .. '~s~.')
	--TriggerClientEvent('hhrp_moneywash:closeWASH', _source)
end)