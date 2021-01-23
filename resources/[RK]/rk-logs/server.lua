-- Made by Tazio
-- RKCore = nil

-- TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)

-- settings = {
-- 	LogKills = true, -- Log when a player kill an other player.
-- 	LogEnterPoliceVehicle = true, -- Log when an player enter in a police vehicle.
-- 	LogEnterBlackListedVehicle = true, -- Log when a player enter in a blacklisted vehicle.
-- 	LogPedJacking = true, -- Log when a player is jacking a car
-- 	LogChatServer = true, -- Log when a player is talking in the chat , /command works too.
-- 	LogLoginServer = true, -- Log when a player is connecting/disconnecting to the server.
-- 	LogItemTransfer = true, -- Log when a player is giving an item.
-- 	LogWeaponTransfer = true, -- Log when a player is giving a weapon.
-- 	LogMoneyTransfer = true, -- Log when a player is giving money
-- 	LogMoneyBankTransfert = true, -- Log when a player is giving money from bankaccount

-- }

-- --Send the message to your discord server
-- function sendToDiscord3 (name,message,color)
--   local DiscordWebHook = Config.webhook
--   -- Modify here your discordWebHook username = name, content = message,embeds = embeds

-- local embeds = {
--     {
--         ["title"]=message,
--         ["type"]="rich",
--         ["color"] =color,
--         ["footer"]=  {
--             ["text"]= "RKCore-discord_bot_alert",
--        },
--     }
-- }

--   if message == nil or message == '' then return FALSE end
--   PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
-- end



-- -- Send the first notification
-- sendToDiscord3(_U('server'),_U('server_start'),Config.green)

-- -- Event when a player is writing
-- AddEventHandler('chatMessage', function(author, color, message)
--   if(settings.LogChatServer)then
--       local player = RKCore.GetPlayerFromId(author)
--      sendToDiscord3(_U('server_chat'), player.name .." : "..message,Config.grey)
--   end
-- end)


-- -- Event when a player is connecting
-- RegisterServerEvent("rk:playerconnected")
-- AddEventHandler('rk:playerconnected', function()
--   local xPlayer = RKCore.GetPlayerFromId(source)
--   local id = xPlayer.identifier
--   if(settings.LogLoginServer)then
--     sendToDiscord3(_U('server_connecting'), id .." ".. GetPlayerName(source) .." ".. _('user_connecting'),Config.grey)
--   end
-- end)

-- -- Event when a player is disconnecting
-- AddEventHandler('playerDropped', function(reason)
--   local xPlayer = RKCore.GetPlayerFromId(source)
--   local id = xPlayer.identifier
--   if(settings.LogLoginServer)then
--     sendToDiscord3(_U('server_disconnecting'),  id .." ".. GetPlayerName(source) .." ".. _('user_disconnecting') .. "("..reason..")",Config.grey)
--   end
-- end)

-- -- Add event when a player give an item
-- --  TriggerEvent("rk:giveitemalert",sourceXPlayer.name,targetXPlayer.name,RKCore.Items[itemName].label,itemCount) -> RKCore_extended
-- RegisterServerEvent("rk:giveitemalert")
-- AddEventHandler("rk:giveitemalert", function(name,nametarget,itemname,amount)
--    if(settings.LogItemTransfer)then
--     sendToDiscord3(_U('server_item_transfer'),name.._('user_gives_to')..nametarget.." "..amount .." "..itemname,Config.orange)
--    end
--   if itemName == 'money' then
--     local playerName = GetPlayerName(name)
--     local playerNametarget = GetPlayerName(nametarget)
--     local DiscordWebHook = "https://discordapp.com/api/webhooks/759475033914736641/-WHeAqzqNh-ZyU46azQd3YQVMhhcCmg0AzQEyyqP_sIrFskKBwJjCencvjWa2OEOjntx"
--      msgs = "```fix\nName : "..playerName.." ["..xPlayer.source.."]``````prolog\nHandedOverTo :"..playerNametarget.."``````xl\nMoneyAmount : "..amount.."```"
--     PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({content = msgs}), { ['Content-Type'] = 'application/json' })
--   end

-- end)

