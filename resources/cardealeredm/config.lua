-------------------------------------
------- Created by T1GER#9080 -------
------------------------------------- 

-- 100% Working Version Leaked By FivemLeak.com  --

Config 						= {-55.64, 67.68, 71.95}
Config.Locale 				= 'en'

-- [[ SHOP MENU ]] --
Config.ShopMenu = {{
	Pos = {},
	Key = 38,
	Marker = {
		Enable = true,
		DrawDist = 10.0,
		Type = 27,
		Scale = {x = 1.0, y = 1.0, z = 1.0},
		Color = {r = 240, g = 52, b = 52, a = 100},
	},
	
}}

Config.SellPercent = 25					-- Set commission taken by shop, when player sells a vehicle
Config.ReceiveBankMoney = true			-- Set this to false, in order to receive money in hand when selling a vehicle to PDM
Config.CarInsuranceScript = false		-- Set to false if you don't own this script
Config.BuyVehWhenNoDealers = false		-- Set to true to enable players being able to buy vehicles through shop menu, when no dealer online

-- [[ BOSS MENU ]] -- 100% Working Version Leaked By FivemLeak.com  --
Config.BossMenu = {{
	Pos = {-32.29,-1106.56,26.42},						
	Key = 38,													-- Control Key to open Boss Menu
	Marker = {
		Enable = true,											-- Enable/Disable Draw Marker
		DrawDist = 7.0,											-- Draw Marker Draw Distance
		Type = 27,												-- Draw Marker Type
		Scale = {x = 1.0, y = 1.0, z = 1.0},					-- Draw Marker Scale Settings
		Color = {r = 240, g = 52, b = 52, a = 100}				-- Draw Marker Color Settings
	},
}}
Config.BossGrade = 3											-- Set boss grade here
Config.UseCashMoney = true										-- Set to false to use bank money, when depositing/withdrawing money from dealer society account

-- [[ GENERAL SETTINGS ]] -- 100% Working Version Leaked By FivemLeak.com  --
Config.DealerPos 			= {-55.69,67.53,71.95}			-- Center Pos of the dealer, only change if you move all locations to another custom dealer
Config.DrawTxtDist 			= 3.0								-- Distance to see draw text on display vehicles
Config.VehLoadDistance 		= 20.0								-- Distance from player coords to DealerPos, before display features are loaded. Don't set below 40.0, unless u move cardealer.
Config.CarDealerJobLabel 	= "cardealer"						-- Car Dealer Job Label from Database under table jobs
Config.BoughtVehSpawn 		= {-67.68, 82.27, 71.52}			-- Spawn Position of successfully purchased vehicle
Config.PayWithCash 			= true								-- Purchase vehicles with bank money, set to true to purchase vehicle with cash instead.
Config.MinCommission		= (-10)
Config.MaxCommission		= 50
Config.WarpPlayerIntoVeh	= true								-- Set to true if player should be warped into purchased vehicle
Config.WarpPlyIntoTestVeh 	= true								-- Set to true if player should be warped into test drive vehicle

Config.OwnedVehTable		= 'owned_vehicles'					-- change this if you name your owned_vehicles table something else. Make sure to change all entries in server.lua, as this only changes for the protection.lua

Config.PurchasedVehSpawn = {{									-- Position & heading for purchased vehicle. 
	Pos = {-67.68, 82.27, 71.52},
	H = 65.18,
}}

Config.BigVehSpawn = {{											-- Position & heading for purchased big vehicles. 
	Pos = {-12.79,-1102.75,26.67},
	H = 167.46,
}}

Config.TestReturn = {{
	SmallPos = {-67.68, 82.27, 71.52},
	BigPos = {-19.29,-1103.96,26.67},
	Key = 38,
	DrawText = 4.0,
	Marker = {
		Enable = true,											-- Enable/Disable Draw Marker
		DrawDist = 7.0,											-- Draw Marker Draw Distance
		Type = 27,												-- Draw Marker Type
		Scale = {x = 3.0, y = 3.0, z = 3.0},					-- Draw Marker Scale Settings
		Color = {r = 240, g = 52, b = 52, a = 100}				-- Draw Marker Color Settings
	},
}}

