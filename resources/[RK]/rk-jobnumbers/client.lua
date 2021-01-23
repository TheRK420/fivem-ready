local JobCount = {}


Citizen.CreateThread(function()
    while RKCore == nil do
		TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)
		Citizen.Wait(0)
	end
	while RKCore.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
	PlayerData = RKCore.GetPlayerData()
end)

RegisterNetEvent('rk:setJob')
AddEventHandler('rk:setJob', function(job)
	PlayerData.job = job
	TriggerServerEvent('rk-jobnumbers:setjobs', job)
end)

RegisterNetEvent('rk:playerLoaded')
AddEventHandler('rk:playerLoaded', function(xPlayer)
    TriggerServerEvent('rk-jobnumbers:setjobs', xPlayer.job)
end)


RegisterNetEvent('rk-jobnumbers:setjobs')
AddEventHandler('rk-jobnumbers:setjobs', function(jobslist)
   JobCount = jobslist
end)

function jobonline(joblist)
    for i,v in pairs(Config.MultiNameJobs) do
        for u,c in pairs(v) do
            if c == joblist then
                joblist = i
            end
        end
    end

    local amount = 0
    local job = joblist
    if JobCount[job] ~= nil then
        amount = JobCount[job]
    end

    return amount
end


