-------------------------------------
------- Created by T1GER#9080 -------
------------------------------------- 

RKCore              	= nil
Jobs 			= {}	-- jobs table
vehicles 		= {}	-- all vehicles
display 		= {}	-- display vehicles
categories 	= {}	-- all categories
PlyPlayTime 	= {}	-- table storing player game time

TriggerEvent('rk:getSharedObject', function(obj) RKCore = obj end)

-- Fetch Jobs
MySQL.ready(function()
	local result = MySQL.Sync.fetchAll('SELECT * FROM jobs', {})

	for i=1, #result, 1 do
		Jobs[result[i].name]        = result[i]
		Jobs[result[i].name].grades = {}
	end

	local result2 = MySQL.Sync.fetchAll('SELECT * FROM job_grades', {})

	for i=1, #result2, 1 do
		Jobs[result2[i].job_name].grades[tostring(result2[i].grade)] = result2[i]
	end
end)

-- Get Online Car Dealers:
RKCore.RegisterServerCallback('carealeredm:GetDealerCount', function(source, cb, option)
	local Players = RKCore.GetPlayers()
	local dealers = 0
	for i = 1, #Players do
		local xPlayer = RKCore.GetPlayerFromId(Players[i])
		if xPlayer["job"]["name"] == Config.CarDealerJobLabel then
			dealers = dealers + 1
		end
	end
	local DealerOnline = false
	if dealers > 0 then
		DealerOnline = true
	end
	cb(DealerOnline)
end)

-- Event to edit commission:
RegisterNetEvent('carealeredm:DealerDiscountSV')
AddEventHandler('carealeredm:DealerDiscountSV', function(currentModel, percent, currentID)	
	local DisplayVehicles = MySQL.Sync.fetchAll("SELECT * FROM vehicle_displayedm WHERE model=@model",{['@model'] = currentModel})
	MySQL.Sync.execute("UPDATE vehicle_displayedm SET commission=@commission WHERE id=@id",{['@commission'] = (DisplayVehicles[1].commission + percent), ['@id'] = currentID})
	TriggerClientEvent('carealeredm:DealerDiscountCL', -1)
end)

-- Event to edit downpayment:
RegisterNetEvent('carealeredm:DealerDownpaymentSV')
AddEventHandler('carealeredm:DealerDownpaymentSV', function(currentModel, dPayment, currentID)	
	local DisplayVehicles = MySQL.Sync.fetchAll("SELECT * FROM edm WHERE model=@model",{['@model'] = currentModel})
	MySQL.Sync.execute("UPDATE vehicle_displayedm SET downpayment=@downpayment WHERE id=@id",{['@downpayment'] = (DisplayVehicles[1].downpayment + dPayment), ['@id'] = currentID})
	TriggerClientEvent('carealeredm:DealerDownpaymentCL', -1)
end)

-- Event to change display vehicle:
RegisterNetEvent('carealeredm:ReplaceVehSV')
AddEventHandler('carealeredm:ReplaceVehSV', function(model, name, currentID)
	MySQL.Sync.execute("UPDATE vehicle_displayedm SET model=@model WHERE id=@id",{['@model'] = model, ['@id'] = currentID})
	MySQL.Sync.execute("UPDATE vehicle_displayedm SET name=@name WHERE id=@id",{['@name'] = name, ['@id'] = currentID})
	MySQL.Sync.execute("UPDATE vehicle_displayedm SET commission=@commission WHERE id=@id",{['@commission'] = '10', ['@id'] = currentID})
	TriggerClientEvent('carealeredm:ReplaceVehCL', -1, model, currentID)
end)

-- Event to check finance status on player login:
RegisterNetEvent('carealeredm:CheckFinanceStatus')
AddEventHandler('carealeredm:CheckFinanceStatus', function()
	local xPlayer = RKCore.GetPlayerFromId(source)

	local foundOwedVeh = false
	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier",{['@identifier'] = xPlayer.identifier}, function(results) 
		-- Looping through results:
		for k,v in pairs(results) do
			if v.repaytime < 1 and v.finance > 1 then
				foundOwedVeh = true
			end	
		end
		
		if foundOwedVeh then
			-- Editing found vehicle:
			local warnTime = Config.WarningTime
			TriggerClientEvent("carealeredm:ShowNotifyRKCore",xPlayer.source,_U('veh_repossessed_warning',warnTime))
			Citizen.Wait(warnTime * 60000)
			MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier",{['@identifier'] = xPlayer.identifier}, function(vehData) 
				-- loop through vehicles again and delete:
				for k,v in pairs(vehData) do
					if v.repaytime < 1 and v.finance > 1 then
						local vehPlate = v.plate
						local vehicle = json.decode(v.vehicle)
						local vehModel = vehicle.model
						MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {['@plate'] = vehPlate})
						TriggerClientEvent("carealeredm:UpdateCarDealerStockCL",-1,vehModel,vehPlate)
					end
				end
			end)
		end
	end)