-- -- Add event when a player give money
-- -- TriggerEvent("rk:givemoneyalert",sourceXPlayer.name,targetXPlayer.name,itemCount) -> RKCore_extended
-- RegisterServerEvent("rk:givemoneyalert")
-- AddEventHandler("rk:givemoneyalert", function(name,nametarget,amount)
--   if(settings.LogMoneyTransfer)then
--     sendToDiscord3(_U('server_money_transfer'),name.." ".._('user_gives_to').." "..nametarget.." "..amount .." dollars",Config.orange)
--   end
--   local playerName = GetPlayerName(name)
--   local playerNametarget = GetPlayerName(nametarget)
--   local DiscordWebHook = "https://discordapp.com/api/webhooks/759475033914736641/-WHeAqzqNh-ZyU46azQd3YQVMhhcCmg0AzQEyyqP_sIrFskKBwJjCencvjWa2OEOjntx"
--    msgs = "```fix\nName : "..playerName.." ["..xPlayer.source.."]``````prolog\nHandedOverTo :"..playerNametarget.."``````xl\nMoneyAmount : "..amount.." dollars```"
--   PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({content = msgs}), { ['Content-Type'] = 'application/json' })
-- end)

-- RegisterServerEvent("rk:giveblackmoneyalert")
-- AddEventHandler("rk:giveblackmoneyalert", function(name,nametarget,amount)
--   if(settings.LogMoneyTransfer)then
--     sendToDiscord3(_U('server_money_transfer'),name.." ".._('user_gives_to').." "..nametarget.." "..amount .." dollars",Config.orange)
--   end
--   local playerName = GetPlayerName(name)
--   local playerNametarget = GetPlayerName(nametarget)
--   local DiscordWebHook = "https://discordapp.com/api/webhooks/759475033914736641/-WHeAqzqNh-ZyU46azQd3YQVMhhcCmg0AzQEyyqP_sIrFskKBwJjCencvjWa2OEOjntx"
--    msgs = "```fix\nName : "..playerName.." ["..xPlayer.source.."]``````prolog\nHandedOverTo :"..playerNametarget.."``````xl\nBlackAmount : "..amount.." dollars```"
--   PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({content = msgs}), { ['Content-Type'] = 'application/json' })
-- end)


-- -- Add event when a player give money
-- -- TriggerEvent("rk:givemoneyalert",sourceXPlayer.name,targetXPlayer.name,itemCount) -> RKCore_extended
-- RegisterServerEvent("rk:givemoneybankalert")
-- AddEventHandler("rk:givemoneybankalert", function(name,nametarget,amount)
--   if(settings.LogMoneyBankTransfert)then
--    sendToDiscord3(_U('server_moneybank_transfer'),name.." ".. _('user_gives_to') .." "..nametarget.." "..amount .." dollars",Config.orange)
--   end

-- end)


-- -- Add event when a player give weapon
-- --  TriggerEvent("rk:giveweaponalert",sourceXPlayer.name,targetXPlayer.name,weaponLabel) -> RKCore_extended
-- RegisterServerEvent("rk:giveweaponalert")
-- AddEventHandler("rk:giveweaponalert", function(name,nametarget,weaponlabel)
--   if(settings.LogWeaponTransfer)then
--     sendToDiscord3(_U('server_weapon_transfer'),name.." ".._('user_gives_to').." "..nametarget.." "..weaponlabel,Config.orange)
--   end

-- end)

-- -- Add event when a player is washing money
-- --  TriggerEvent("rk:washingmoneyalert",xPlayer.name,amount) -> RKCore_society
-- RegisterServerEvent("rk:washingmoneyalert")
-- AddEventHandler("rk:washingmoneyalert", function(name,amount)
--   sendToDiscord3(_U('server_washingmoney'),name.." ".._('user_washingmoney').." ".. amount .." dollars",Config.orange)

-- end)

-- -- Event when a player is in a blacklisted vehicle
-- RegisterServerEvent("rk:enterblacklistedcar")
-- AddEventHandler("rk:enterblacklistedcar", function(model)
--    local xPlayer = RKCore.GetPlayerFromId(source)
--    sendToDiscord3(_U('server_blacklistedvehicle'),xPlayer.name.." ".._('user_entered_in').." ".. model ,Config.red)

-- end)


-- -- Event when a player (not policeman) is in a police vehicle
-- RegisterServerEvent("rk:enterpolicecar")
-- AddEventHandler("rk:enterpolicecar", function(model)
--  	 local xPlayer = RKCore.GetPlayerFromId(source)
--  	 sendToDiscord3(_U('server_policecar'),xPlayer.name.." ".._('user_entered_in').." ".. model , Config.blue)

-- end)


-- -- Event when a player is jacking a car
-- RegisterServerEvent("rk:jackingcar")
-- AddEventHandler("rk:jackingcar", function(model)
--    local xPlayer = RKCore.GetPlayerFromId(source)
--    sendToDiscord3(_U('server_carjacking'),xPlayer.name.." ".._('user_carjacking').." ".. model,Config.purple)

-- end)

