RKCore = nil

TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)

AddEventHandler('rk:playerLoaded', function(source)
	TriggerEvent('rk-license:getLicenses', source, function(licenses)
		TriggerClientEvent('rk-dmvschool:loadLicenses', source, licenses)
	end)
end)

RegisterNetEvent('rk-dmvschool:addLicense')
AddEventHandler('rk-dmvschool:addLicense', function(type)
	local _source = source

	TriggerEvent('rk-license:addLicense', _source, type, function()
		TriggerEvent('rk-license:getLicenses', _source, function(licenses)
			TriggerClientEvent('rk-dmvschool:loadLicenses', _source, licenses)
		end)
	end)
end)

RegisterNetEvent('rk-dmvschool:pay')
AddEventHandler('rk-dmvschool:pay', function(price)
	local _source = source
	local xPlayer = RKCore.GetPlayerFromId(_source)

	xPlayer.removeMoney(price)
	TriggerClientEvent('DoLongHudText', _source, 'You paid $'.. RKCore.Math.GroupDigits(price) .. ' to the DMV school', 1)
end)