end)

-- ACCOUNT MENU:
RKCore.RegisterServerCallback('carealeredm:GetAccountMoney', function(source, cb)
	local xPlayer = RKCore.GetPlayerFromId(source)
	local moneyOnPlayer = xPlayer.getMoney()
	local account = MySQL.Sync.fetchAll('SELECT * FROM addon_account_data WHERE account_name=@account_name', {['@account_name'] = 'society_cardealer'})	
	if not account[1] then
		return
	end
	cb(account[1].money,moneyOnPlayer)
end)

-- Callback to Withdraw Money:
RKCore.RegisterServerCallback('carealeredm:AccountsWithdraw', function(source, cb, amount)
	local xPlayer = RKCore.GetPlayerFromId(source)
	local account = MySQL.Sync.fetchAll('SELECT * FROM addon_account_data WHERE account_name=@account_name', {['@account_name'] = 'society_cardealer'})	
	local approved = false
	if account[1].money >= amount then
		MySQL.Sync.execute('UPDATE addon_account_data SET money=@money WHERE account_name=@account_name', {['@money'] = (account[1].money-amount), ['@account_name'] = 'society_cardealer'})
		approved = true
		if Config.UseCashMoney then
			xPlayer.addMoney(amount)
		else
			xPlayer.addAccountMoney('bank', amount)
		end
	else
		approved = false
	end
	cb(approved)
end)
-- Callback to Deposit Money:
RKCore.RegisterServerCallback('carealeredm:AccountsDeposit', function(source, cb, amount)
	local xPlayer = RKCore.GetPlayerFromId(source)
	local approved = false
	if Config.UseCashMoney then
		if xPlayer.getMoney() >= amount then
			xPlayer.removeMoney(amount)
			approved = true
		else
			approved = false
		end
	else
		if xPlayer.getAccount('bank').money >= amount then 
			xPlayer.removeAccountMoney('bank', amount)
			approved = true
		else
			approved = false
		end
	end
	if approved then
		local account = MySQL.Sync.fetchAll('SELECT * FROM addon_account_data WHERE account_name=@account_name',{['@account_name'] = 'society_cardealer'})	
		MySQL.Sync.execute('UPDATE addon_account_data SET money=@money WHERE account_name=@account_name', {['@money'] = (account[1].money+amount), ['@account_name'] = 'society_cardealer'})
	end	
	cb(approved)
end)