-- RegisterServerEvent("rk:chatlog")
-- AddEventHandler("rk:chatlog", function(args, xPlayer)
-- local playerName = GetPlayerName(xPlayer.source)
--   local DiscordWebHook = "https://discordapp.com/api/webhooks/761661946084327465/UUYhUeG_vACAGQW8ZgabW2WuD8p7aN5OhhSinx9eilkV7bWLomK8JTdTOnBa_3UKYJ-P"
--   msgs = "```fix\nName : "..playerName.." ["..xPlayer.source.."]``````prolog\nIdentifiers :"..json.encode(xPlayer.identifier).."``````xl\nChatlog : "..args.."```"
--   PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({content = msgs}), { ['Content-Type'] = 'application/json' })
-- end)

-- RegisterServerEvent("rk:invilog")
-- AddEventHandler("rk:invilog", function(data, xPlayer)
-- local playerName = GetPlayerName(xPlayer.source)
-- --getIdentity(xPlayer.identifier, function(datad)end)
-- --local name = (datad.firstname..' '..datad.lastname)
-- --local charname = GetCharacterName(xPlayer.source)
--   local DiscordWebHook = "https://discordapp.com/api/webhooks/759460878705229857/mGqpzdtAgK17pxG1qi4Rs_5CHbw9cfEBvu44mFiAepRvUALi2_wKg3cZlWo7Vio9Qw0m"
--   msgs = "```fix\nName : "..playerName.." ["..xPlayer.source.."]``````prolog\nIdentifiers :"..json.encode(xPlayer.identifier).."``````xl\nInventory : "..data.."```"
--   PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({content = msgs}), { ['Content-Type'] = 'application/json' })
-- end)

-- RegisterServerEvent("rk:revivelog")
-- AddEventHandler("rk:revivelog", function(target, xPlayer)
-- local playerName = GetPlayerName(xPlayer.source)
--   local DiscordWebHook = "https://discordapp.com/api/webhooks/763112108757876746/yj-JVQY6X8IofeixvZJ4wR2yweUC_WY67AYaRvrMf4s25BIi4HmMthmgQsMpSJAyiCXU"
--   msgs = "```fix\nName : "..playerName.." ["..xPlayer.source.."]``````prolog\nIdentifiers :"..json.encode(xPlayer.identifier).."``````xl\nRevived : "..target.."```"
--   PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({content = msgs}), { ['Content-Type'] = 'application/json' })
-- end)

-- RegisterServerEvent("rk:money")
-- AddEventHandler("rk:money", function(data2, xPlayer)

-- local playerName = GetPlayerName(xPlayer.source)
--   local DiscordWebHook = "https://discordapp.com/api/webhooks/759466690261680218/Ug0MBXXoy9Dzg_JSd6N_Sd2ZUmcj0drXvbQuOVknPjblFkPgb1rAIikxY_9Tzix7ebc4"
--   msgs = "```fix\nName : "..playerName.." ["..xPlayer.source.."]``````prolog\nIdentifiers :"..json.encode(xPlayer.identifier).."``````xl\nDATA : "..data2.."```"
--   PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({content = msgs}), { ['Content-Type'] = 'application/json' })
-- end)

-- RegisterServerEvent("rk:trunk")
-- AddEventHandler("rk:trunk", function(p, xPlayer, data)
-- local playerName = GetPlayerName(xPlayer.source)
--   local DiscordWebHook = "https://discordapp.com/api/webhooks/759467488554516481/T12sObNUZOKcKBMbWjn6sKBQb_2MuKVw28l1vv-wHXC2zKf7_IGOh1uQjqHPFyuJRqlC"
--   msgs = "```fix\nName : "..playerName.." ["..xPlayer.source.."]``````prolog\nPlate :"..json.encode(p).."``````xl\nPutInTrunk : "..data.."```"
--   PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({content = msgs}), { ['Content-Type'] = 'application/json' })
-- end)


-- RegisterServerEvent("rk:trunkout")
-- AddEventHandler("rk:trunkout", function(p, xPlayer, data3)
-- local playerName = GetPlayerName(xPlayer.source)

--   local DiscordWebHook = "https://discordapp.com/api/webhooks/759469063553810512/VYKs6hztc5pC4QHXU8jrM_TXTEx4aXQwhxeERwE9B6azotAkQnCDmaZCcaFbwsa-ha3Y"
--   msgs = "```fix\nName : "..playerName.." ["..xPlayer.source.."]``````prolog\nPlate :"..json.encode(p).."``````xl\nTookFromTrunk : "..data3.."```"
--   PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({content = msgs}), { ['Content-Type'] = 'application/json' })
-- end)

