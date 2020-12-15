HHCore = nil

TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)

AddEventHandler('hhrp:playerLoaded', function(source)
	TriggerEvent('hhrp-license:getLicenses', source, function(licenses)
		TriggerClientEvent('hhrp-dmvschool:loadLicenses', source, licenses)
	end)
end)

RegisterNetEvent('hhrp-dmvschool:addLicense')
AddEventHandler('hhrp-dmvschool:addLicense', function(type)
	local _source = source

	TriggerEvent('hhrp-license:addLicense', _source, type, function()
		TriggerEvent('hhrp-license:getLicenses', _source, function(licenses)
			TriggerClientEvent('hhrp-dmvschool:loadLicenses', _source, licenses)
		end)
	end)
end)

RegisterNetEvent('hhrp-dmvschool:pay')
AddEventHandler('hhrp-dmvschool:pay', function(price)
	local _source = source
	local xPlayer = HHCore.GetPlayerFromId(_source)

	xPlayer.removeMoney(price)
	TriggerClientEvent('DoLongHudText', _source, 'You paid $'.. HHCore.Math.GroupDigits(price) .. ' to the DMV school', 1)
end)