-- EMPLOYEE MENU:
RKCore.RegisterServerCallback('carealeredm:getEmployees', function(source, cb, society)		
	-- Fetch employees:
	MySQL.Async.fetchAll('SELECT firstname, lastname, identifier, job, job_grade FROM users WHERE job = @job ORDER BY job_grade DESC', {
		['@job'] = society
	}, function (results)
		local employees = {}

		for i=1, #results, 1 do
			table.insert(employees, {
				name       = results[i].firstname .. ' ' .. results[i].lastname,
				identifier = results[i].identifier,
				job = {
					name        = results[i].job,
					label       = Jobs[results[i].job].label,
					grade       = results[i].job_grade,
					grade_name  = Jobs[results[i].job].grades[tostring(results[i].job_grade)].name,
					grade_label = Jobs[results[i].job].grades[tostring(results[i].job_grade)].label
				}
			})
		end

		cb(employees)
	end)
end)
-- Set Job:
RKCore.RegisterServerCallback('carealeredm:setJob', function(source, cb, identifier, job, grade, type)
	local xPlayer = RKCore.GetPlayerFromId(source)
	if xPlayer.job.grade_name == 'boss' then
		local xTarget = RKCore.GetPlayerFromIdentifier(identifier)
		if xTarget then
			xTarget.setJob(job, grade)
			if type == 'hire' then
				TriggerClientEvent('carealeredm:ShowNotifyRKCore', xTarget.source, _U('you_have_been_hired', job))
			elseif type == 'promote' then
				TriggerClientEvent('carealeredm:ShowNotifyRKCore', xTarget.source, _U('you_have_been_promoted'))
			elseif type == 'fire' then
				TriggerClientEvent('carealeredm:ShowNotifyRKCore', xTarget.source, _U('you_have_been_fired', xTarget.getJob().label))
			end
			cb()
		else
			MySQL.Async.execute('UPDATE users SET job = @job, job_grade = @job_grade WHERE identifier = @identifier', {
				['@job']        = job,
				['@job_grade']  = grade,
				['@identifier'] = identifier
			}, function(rowsChanged)
				cb()
			end)
		end
	else
		cb()
	end
end)
-- Callback to Get online players:
RKCore.RegisterServerCallback('carealeredm:getOnlinePlayers', function(source, cb)
	local xPlayers = RKCore.GetPlayers()
	local players  = {}
	for i=1, #xPlayers, 1 do
		local xPlayer = RKCore.GetPlayerFromId(xPlayers[i])
		table.insert(players, {
			source     = xPlayer.source,
			identifier = xPlayer.identifier,
			name       = xPlayer.name,
			job        = xPlayer.job
		})
	end
	cb(players)
end)
-- Callback to get player job:
RKCore.RegisterServerCallback('carealeredm:getJob', function(source, cb, society)
	local job    = json.decode(json.encode(Jobs[society]))
	local grades = {}
	for k,v in pairs(job.grades) do
		table.insert(grades, v)
	end
	table.sort(grades, function(a, b)
		return a.grade < b.grade
	end)
	job.grades = grades
	cb(job)
end)

-- Callback to get downpayment when financing:
RKCore.RegisterServerCallback('carealeredm:GetFinancingMoney', function(source, cb, dPayment, model, stock)	
	local xPlayer = RKCore.GetPlayerFromId(source)
	
	local carPrice = 0
	local commission = 0
	-- Check Bought Car with display table:
	for k,v in pairs(display) do
		if model == v.model then
			carPrice = v.price
			if v.commission then
				commission = v.commission
			end
		end
	end
	
	-- Calculate Car Price plus Commission:
	if commission ~= 0 and carPrice ~= 0 then
		commission = carPrice*(commission/100)
	end
		
	-- Check Player Money & commission:
	local hasUpfront = false
	local payment = 0
	if Config.PayWithCash then
		local money = xPlayer.getMoney()
		payment = money
	else
		local bank = xPlayer.getAccount("bank").money
		payment = bank
	end
	local downPayment = 0
	if carPrice ~= 0 then
		if commission > 0 or commission < 0 then 
			if payment >= ((carPrice + commission) * (dPayment/100)) then 
				hasUpfront = true
				carPrice = (carPrice + commission)
				downPayment = (carPrice * (dPayment/100))
			end
		else
			if payment >= (carPrice * (dPayment/100)) then 
				hasUpfront = true
				carPrice = carPrice
				downPayment = (carPrice * (dPayment/100))
			end
		end
	end	
	
	-- Stock Feature:
	if hasUpfront then
	-- Get Vehicle Stock:
	local GetVehDB = MySQL.Sync.fetchAll("SELECT * FROM vehiclesedm WHERE model=@model",{['@model'] = model})	
	local StockAmount = GetVehDB[1].stock
		
	-- Remove Stock:
		MySQL.Async.execute('UPDATE vehiclesedm SET stock = @stock WHERE model = @model',
		{
			['@stock'] = (StockAmount - 1),
			['@model'] = model
		})
	end
	
	cb(hasUpfront, downPayment, carPrice, commission, payment)
end)

-- Callback to sell owned vehicle and update dealer stock
RKCore.RegisterServerCallback('carealeredm:SellOwnedVehicle', function(source, cb, plate, price, model)
	local xPlayer = RKCore.GetPlayerFromId(source)
	local sellPrice = (price * (1-(Config.SellPercent/100)))
	
	-- Add Money to Player:
	if Config.ReceiveBankMoney then
		xPlayer.addAccountMoney("bank", sellPrice)
	else
		xPlayer.addMoney(sellPrice)
	end
	
	-- Get Vehicle Stock:
	local GetVehDB = MySQL.Sync.fetchAll("SELECT * FROM vehiclesedm WHERE model=@model",{['@model'] = model})	
	local StockAmount = GetVehDB[1].stock
	
	-- Remove Vehicle:
	MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {['@plate'] = plate})
		
	-- Add Stock:
	MySQL.Async.execute('UPDATE vehiclesedm SET stock = @stock WHERE model = @model',
	{
		['@stock'] = (StockAmount + 1),
		['@model'] = model
	})
		
	cb(true, sellPrice, plate, model)
