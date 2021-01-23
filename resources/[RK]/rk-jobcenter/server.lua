
RKCore = nil

TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)

RegisterServerEvent('jobssystem:jobs')
AddEventHandler('jobssystem:jobs', function(job)
	local xPlayer = RKCore.GetPlayerFromId(source)

	if xPlayer then
		xPlayer.setJob(job, 0)
    end
    
end)