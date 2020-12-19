--------------------------------
------- Created by Hamza -------
-------------------------------- 

Config = {}

-- Mining Settings:

Config.MiningMarker = 27 												-- marker type
Config.MiningMarkerColor = { r = 30, g = 139, b = 195, a = 170 } 		-- rgba color of the marker
Config.MiningMarkerScale = { x = 1.25, y = 1.25, z = 1.25 }  			-- the scale for the marker on the x, y and z axis
Config.DrawMining3DText = "Press ~g~[E]~s~ to start ~b~Mining~s~"				-- set your desired text here
Config.KeyToStartMining = 38											-- key to start mining, default; [E]
Config.Pickaxe = "pickaxe"												-- name in database for pickaxe
Config.Stone = "stone"													-- name in database for stone
Config.StoneReward = 5													-- amount of stones player receive after mining process
Config.MaxStoneAmount = 90												-- max amount of stone that player can mine and have in inventory

Config.MiningPositions = {
    [1] = { 
		spot = {2972.1259765625,2841.3889160156,46.025562286377},
		blipEnable = true, blipName = "Mine Spot", blipSprite = 365, blipDisplay = 4, blipColor = 5, blipScale = 0.9,
		mining = false
	},
	[2] = { 
		spot = {2973.166015625,2837.9240722656,45.692588806152},
		blipEnable = false, blipName = "Mine Spot 2", blipSprite = 365, blipDisplay = 4, blipColor = 5, blipScale = 0.9,
		mining = false
	},
	[3] = { 
		spot = {2974.2604980469,2834.1079101563,45.742488861084},
		blipEnable = false, blipName = "Mine Spot 3", blipSprite = 365, blipDisplay = 4, blipColor = 5, blipScale = 0.9,
		mining = false
	},
	[4] = { 
		spot = {2958.474609375,2851.0405273438,47.449024200439},
		blipEnable = false, blipName = "Mine Spot 4", blipSprite = 365, blipDisplay = 4, blipColor = 5, blipScale = 0.9,
		mining = false
	}, 
}

-- Washer Settings:

Config.WasherMarker = 27 												-- marker type
Config.WasherMarkerColor = { r = 30, g = 139, b = 195, a = 170 } 		-- rgba color of the marker
Config.WasherMarkerScale = { x = 1.25, y = 1.25, z = 1.25 }  				-- the scale for the marker on the x, y and z axis
Config.DrawWasher3DText = "Press ~g~[E]~s~ to start ~b~Wash~s~"				-- set your desired text here
Config.KeyToStartWashing = 38											-- key to start mining, default; [E]
Config.Washpan = "pickaxe"												-- name in database for washpan
Config.WStone = "washed_stone"											-- name in database for washed stone
Config.ReqStoneForWash = 10												-- Required amount of stone to process Config.WStoneReward
Config.WStoneReward = 10												-- amount of washed stones player receive after washing process
Config.MaxWStoneAmount = 90												-- max amount of washed stone that player can wash and have in inventory


Config.WashingPositions = {
    [1] = { 
		spot = {1966.8696289063,536.98706054688,160.92445373535},
		blipEnable = true, blipName = "Washing spot 1", blipSprite = 365, blipDisplay = 4, blipColor = 5, blipScale = 0.9
	},
	[2] = { 
		spot = {1994.0406494141,562.95184326172,161.38537597656},
		blipEnable = true, blipName = "Washing spot 2", blipSprite = 365, blipDisplay = 4, blipColor = 5, blipScale = 0.9
	},
}

-- Smelter Settings:

Config.SmelterMarker = 27 												-- marker type
Config.SmelterMarkerColor = { r = 240, g = 52, b = 52, a = 100 } 		-- rgba color of the marker
Config.SmelterMarkerScale = { x = 1.25, y = 1.25, z = 1.25 }  			-- the scale for the marker on the x, y and z axis
Config.DrawSmelter3DText = "Press ~g~[E]~s~ to start ~y~Smelting~s~"	-- set your desired text here
Config.KeyToStartSmelting = 38											-- key to start mining, default; [E]

Config.SmeltingPositions = {
    [1] = { 
		spot = {1088.0810546875,-2001.5245361328,30.879693984985},
		blipEnable = true, blipName = "Smelting Spot", blipSprite = 365, blipDisplay = 4, blipColor = 5, blipScale = 0.9
	},
	[2] = { 
		spot = {1088.5109863281,-2005.1209716797,31.153043746948},
		blipEnable = false, blipName = "Smelting Spot 2", blipSprite = 365, blipDisplay = 4, blipColor = 5, blipScale = 0.9
	},
	[3] = { 
		spot = {1084.6192626953,-2001.9174804688,31.406444549561},
		blipEnable = false, blipName = "Smelting Spot 3", blipSprite = 365, blipDisplay = 4, blipColor = 5, blipScale = 0.9
	},
}

-- PLEASE LOOK IN SERVER.LUA AT THIS EVENT "hhrp_MinerJob:rewardSmelting" TO SEE REWARD CHANCES!!!

-- item 1
Config.Item1 = "uncut_diamond"
Config.ItemReward1 = 1
Config.ItemLimit1 = 25
-- item 2
Config.Item2 = "uncut_rubbies"
Config.ItemReward2 = 1
Config.ItemLimit2 = 30
-- item 3
Config.Item3 = "goldminer"
Config.ItemReward3 = 1
Config.ItemLimit3 = 35
-- item 4
Config.Item4 = "silverminer"
Config.ItemReward4 = 2
Config.ItemLimit4 = 40
-- item 5
Config.Item5 = "copper"
Config.ItemReward5 = 3
Config.ItemLimit5 = 45
-- item 6
Config.Item6 = "iron_ore"
Config.ItemReward6 = 7
Config.ItemLimit6 = 50