end)

-- Callback to get player money upon purchasing vehicle from shop menu:
RKCore.RegisterServerCallback('carealeredm:ShopGetPlyMoney', function(source, cb, model, price)
	local xPlayer = RKCore.GetPlayerFromId(source)
	
	-- Check Player Money & commission:
	local gotMoney = false
	local payment = 0
	
	if Config.PayWithCash then
		local money = xPlayer.getMoney()
		payment = money
	else
		local bank = xPlayer.getAccount("bank").money
		payment = bank
	end
	
	if payment >= price then
		gotMoney = true
	end	
	


	if gotMoney then
		-- Get Vehicle Stock:
		local GetVehDB = MySQL.Sync.fetchAll("SELECT * FROM vehiclesedm WHERE model=@model",{['@model'] = model})	
		local StockAmount = GetVehDB[1].stock
		
		-- Remove Stock:
		MySQL.Async.execute('UPDATE vehiclesedm SET stock = @stock WHERE model = @model',
		{
			['@stock'] = (StockAmount - 1),
			['@model'] = model
		})
	end
		
	cb(gotMoney, price, payment)
end)

-- Callback to add vehicle to DB purchased through shop menu:
RegisterNetEvent('carealeredm:ShopBuyAddCarToDB')
AddEventHandler('carealeredm:ShopBuyAddCarToDB', function(vehProps, price, payment, vehModel)
	local xPlayer = RKCore.GetPlayerFromId(source)
		
	-- get player money/bank balance:
	local PaymenType = payment
	
	-- Remove Money:
	if Config.PayWithCash then
		xPlayer.removeMoney(price)
	else
		xPlayer.removeAccountMoney('bank', (price))
	end
	
	-- Current Date:
	local date = os.date('%Y-%m-%d')
	
	-- Add veh to database:
	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, date, paidprice, model) VALUES (@owner, @plate, @vehicle, @date, @paidprice, @model)',
	{
		['@owner']   	= xPlayer.identifier,
		['@plate']   	= vehProps.plate,
		['@vehicle'] 	= json.encode(vehProps),
        ['@date']       = date,
		['@paidprice']  = price,
		['@model'] 		= vehModel
	})
end)

RKCore.RegisterServerCallback('carealeredm:GetPlayerMoney', function(source, cb, model, price, stock)
	local xPlayer = RKCore.GetPlayerFromId(source)
	local mo = xPlayer.getMoney()
	local commission = 0
	local carPrice = 0
	-- Check Bought Car with display table:
	for k,v in pairs(display) do
		if model == v.model then
			carPrice = v.price
			if v.commission then
				commission = v.commission
			end
		end
	end
	
	-- Calculate Car Price plus Commission:
	if commission ~= 0 and carPrice ~= 0 then
		commission = carPrice*(commission/100)
	end
		
	-- Check Player Money & commission:
	local hasMoney = false
	local payment = 0
	--if Config.PayWithCash then
		local money = xPlayer.getMoney()
		payment = money
	--else
		--local bank = xPlayer.getAccount("bank").money
		--payment = bank
	--end

	if carPrice ~= 0 then
		if commission > 0 or commission < 0 then 
			if payment >= (carPrice + commission) then 
				carPrice = (carPrice + commission) 
				hasMoney = true
				--print("ITSCARPRICE")
			end
		else
			if payment >= carPrice then 
				carPrice = carPrice
				hasMoney = true
				--print("its Payment")
			end
		end
	end	

	
	-- Stock Feature:
	if hasMoney then
	-- Get Vehicle Stock:
	local GetVehDB = MySQL.Sync.fetchAll("SELECT * FROM vehiclesedm WHERE model=@model",{['@model'] = model})	
	local StockAmount = GetVehDB[1].stock
		
	-- Remove Stock:
		MySQL.Async.execute('UPDATE vehiclesedm SET stock = @stock WHERE model = @model',
		{
			['@stock'] = (StockAmount - 1),
			['@model'] = model
		})
	end
	
	cb(hasMoney, carPrice, commission, price, payment)
end)