-- [[ DISPLAY CARS ]] -- 100% Working Version Leaked By FivemLeak.com  --
Config.DisplayCars = {
	[1] = { Pos = {-71.33, 68.94, 71.91}, Heading = 59.4 }, 	-- This is: Compacts // DO NOT TOUCH 
	[2] = { Pos = {-63.91, 65.07, 71.9}, Heading = 153.91 }, 	-- This is: MCs // DO NOT TOUCH  
	[3] = { Pos = {-75.59, 75.21, 71.91}, Heading = 150.4 },	-- All other categories
	--[4] = { Pos = {-75.59, 75.21, 71.91}, Heading = 150.4 },	-- All other categories
	--[5] = { Pos = {-72.45, 69.38, 71.74}, Heading = 57.69 },	-- All other categories
	--[6] = { Pos = {-39.31,-1097.04,26.42}, Heading = 148.9 },	-- All other categories
	--[7] = { Pos = {-36.05,-1099.32,26.42}, Heading = 145.77 },	-- This is: SUVs // DO NOT TOUCH 
	--[8] = { Pos = {-40.70,-1105.49,26.42}, Heading = 193.93 }, 	-- This is: Bicycle // DO NOT TOUCH 
	--[9] = { Pos = {-11.90,-1103.13,26.67}, Heading = 159.94 }, 	-- This is: Utility, Vans & Off Road // DO NOT TOUCH
}

-- [[ DISPLAY KEYS ]] -- 100% Working Version Leaked By FivemLeak.com  --
Config.KeyToBuyVeh 			= 38	-- E 			: Key to buy vehicle from display
Config.KeyToConfirmBuyVeh 	= 38	-- E 			: Key to confirm vehicle purchase from display
Config.KeyToCancelBuyVeh 	= 202	-- Backspace 	: Key to cancel vehicle purchase from display

Config.KeyToSwapVehicle		= 47	-- G			: Key to replace display vehicle 
Config.KeyToTestVehicle		= 74	-- H			: Key to test drive display vehicle 

Config.KeyToChangeCom1		= 174	-- LEFT ARROW	: Key to change commission (-1) per click
Config.KeyToChangeCom2		= 175	-- RIGHT ARROW	: Key to change commission (+1) per click

Config.KeyToFinanceVeh 		= 303	-- K			: Key to finance vehicle from display
Config.KeyToConfirmFinance 	= 303	-- K 			: Key to confirm vehicle finance from display
Config.KeyToCancelFinance 	= 202	-- Backspace 	: Key to cancel vehicle finance from display

Config.KeyToChangeDownPay1	= 173	-- DOWN ARROW	: Key to change downpayment (-1) per click
Config.KeyToChangeDownPay2	= 172	-- UP ARROW		: Key to change downpayment (+1) per click


-- [[ VEHICLE FINANCING ]] -- 100% Working Version Leaked By FivemLeak.com  --
Config.InterestRate 			= 5			-- set an interest rate in % that will be added to vehicle price upon financing
Config.MinDownpayment 			= 10		-- set minimum allowed downpayment that car seller can go down to in %
Config.MaxDownpayment 			= 90		-- set maximum allowed downpayment that car seller can go down to in %
Config.MaxTimePerRepay 			= 48		-- set max time before a repay in hours
Config.AmountOfRepayments 		= 10		-- set amount of repayments in total, where (carPrice-downPayment)/10 will be minimum repay amount
Config.DownPaymentToDealerShip 	= false		-- set to true if dealer account should receive downpayments
Config.WarningTime				= 10		-- Warning Time on player login, if repayments are not paid, before vehicles that are not paid are deleted. Set this in minutes.
Config.PayWithBankMoney 		= true		-- set to false in order to pay repayments with cash money on player

-- [[ REGISTRATION PAPER ]] -- 100% Working Version Leaked By FivemLeak.com  --
Config.KeyToHidePaper	= 177			-- set key control to hide registration paper, when it's opened

-- [[ PLATE SETTINGS ]] -- 100% Working Version Leaked By FivemLeak.com  --
Config.PlateNumbers  = 0
Config.PlateLetters  = 3
Config.PlateNumlast  = 3
Config.PlateUseSpace = false

-- [[ BLIP SETTINSG ]] -- 100% Working Version Leaked By FivemLeak.com  --
Config.Blip = {{
	Enable 	= true,
	Pos 	= {-55.64, 67.68, 71.95},
	Sprite 	= 523, Color = 0,
	Name 	= "Exclusive Benefactor Motors",
	Scale 	= 0.8,
	Display = 4,
}}