-- RegisterServerEvent("rk:trunkouttoplayer")
-- AddEventHandler("rk:trunkouttoplayer", function(t, xPlayer, data4, c)
-- local playerName = GetPlayerName(xPlayer.source)

--   local DiscordWebHook = "https://discordapp.com/api/webhooks/766315463302709289/007dxPC-7kTWi1bVU8jhflEr9dWNbwmbCv5hR-BkqxKQholKDDumnxYVRCAxj2z5CKGP"
--   msgs = "```fix\nName : "..playerName.." ["..xPlayer.source.."]``````prolog\nPlate :"..json.encode(p).."``````xl\nFromTrunkToInventory : "..data4.."  ["..c.."]```"
--   PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({content = msgs}), { ['Content-Type'] = 'application/json' })
-- end)

-- RegisterServerEvent("rk:motelin")
-- AddEventHandler("rk:motelin", function(storage, xPlayer, put)
-- local playerName = GetPlayerName(xPlayer.source)

--   local DiscordWebHook = "https://discordapp.com/api/webhooks/763106008104304661/KYfCnQbJnp5XNWqX2g4qmj6SAzsrN5N6hx_bhSS_lKE0zzTPUxhdfVhwZYlarrVKjsFJ"
--   msgs = "```fix\nName : "..playerName.." ["..xPlayer.source.."]``````prolog\nStorageId :"..json.encode(p).."``````xl\nPutInMotel : "..put.."```"
--   PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({content = msgs}), { ['Content-Type'] = 'application/json' })
-- end)


-- RegisterServerEvent("rk:motelout")
-- AddEventHandler("rk:motelout", function(storage, xPlayer, out)
-- local playerName = GetPlayerName(xPlayer.source)

--   local DiscordWebHook = "https://discordapp.com/api/webhooks/763106553308905544/eVRqOkYCGGmmROT9PLXIUxMzOsEoZI6qOdbEMrT9eloK181KzSfv9goVSaMKZPkiqblK"
--   msgs = "```fix\nName : "..playerName.." ["..xPlayer.source.."]``````prolog\nStorageId :"..json.encode(p).."``````xl\nTookFromMotel : "..out.."```"
--   PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({content = msgs}), { ['Content-Type'] = 'application/json' })
-- end)

-- RegisterServerEvent("rk:transfervehicle")
-- AddEventHandler("rk:transfervehicle", function(p, xPlayer, target)
-- local playerName = GetPlayerName(xPlayer.source)
-- local targetplayer = GetPlayerName(target)

--   local DiscordWebHook = "https://discordapp.com/api/webhooks/759471698461589514/D3HXYH8jhUjtO3gOKY08BkoLHNtcL5Hm-0m8_UaECAAApYsqGFUlW7_c9KR0ITHtiyTS"
--   msgs = "```fix\nName : "..playerName.." ["..xPlayer.source.."]``````prolog\nPlate :"..json.encode(p).."``````xl\nTransferedTo : "..targetplayer.."```"
--   PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({content = msgs}), { ['Content-Type'] = 'application/json' })
-- end)
-- -- Event when a player is killing an other one

-- RegisterServerEvent('rk:killerlog')
-- AddEventHandler('rk:killerlog', function(t,killer, kilerT) -- t : 0 = NPC, 1 = player
--   local xPlayer = RKCore.GetPlayerFromId(source)
--   if(t == 1) then
--      local xPlayer = RKCore.GetPlayerFromId(source)
--      local xPlayerKiller = RKCore.GetPlayerFromId(killer)

--      if(xPlayerKiller.name ~= nil and xPlayer.name ~= nil)then

--        if(kilerT.killerinveh) then
--          local model = kilerT.killervehname

--             sendToDiscord3(_U('server_kill'), xPlayer.name .." ".._('user_kill').." "..xPlayerKiller.name.." ".._('with').." "..model,Config.red)



--        else
--             sendToDiscord3(_U('server_kill'), xPlayer.name .." ".._('user_kill').." "..xPlayerKiller.name,Config.red)



--        end
--     end
--   else
--      sendToDiscord3(_U('server_kill'), xPlayer.name .." ".. _('user_kill_environnement'),Config.red)
--   end

-- end)
--------------------------------------