RegisterNetEvent('carealeredm:AddFinancedVehToDB')
AddEventHandler('carealeredm:AddFinancedVehToDB', function(vehProps, downPayment, carPrice, commission, payment, currentModel)
	local xPlayer = RKCore.GetPlayerFromId(source)
	
	-- Get Current Car Dealer Account Money:
	local accMoney = MySQL.Sync.fetchAll("SELECT * FROM addon_account_data WHERE account_name=@account_name",{['@account_name'] = 'society_cardealer'})	
	local accBal = accMoney[1].money
	
	-- get player money/bank balance:
	local PaymenType = payment
	
	-- Remove Money:
	if commission > 0 or commission < 0 then 
		if Config.PayWithCash then
			xPlayer.removeMoney(downPayment)
		else
			xPlayer.removeAccountMoney('bank', (downPayment))
		end
		local accountInsert = 0
		if Config.DownPaymentToDealerShip then
			accountInsert = accBal + commission + downPayment
		else
			accountInsert = accBal + commission
		end
		MySQL.Sync.execute('UPDATE addon_account_data SET money=@money WHERE account_name=@account_name',{['@money'] = accountInsert,['@account_name'] = 'society_cardealer'})
	else
		if Config.PayWithCash then
			xPlayer.removeMoney(downPayment)
		else
			xPlayer.removeAccountMoney('bank', downPayment)
		end
		local accountInsert = 0
		if Config.DownPaymentToDealerShip then
			accountInsert = accBal + downPayment
		else
			accountInsert = accBal
		end
		MySQL.Sync.execute('UPDATE addon_account_data SET money=@money WHERE account_name=@account_name',{['@money'] = accountInsert,['@account_name'] = 'society_cardealer'})
	end
	
	-- Finace timer:
	local FinaceTime = (Config.MaxTimePerRepay * 60)
	
	-- Current Date:
	local date = os.date('%Y-%m-%d')
	local edm  = 1
	-- Add veh to database:
	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, date, paidprice, finance, repaytime, model, isedm) VALUES (@owner, @plate, @vehicle, @date, @paidprice, @finance, @repaytime, @model, @edm)',
	{
		['@owner']   	= xPlayer.identifier,
		['@plate']   	= vehProps.plate,
		['@vehicle'] 	= json.encode(vehProps),
        ['@date']       = date,
		['@paidprice']  = (carPrice - downPayment),
		['@finance']   	= math.floor((carPrice*((Config.InterestRate/100)+1)) - downPayment),
		['@repaytime'] 	= FinaceTime,
		['@model'] 		= currentModel,
		['@edm']		= edm
	})
end)

RKCore.RegisterServerCallback('cardealeredm:ticketcheck',function(source, cb)
	local _source = source
	local xPlayer = RKCore.GetPlayerFromId(_source)
	MySQL.Async.fetchAll('SELECT identifier, supporter FROM `users` WHERE `identifier` = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		if result[1].identifier ~= nil then

			local identifier = result[1].identifier
			local supporter	= result[1].supporter
			if supporter ~= nil then
				print("Player visited EDM "..identifier.." "..supporter)
				cb(supporter)
			else
				cb(false)
			end
		else
			cb(false)
		end
	end)
end)


RegisterNetEvent('carealeredm:AddVehToDatabase')
AddEventHandler('carealeredm:AddVehToDatabase', function(vehProps, carPrice, commission, price, payment, currentModel)
	local xPlayer = RKCore.GetPlayerFromId(source)
	-- Get Current Car Dealer Account Money:
	local accMoney = MySQL.Sync.fetchAll("SELECT * FROM addon_account_data WHERE account_name=@account_name",{['@account_name'] = 'society_cardealer'})	
	local accBal = accMoney[1].money
	
	-- get player money/bank balance:
	local PaymenType = payment
	
	-- Remove Money:
	if commission > 0 or commission < 0 then 
		if Config.PayWithCash then
			xPlayer.removeMoney(carPrice)
		else
			xPlayer.removeAccountMoney('bank', (carPrice))
		end
		MySQL.Sync.execute('UPDATE addon_account_data SET money=@money WHERE account_name=@account_name',{['@money'] = accBal + commission,['@account_name'] = 'society_cardealer'})
	else
		if Config.PayWithCash then
			xPlayer.removeMoney(carPrice)
		else
			xPlayer.removeAccountMoney('bank', carPrice)
		end
	end
	-- Current Date:
	local date = os.date('%Y-%m-%d')
	local edm = 1
	
	-- Add veh to database:
	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, date, paidprice, model, isedm) VALUES (@owner, @plate, @vehicle, @date, @paidprice, @model, @edm)',
	{
		['@owner']   	= xPlayer.identifier,
		['@plate']   	= vehProps.plate,
		['@vehicle'] 	= json.encode(vehProps),
		['@date']       = date,
		['@paidprice']  = carPrice,
		['@model'] 		= currentModel,
		['@edm']		= edm
	})
