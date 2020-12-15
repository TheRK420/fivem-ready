--================================================================================================
--==                                VARIABLES - DO NOT EDIT                                     ==
--================================================================================================
HHCore = nil

TriggerEvent('hhrp:getSharedObject', function(obj) HHCore = obj end)

RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
	local _source = source
	
	local xPlayer = HHCore.GetPlayerFromId(_source)
	if amount == nil or amount <= 0 or amount > xPlayer.getMoney() then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = "Invalid amount." })
	else
		xPlayer.removeMoney(amount)
		xPlayer.addAccountMoney('bank', tonumber(amount))
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = "You have successfully deposited $" .. amount .. ""})
		TriggerEvent('ls:AddInLog', 'bank', 'deposit', xPlayer.name, _source, xPlayer.identifier, amount, xPlayer.getAccount('bank').money)
	end
end)


AddEventHandler('es:playerLoaded', function(source, user)
    balances[source] = source.getBank()
    local xPlayer = HHCore.GetPlayerFromId(source)
    local money
    money = xPlayer.getMoney()
	  TriggerClientEvent('banking:updateCash', source, money)
    TriggerClientEvent('banking:updateBalance', source, xPlayer.getBank())
    TriggerClientEvent('isPed:UpdateCash', source, xPlayer.getMoney())
end)


-- RegisterServerEvent('playerSpawned')
-- AddEventHandler('playerSpawned', function()
--   TriggerEvent('es:getPlayerFromId', source, function(user)
--     balances[source] = user.getBank()
-- 	  money = xPlayer.getMoney()
-- 	  TriggerClientEvent('banking:updateCash', source, money)
--     TriggerClientEvent('banking:updateBalance', source, user.getBank())
--     local xPlayer = HHCore.GetPlayerFromId(source)
--     TriggerClientEvent('isPed:UpdateCash', source, user.getMoney())
--   end)
-- end)


RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
	local _source = source
	local xPlayer = HHCore.GetPlayerFromId(_source)
	local base = 0
	amount = tonumber(amount)
	base = xPlayer.getAccount('bank').money
	if amount == nil or amount <= 0 or amount > base then
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = "Invalid amount." })
	else
		xPlayer.removeAccountMoney('bank', amount)
		xPlayer.addMoney(amount)
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = "You have successfully withdrawn $".. amount .. ""})
		TriggerEvent('ls:AddInLog', 'bank', 'withdraw', xPlayer.name, _source, xPlayer.identifier, amount, base - amount)
	end
end)

RegisterServerEvent('bank:balance')
AddEventHandler('bank:balance', function()
	local _source = source
	local xPlayer = HHCore.GetPlayerFromId(_source)
	balance = xPlayer.getAccount('bank').money
	TriggerClientEvent('banking:updateBalance', _source, balance, true)
	TriggerEvent('banking:viewBalance')
	
end)


RegisterServerEvent('bank:transfer')
AddEventHandler('bank:transfer', function(to, amountt)
	local _source = source
	local xPlayer = HHCore.GetPlayerFromId(_source)
	local zPlayer = HHCore.GetPlayerFromId(to)
	if xPlayer == nil then return end
	if zPlayer ~= nil then
	local balance = 0
	balance = xPlayer.getAccount('bank').money

	
	if tonumber(_source) == tonumber(to) then

		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = "You cannot transfer funds to yourself." })
	else
		if balance <= 0 or balance < tonumber(amountt) or tonumber(amountt) <= 0 then

			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = "Invalid amount." })
		else
			xPlayer.removeAccountMoney('bank', tonumber(amountt))
			zPlayer.addAccountMoney('bank', tonumber(amountt))
 
            TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = "You have transfered $".. amountt .. " to " .. to .. "."})
			TriggerClientEvent('mythic_notify:client:SendAlert', to, { type = 'inform', text = "You have received $" .. amountt .. " from " .. _source .. "." })
			local message = xPlayer.name..'['.._source..']['..xPlayer.identifier..'] \n Transfered \n'..amountt..'to '..zPlayer.name..'['..to..']['..zPlayer.identifier..'] \n'..xPlayer.name..' new balance: '..xPlayer.getAccount('bank').money..'\n'..zPlayer.name..' new balance: '..zPlayer.getAccount('bank').money
			local tShamsiDate = exports["time"]:ShamsiDateCalculator()
			local title = "[ "..(tShamsiDate[2]).."/"..(tShamsiDate[1]).."/"..(tShamsiDate[0]).."   "..(tShamsiDate[6]).."  "..(tShamsiDate[0]).." "..(tShamsiDate[4]).."   "..os.date('%H:%M:%S').." ]"
			TriggerEvent('ls:AddInLog2', 'bank', title, message)
		end
		
	end
	else
	TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = "Invalid Account." }) end
end)

RegisterServerEvent('bank:givecash')
AddEventHandler('bank:givecash', function(toPlayer, amount)
		local xPlayer = HHCore.GetPlayerFromId(source)
		local Target = HHCore.GetPlayerFromId(toPlayer)

		if (tonumber(xPlayer.getMoney()) >= tonumber(amount)) then
			xPlayer.removeMoney(amount)
			Target.addMoney(amount)
			local balance = Target.getAccount('money').money
			TriggerClientEvent('banking:updateBalance', Target, balance, true)
			TriggerEvent("hhrp:givemoneyalert", source, toPlayer, addMoney)
		else
			--if (tonumber(user.money) < tonumber(amount)) then
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = "Not Enough Money." })
        		--CancelEvent()
			--end
		end
