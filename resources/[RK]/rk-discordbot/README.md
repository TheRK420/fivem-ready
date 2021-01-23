# RKCore Discord bot

FX Server Discord bot

## Description

This bot will send alert directly on your discord server , easy to install.

## Requirements

[RKCore_society](https://github.com/RKCore-Org/RKCore_society)
[es_extended](https://github.com/RKCore-Org/es_extended)


## Installation

1.CD in your resources/[RKCore]folder

2.Clone the repository

```
https://github.com/ElNelyo/RKCore_discord_bot.git
```

3.Add "_start RKCore\_discord\_bot_" to your server.cfg

4.Create your Discord Bot

1.	Go to your server settings :
[display image](http://prntscr.com/gx298g)

2.	Create webhooks (you can change image and name:
[display image](http://prntscr.com/gx2ai7)

3. Copy the webhook link

5.Edit **config.lua** from _RKCore\_discord\_bot_ and paste your **webhook link**

6.Add these lines in **RKCore_extended/server/main.lua**




In ```RegisterServerEvent('rk:giveInventoryItem')```



**item_standart** :

```
TriggerEvent("rk:giveitemalert",sourceXPlayer.name,targetXPlayer.name,RKCore.Items[itemName].label,itemCount)
```

**item_money**:

```
TriggerEvent("rk:givemoneyalert",sourceXPlayer.name,targetXPlayer.name,itemCount)
```

**item_account**:

```
TriggerEvent("rk:givemoneybankalert",sourceXPlayer.name,targetXPlayer.name,itemCount)
```

**item_weapon**:

```
TriggerEvent("rk:giveweaponalert",sourceXPlayer.name,targetXPlayer.name,weaponLabel)
```



You should have something like this
[display image](http://prntscr.com/gx2hrk)




7.Add this line in **RKCore_society/server/main.lua**

In ```RegisterServerEvent('RKCore_society:washMoney')```

```
TriggerEvent("rk:washingmoneyalert",xPlayer.name,amount)
```



You should have something like this
[display image](http://prntscr.com/gx2jc5)



## Feature
Discord alert : 
- Kill
- Enter in a police vehicle (exept for policeman)
- Chat 
- Connecting / Disconnecting
- Steal a vehicle
- Giving Item / Money / Weapon 
- Blacklisted vehicle