end)

RKCore.RegisterServerCallback('carealeredm:GetOwnedVehByPlate',function(source, cb, plate)	
	local xPlayer = RKCore.GetPlayerFromId(source)
	local vehPlate, vehPrice, vehHash, vehFinance, vehRepaytime = nil, 0, nil, 0, 0
	
	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier",{['@identifier'] = xPlayer.identifier}, function(vehData) 
		local vehFound = false
		for k,v in pairs(vehData) do
			if plate == v.plate then
				local vehicle = json.decode(v.vehicle)
				vehHash 		= vehicle.model
				vehPrice 		= v.paidprice
				vehPlate 		= v.plate
				vehFinance 		= v.finance
				vehRepaytime 	= v.repaytime
				vehFound 		= true
			end
		end
		if not vehFound then
			TriggerClientEvent('carealeredm:ShowNotifyRKCore', xPlayer.source, _U('not_own_that_plate'))
		end
		
		if vehFound then
			cb(vehPlate, vehPrice, vehHash, vehFinance, vehRepaytime)
		end
	end)
	
end)

RKCore.RegisterServerCallback('carealeredm:RepayAmount', function(source, cb, plate, amount)
	local xPlayer = RKCore.GetPlayerFromId(source)

	local paid
	if Config.PayWithBankMoney then
		if xPlayer.getAccount('bank').money >= amount then 
			xPlayer.removeAccountMoney('bank',amount)
			paid = true
		else
			paid = false
		end
	else	
		if xPlayer.getMoney() >= amount then
			xPlayer.removeMoney(amount)
			paid = true
		else
			paid = false
		end
	end
	local setTime
	if paid then 
		local curVeh = MySQL.Sync.fetchAll("SELECT * FROM owned_vehicles WHERE plate=@plate", {['@plate'] = plate})
		local financeAmount = curVeh[1].finance
		if financeAmount - amount <= 0 then
			setTime = 0
		else
			setTime = (Config.MaxTimePerRepay * 60)
		end
		MySQL.Sync.execute('UPDATE owned_vehicles SET finance=@finance WHERE plate=@plate',{['@finance'] = (financeAmount - amount), ['@plate'] = plate})
		MySQL.Sync.execute('UPDATE owned_vehicles SET repaytime=@repaytime WHERE plate=@plate',{['@repaytime'] = setTime, ['@plate'] = plate})
	end
	cb(paid)
end)

-- Give Registration Paper
RegisterServerEvent('carealeredm:GiveRegistrationPaper')
AddEventHandler('carealeredm:GiveRegistrationPaper', function(player, target, plate)
	local xPlayer = RKCore.GetPlayerFromId(player)
	local tPlayer = RKCore.GetPlayerFromId(target)
	local vehFound   = false
	
	local regOwner
	local regPlate = nil
	local date = os.date('%Y-%m-%d')
	
	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner=@identifier',{['@identifier'] = xPlayer.identifier}, function(vehData) 
		for k,v in pairs(vehData) do
			if plate == v.plate then
				regOwner = v.owner
				regPlate = v.plate
				regVehicle = v.vehicle
				regPrice = v.paidprice
				regFinance = v.finance
				regRepaytime = v.repaytime
				regModel = v.model
				vehFound = true
			end
		end
		if vehFound then
			-- Delete Veh from xplayer identifier:
			MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate = @plate', {['@plate'] = plate})
		
			-- Add veh to database target identifier:
			MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle, date, paidprice, finance, repaytime, model) VALUES (@owner, @plate, @vehicle, @date, @paidprice, @finance, @repaytime, @model)',
			{
				['@owner']   	= tPlayer.identifier,
				['@plate']   	= regPlate,
				['@vehicle'] 	= regVehicle,
				['@date']       = date,
				['@paidprice']  = regPrice,
				['@finance']   	= regFinance,
				['@repaytime'] 	= regRepaytime,
				['@model'] 		= regModel
			})
			TriggerClientEvent('carealeredm:ShowNotifyRKCore', xPlayer.source, _U('veh_owner_change'))
			TriggerClientEvent('carealeredm:ShowNotifyRKCore', tPlayer.source, _U('veh_owner_change2'))
		else
			TriggerClientEvent('carealeredm:ShowNotifyRKCore', xPlayer.source, _U('plate_not_exists'))
		end
	end)
