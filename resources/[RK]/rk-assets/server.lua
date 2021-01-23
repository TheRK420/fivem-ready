RKCore = nil

TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)

RegisterServerEvent('CrashTackle')
AddEventHandler('CrashTackle', function(target)
	TriggerClientEvent("playerTackled", target)
end)

--TPM

RKCore.RegisterServerCallback("tpm:fetchUserRank", function(source, cb)
    local player = RKCore.GetPlayerFromId(source)

    if player ~= nil then
        local playerGroup = player.getGroup()

        if playerGroup ~= nil then 
            cb(playerGroup)
        else
            cb("user")
        end
    else
        cb("user")
    end
end)

--- SUPTIME ---

Citizen.CreateThread(function()
	local starttick = GetGameTimer()
	while true do
		Citizen.Wait(15000) -- check all 15 seconds
		local tick = GetGameTimer()
		local uptimeDay = math.floor((tick-starttick)/86400000)
        local uptimeHour = math.floor((tick-starttick)/3600000) % 24
		local uptimeMinute = math.floor((tick-starttick)/60000) % 60
		local uptimeSecond = math.floor((tick-starttick)/1000) % 60
		ExecuteCommand(string.format("sets Uptime \"%2d Days %2d Hours %2d Minutes %2d Seconds\"", uptimeDay, uptimeHour, uptimeMinute, uptimeSecond))
	end
end)


RegisterServerEvent('removecash:checkmoney')
AddEventHandler('removecash:checkmoney', function(money)
    local source = source
    local xPlayer  = RKCore.GetPlayerFromId(source)
    if money ~= nil then
        xPlayer.removeMoney(money)
    end
end)

RegisterServerEvent("heli:spotlight")
AddEventHandler(
	"heli:spotlight",
	function(state)
		local serverID = source
		TriggerClientEvent("heli:spotlight", -1, serverID, state)
	end
)