end)

RegisterServerEvent('dirtyMoney:givedm')
AddEventHandler('dirtyMoney:givedm', function(toPlayer, amount)
		local xPlayer = HHCore.GetPlayerFromId(source)
		local Target = HHCore.GetPlayerFromId(toPlayer)
		local account = xPlayer.getAccount('black_money')

		if (tonumber(account.money) >= tonumber(amount)) then
			xPlayer.removeAccountMoney('black_money', amount)
			Target.addAccountMoney('black_money', amount)
			TriggerClientEvent('hhrp:showNotification', Target, 'You Recieved '..amount..'Dirty Money !')
			TriggerEvent("hhrp:giveblackmoneyalert", source, toPlayer, amount)
		else
			--if (tonumber(user.money) < tonumber(amount)) then
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = "Not Enough Black Money." })
        		--CancelEvent()
			--end
		end
end)
RegisterCommand('cash', function(source, args, rawCommand)
    local _source = source
	local xPlayer = HHCore.GetPlayerFromId(_source)
    cash = xPlayer.getMoney()
    TriggerClientEvent('banking:updateCash', source, cash)
end)

RegisterCommand('bank', function(source, args, rawCommand)
    local _source = source
	local xPlayer = HHCore.GetPlayerFromId(_source)
    bank = xPlayer.getAccount('bank').money
    TriggerClientEvent('banking:updateBalance', source, bank)
end)

--[[ HHCore.RegisterCommand('givecash', 'user', function(source, args)
	local _source = HHCore.GetPlayerFromId(source)
	local to = HHCore.GetPlayerFromId(args[1])
	local amt = tonumber(args[2])
	if to ~= nil  then
		if to == tonumber(source) then
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'You Cannot Give Money To Yourself', length = 2500, style = { ['background-color'] = '#2f5c73', ['color'] = '#FFFFFF' } })
		else
			TriggerEvent('bank:givecash',_source, to, amt)
		end
	else
		print("hi")
	end
end) ]]

RegisterCommand("givecash", function(source, args)
	local xPlayer = HHCore.GetPlayerFromId(source)
	local TargetId = tonumber(args[1])
	local Target = HHCore.GetPlayerFromId(TargetId)
	local amount = tonumber(args[2])
	if Target ~= nil then
	  if amount ~= nil then
		if amount > 0 then
		  	if xPlayer.getMoney() >= amount and amount > 0 then
				if TargetId ~= source then
			 		 TriggerClientEvent('bank:givecash', TargetId, amount)
				else
					TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You Cannot Give Money To Yourself', length = 2500, style = { ['background-color'] = '#2f5c73', ['color'] = '#FFFFFF' } })
				end
		 	else
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You dont have enough money.', length = 2500, style = { ['background-color'] = '#2f5c73', ['color'] = '#FFFFFF' } })
			--TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "You dont have enough money.")
		  	end
		
		  --TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'The amount must be higher then 0.', length = 2500, style = { ['background-color'] = '#2f5c73', ['color'] = '#FFFFFF' } })
		  --TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "The amount must be higher then 0.")
		end
	  else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Enter an amount.', length = 2500, style = { ['background-color'] = '#2f5c73', ['color'] = '#FFFFFF' } })
		--TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Enter an amount.")
	  end
	else
	  TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Player is not online.', length = 2500, style = { ['background-color'] = '#2f5c73', ['color'] = '#FFFFFF' } })
	  --TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player is not online.")
	end    
end)
RegisterCommand("givedirty", function(source, args)
	local xPlayer = HHCore.GetPlayerFromId(source)
	local dm = xPlayer.getAccount('black_money')
	local TargetId = tonumber(args[1])
	local Target = HHCore.GetPlayerFromId(TargetId)
	local amount = tonumber(args[2])
	if Target ~= nil then
	  if amount ~= nil then
		if amount > 0 then
		  	if dm.money >= amount and amount > 0 then
				if TargetId ~= source then
			 		 TriggerClientEvent('dirtyMoney:givedm', TargetId, amount)
				else
					TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You Cannot Give Money To Yourself', length = 2500, style = { ['background-color'] = '#2f5c73', ['color'] = '#FFFFFF' } })
				end
		 	else
				TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'You dont have enough dirty money.', length = 2500, style = { ['background-color'] = '#2f5c73', ['color'] = '#FFFFFF' } })
			--TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "You dont have enough money.")
		  	end
		
		  --TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'The amount must be higher then 0.', length = 2500, style = { ['background-color'] = '#2f5c73', ['color'] = '#FFFFFF' } })
		  --TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "The amount must be higher then 0.")
		end
	  else
		TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Enter an amount.', length = 2500, style = { ['background-color'] = '#2f5c73', ['color'] = '#FFFFFF' } })
		--TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Enter an amount.")
	  end
	else
	  TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = 'Player is not online.', length = 2500, style = { ['background-color'] = '#2f5c73', ['color'] = '#FFFFFF' } })
	  --TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player is not online.")
	end    
end)