end)

-----------------------------------------------------------------------------------------------------------------
--_______     ______    _____           ______  _______          _        ______  ___  ____   ________  ______    
--|_   __ \   / ____ `. / ___ `.       .' ___  ||_   __ \        / \     .' ___  ||_  ||_  _| |_   __  ||_   _ `.  
--  | |__) |  `'  __) ||_/___) |      / .'   \_|  | |__) |      / _ \   / .'   \_|  | |_/ /     | |_ \_|  | | `. \ 
--  |  __ /   _  |__ '. .'____.'      | |         |  __ /      / ___ \  | |         |  __'.     |  _| _   | |  | | 
-- _| |  \ \_| \____) |/ /_____       \ `.___.'\ _| |  \ \_  _/ /   \ \_\ `.___.'\ _| |  \ \_  _| |__/ | _| |_.' / 
--|____| |___|\______.'|_______|       `.____ .'|____| |___||____| |____|`.____ .'|____||____||________||______.'
------------------------------------------------------------------------------------------------------------------


-- Fetch Car Dealer Core Data:
RKCore.RegisterServerCallback("carealeredm:FetchData", function(source, cb)
	vehicles = {}
	display = {}
	categories = {}
	-- Fetch Data:
	local data1 = MySQL.Sync.fetchAll('SELECT * FROM vehiclesedm')
	local data2 = MySQL.Sync.fetchAll('SELECT * FROM vehicle_displayedm')
	local data3 = MySQL.Sync.fetchAll('SELECT * FROM vehicle_categoriesedm')
	-- vehicles:
	for k,v in pairs(data1) do
		table.insert(vehicles,{name = v.name, model = v.model, price = v.price, category = v.category, stock = v.stock})
	end
	-- display:
	for k,v in pairs(data2) do
		local price, category, gotPrice = 0, nil, false
		for _,y in pairs(vehicles) do
			if v.model == y.model then
				price = y.price
				category = y.category
				stock = y.stock
				gotPrice = true
			end
		end
		if gotPrice then
			table.insert(display,{id = v.id, model = v.model, name = v.name, price = price, category = category, stock = stock, commission = v.commission, downpayment = v.downpayment})
		end
	end
	-- categories:
	for k,v in pairs(data3) do
		table.insert(categories,{name = v.name, label = v.label})
	end
	--print(json.encode(display))
	cb(vehicles, display, categories)
end)

-- Callback to get all owned vehicles, with options:
RKCore.RegisterServerCallback('carealeredm:GetAllOwnedVehicles', function(source, cb, option)
    local xPlayer = RKCore.GetPlayerFromId(source)
    local plyVehicles = {}

    local foundVehicles = false
    MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner=@identifier',{['@identifier'] = xPlayer.identifier}, function(results)

            -- financing billing option:
            if option == "financing" then
                for k,v in pairs(results) do
                    if v.finance > 1 then
                        local vehicle = json.decode(v.vehicle)
                        table.insert(plyVehicles,{plate = v.plate, vehicle = vehicle, date = v.date, price = v.paidprice, finance = v.finance, repaytime = v.repaytime, model = v.model})
                    end
                end
                cb(plyVehicles)

                -- sell vehicle option
            elseif option == "sellveh" then
                for k,v in pairs(results) do
                    if v.finance < 1 then
                        local vehicle = json.decode(v.vehicle)
                        table.insert(plyVehicles,{plate = v.plate, vehicle = vehicle, date = v.date, price = v.paidprice, finance = v.finance, repaytime = v.repaytime, model = v.model})
                    end
                end
                cb(plyVehicles)
            end

    end)
end)


-- Callback to update vehicle stock upon repossession:
RKCore.RegisterServerCallback('carealeredm:UpdateDealerStock', function(source, cb, VehModel)
    local xPlayer = RKCore.GetPlayerFromId(source)
    -- Get Stock_
    local GetVehDB = MySQL.Sync.fetchAll("SELECT * FROM vehiclesedm WHERE model=@model",{['@model'] = VehModel})
    local StockAmount = GetVehDB[1].stock

    -- Add Stock:
    MySQL.Async.execute('UPDATE vehiclesedm SET stock = @stock WHERE model = @model',
        {
            ['@stock'] = (StockAmount + 1),
            ['@model'] = VehModel
        })
    cb(true)
end)


-- Callback to get new generated plate:
RKCore.RegisterServerCallback('carealeredm:PlateInUse', function (source, cb, plate)
    MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = plate
    }, function (result)
        cb(result[1] ~= nil)
    end)
end)
RegisterServerEvent('carealeredm:financepaid')
AddEventHandler('carealeredm:financepaid', function(plate)
	local xPlayer = RKCore.GetPlayerFromId(source)
	local date = os.date('%Y-%m-%d')
	MySQL.Sync.execute('UPDATE owned_vehicles SET lastpaid=@date WHERE plate=@plate', {['@date'] = date, ['@plate'] = plate} )

end)

-- Open Registration Paper
RegisterServerEvent('carealeredm:openRegSV')
AddEventHandler('carealeredm:openRegSV', function(player, target, plate)
    local xPlayer = RKCore.GetPlayerFromId(player)
    local tPlayer    = RKCore.GetPlayerFromId(target).source
    local vehFound   = false

    MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex, height FROM users WHERE identifier = @identifier', {['@identifier'] = xPlayer.identifier}, function (user)
        local regPlate = nil
        local regDate
        local regFinance = 0
        local regModel = 0
        if (user[1] ~= nil) then
            MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner=@identifier',{['@identifier'] = xPlayer.identifier}, function(vehData)
                for k,v in pairs(vehData) do
                    if plate == v.plate then
                        regPlate = v.plate
                        regDate = v.date
                        regFinance = v.finance
                        regModel = v.model
                        vehFound = true
                    end
                end
                if vehFound then
                    local label
                    if regFinance > 0 then
                        label = _U('reg_payment_label1')
                    else
                        label = _U('reg_payment_label2')
                    end
                    local info = {
                        user = user,
                        regPlate = regPlate,
                        regDate = regDate,
                        regPayment = label,
                        regModel = regModel,
                    }
                    TriggerClientEvent('carealeredm:openRegCL', tPlayer, info, regPlate)
                else
                    TriggerClientEvent('carealeredm:ShowNotifyRKCore', xPlayer.source, _U('plate_not_exists'))
                end
            end)
        end
    end)
end)

-- Store in game time on player login:
--[[ AddEventHandler("playerConnecting", function()
    local identifiers = GetPlayerIdentifiers(source)
    local steamHEX
    for k,v in pairs(identifiers) do
        if string.find(v, "license") then
            steamHEX = v
            break
        end
    end
    local GameTimer = GetGameTimer()
    table.insert(PlyPlayTime, {identifier = steamHEX, time = GameTimer})
end)

-- Update game time to DB:
AddEventHandler('playerDropped', function()
    local identifiers = GetPlayerIdentifiers(source)
    local steamHEX
    for k,v in pairs(identifiers) do
        if string.find(v, "license") then
            steamHEX = v
            break
        end
    end

    local onlineTime = 0
    local curPlayer
    for k,v in pairs(PlyPlayTime) do
        if v.identifier == steamHEX then
            onlineTime = v.time
            curPlayer = k
        end
    end

    local playerID = steamHEX
    local results = MySQL.Sync.fetchAll('SELECT * FROM owned_vehicles WHERE owner=@identifier',{['@identifier'] = playerID})

    for k,v in pairs(results) do
        if v.finance >= 1 then
            MySQL.Sync.execute('UPDATE owned_vehicles SET repaytime=@repaytime WHERE plate=@plate', {['@repaytime'] = math.floor(v.repaytime - (((GetGameTimer() - onlineTime) / 1000) / 60)), ['@plate'] = v.plate} )
        end
    end
    table.remove(PlyPlayTime, curPlayer)
end)
 ]]