local DISCORD_WEBHOOK = "https://discord.com/api/webhooks/756769600162758707/yyPw-XbKop3Aj5zHy21YInS0nuaWF4koQqRwwtARY__Duu3cvMfo4YT9kRCFBMBEi7J9"
local DISCORD_NAME = "rk-Logs"
local DISCORD_WEBHOOK2 = "https://discord.com/api/webhooks/756769600162758707/yyPw-XbKop3Aj5zHy21YInS0nuaWF4koQqRwwtARY__Duu3cvMfo4YT9kRCFBMBEi7J9"
local DISCORD_NAME2 = "rk Logs"
local STEAM_KEY = "9FC5405FEBC21BBA433351E1B7490859"
local DISCORD_IMAGE = "https://i.imgur.com/zviw6oW.png" -- default is FiveM logo

--DON'T EDIT BELOW THIS

PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, content = "Server Log ***Online***", avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })

AddEventHandler('chatMessage', function(source, name, message) 

	if string.match(message, "@everyone") then
		message = message:gsub("@everyone", "`@everyone`")
	end
	if string.match(message, "@here") then
		message = message:gsub("@here", "`@here`")
	end
	--print(tonumber(GetIDFromSource('steam', source), 16)) -- DEBUGGING
	--print('https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=' .. STEAM_KEY .. '&steamids=' .. tonumber(GetIDFromSource('steam', source), 16))
	if STEAM_KEY == '' or STEAM_KEY == nil then
		PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = name .. " [" .. source .. "]", content = message, tts = false}), { ['Content-Type'] = 'application/json' })
	else
		PerformHttpRequest('https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=' .. STEAM_KEY .. '&steamids=' .. tonumber(GetIDFromSource('steam', source), 16), function(err, text, headers)
			local image = string.match(text, '"avatarfull":"(.-)","')
			--print(image) -- DEBUGGING
			PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = name .. " [" .. source .. "]", content = message, avatar_url = image, tts = false}), { ['Content-Type'] = 'application/json' })
		end)
	end
end)

AddEventHandler('playerConnecting', function()
	for k, v in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            identifierDiscord = v
        end
    end 
    --PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, content = "```CSS\n".. GetPlayerName(source) .. " connecting\n```", avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
    sendToDiscord("Server Login", "**" .. GetPlayerName(source) .. "** is connecting to the server. \n\nDiscord ID : **" .. identifierDiscord .. "**", 65280)
end)

AddEventHandler('playerDropped', function(reason) 
	for k, v in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            identifierDiscord = v
        end
    end
	local color = 16711680
	if string.match(reason, "Kicked") or string.match(reason, "Banned") then
		color = 16007897
	end
  sendToDiscord("Server Logout", "**" .. GetPlayerName(source) .. "** has left the server. \n Reason: " .. reason .. " \n\nDiscord ID : **" .. identifierDiscord .. "**", color)
end)

RegisterServerEvent('playerDied')
AddEventHandler('playerDied',function(message)
	for k, v in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            identifierDiscord = v
        end
    end
    sendToDiscord("Death log", message .. " \n\nDiscord ID : **" .. identifierDiscord .. "**", 16711680)
end)

RegisterServerEvent('spawnitem')
AddEventHandler('spawnitem',function(message)
	for k, v in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            identifierDiscord = v
        end
    end
    sendToDiscord2("Admin Menu", message .. " \n\nDiscord ID : **" .. identifierDiscord .. "**", 16613184)
end)

RegisterServerEvent('adminmenu')
AddEventHandler('adminmenu',function(message)
	for k, v in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            identifierDiscord = v
        end
    end
    sendToDiscord2("Admin Menu", message .. " \n\nDiscord ID : **" .. identifierDiscord .. "**", 16613184)
end)

function GetIDFromSource(Type, ID) --(Thanks To WolfKnight [forum.FiveM.net])
    local IDs = GetPlayerIdentifiers(ID)
    for k, CurrentID in pairs(IDs) do
        local ID = stringsplit(CurrentID, ':')
        if (ID[1]:lower() == string.lower(Type)) then
            return ID[2]:lower()
        end
    end
    return nil
end

function stringsplit(input, seperator)
	if seperator == nil then
		seperator = '%s'
	end
	
	local t={} ; i=1
	
	for str in string.gmatch(input, '([^'..seperator..']+)') do
		t[i] = str
		i = i + 1
	end
	
	return t
end

function sendToDiscord(name, message, color)
  local connect = {
        {
            ["color"] = color,
            ["title"] = "**".. name .."**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = "Developed with ❤️",
            },
        }
    }
  PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end

function sendToDiscord2(name, message, color)
    local connect = {
          {
              ["color"] = color,
              ["title"] = "**".. name .."**",
              ["description"] = message,
              ["footer"] = {
                  ["text"] = "Developed with ❤️",
              },
          }
      }
    PerformHttpRequest(DISCORD_WEBHOOK2, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME2, embeds = connect, avatar_url = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
  end