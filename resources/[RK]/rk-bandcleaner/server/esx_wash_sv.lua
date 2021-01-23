RKCore = nil
TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)

RegisterServerEvent('rk_moneywash:withdraw')
AddEventHandler('rk_moneywash:withdraw', function(amount)
	local _source = source
	local xPlayer = RKCore.GetPlayerFromId(_source)
	amount = tonumber(amount)
	local accountMoney = 0
	TriggerEvent("rk:washingmoneyalert",xPlayer.name,amount)
	xPlayer.addMoney(amount)
	TriggerClientEvent('rk:showNotification', _source, _U('wash_money') .. amount .. '~s~.')
	--TriggerClientEvent('rk_moneywash:closeWASH', _source)
end)