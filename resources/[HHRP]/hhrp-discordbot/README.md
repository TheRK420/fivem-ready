# HHCore Discord bot

FX Server Discord bot

## Description

This bot will send alert directly on your discord server , easy to install.

## Requirements

[HHCore_society](https://github.com/HHCore-Org/HHCore_society)
[es_extended](https://github.com/HHCore-Org/es_extended)


## Installation

1.CD in your resources/[HHCore]folder

2.Clone the repository

```
https://github.com/ElNelyo/HHCore_discord_bot.git
```

3.Add "_start HHCore\_discord\_bot_" to your server.cfg

4.Create your Discord Bot

1.	Go to your server settings :
[display image](http://prntscr.com/gx298g)

2.	Create webhooks (you can change image and name:
[display image](http://prntscr.com/gx2ai7)

3. Copy the webhook link

5.Edit **config.lua** from _HHCore\_discord\_bot_ and paste your **webhook link**

6.Add these lines in **HHCore_extended/server/main.lua**




In ```RegisterServerEvent('hhrp:giveInventoryItem')```



**item_standart** :

```
TriggerEvent("hhrp:giveitemalert",sourceXPlayer.name,targetXPlayer.name,HHCore.Items[itemName].label,itemCount)
```

**item_money**:

```
TriggerEvent("hhrp:givemoneyalert",sourceXPlayer.name,targetXPlayer.name,itemCount)
```

**item_account**:

```
TriggerEvent("hhrp:givemoneybankalert",sourceXPlayer.name,targetXPlayer.name,itemCount)
```

**item_weapon**:

```
TriggerEvent("hhrp:giveweaponalert",sourceXPlayer.name,targetXPlayer.name,weaponLabel)
```



You should have something like this
[display image](http://prntscr.com/gx2hrk)




7.Add this line in **HHCore_society/server/main.lua**

In ```RegisterServerEvent('HHCore_society:washMoney')```

```
TriggerEvent("hhrp:washingmoneyalert",xPlayer.name,amount)
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

