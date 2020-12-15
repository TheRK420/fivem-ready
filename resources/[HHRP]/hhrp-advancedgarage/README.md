# About hhrp_advancedgarage:
Advanced Garage System for HHCore

This Code has been completely re-worked. HHCore Advanced Garage supports Cars, Boats, & Aircrafts. This Garage Script only takes into account the Vehicles Purchased in the Car/Boat/Aircraft Shop or any other Shop that sells Vehicles. Players can also go to the Pound to retrieve their Vehicle if its lost or Destroyed for a Fee. During a reboot all Vehicles go back to the Garage.

# Look in the Wiki before submitting Issues. (Failure to abide by this will result in Block)
* [Added Wiki that has the Common Problems Fixed](https://github.com/HumanTree92/hhrp_advancedgarage/wiki)

# Helpfull Info:
* Unable to Store Vehicles you don't own.
* Ability to Kick people who try to Cheat using the Garage & Set Custom Kick Message.
* Private Property Garages.
* Aircraft, Boat, & Car Garage.
* Aircraft, Boat, & Car Impound.
* Police & Ambulance Impound.

# Requirements:
* Required:
  * [es_extended](https://github.com/HHCore-Org/es_extended)
  * [hhrp_property](https://github.com/HHCore-Org/hhrp_property)
* Optional:
  * [hhrp_advancedvehicleshop](https://github.com/HumanTree92/hhrp_advancedvehicleshop)
  * [hhrp_vehicleshop](https://github.com/HHCore-Org/hhrp_vehicleshop)
  * [hhrp_mechanicjob](https://github.com/HHCore-Org/hhrp_mechanicjob)

# Download & Installation:
1) Download the .zip.
2) Extract the .zip or Open the .zip.
3) Import the `hhrp_vehicleshop_fix.sql` into your database if using with hhrp_vehicleshop or edit your Database & change your job to NOT NULL & DEFAULT civ
3) Place `hhrp_advancedgarage` in your HHCore Directory
4) Add `start hhrp_advancedgarage` to your server.cfg

# KNOWN BUGS:
* There is a Limit on how many Vehicles that can be in each garage. For me it was 36 Vehicles in the Car Garage but after that i couldn't pull anymore out. You can still buy more Boats & Planes if the Car Garage is at 36.
* It is Possible to Duplicate Vehicles but do note that if said Person Duplicates a Vehicle & takes 1 of them & sell thems the other one is useless & can NOT be stored or sold.
* When buying an Apartment or Private House in order for the Garage to show you MUST relog from the SERVER & come back. If you buy an apartment & it doesn't show up make sure you relog.
* Doesn't work well when using the Car Dealer Job.
* If you are having problems with the SQL from hhrp_vehicleshop try the SQL from here. If a problem with the SQL from here try hhrp_vehicleshop SQL. If still having problems please submit an issue.

# Other Scripts:
If you like this please check out some of my other stuff like
* [hhrp_advancedgarage](https://github.com/HumanTree92/hhrp_advancedgarage)
* [hhrp_advancedvehicleshop](https://github.com/HumanTree92/hhrp_advancedvehicleshop)
* [hhrp_advancedhospital](https://github.com/HumanTree92/hhrp_advancedhospital)
* [hhrp_advancedweaponshop](https://github.com/HumanTree92/hhrp_advancedweaponshop)
* [hhrp_advancedfuel](https://github.com/HumanTree92/hhrp_advancedfuel)
* [hhrp_extraitems](https://github.com/HumanTree92/hhrp_extraitems)
* [hhrp_licenseshop](https://github.com/HumanTree92/hhrp_licenseshop)
* [hhrp_vehiclespawner](https://github.com/HumanTree92/hhrp_vehiclespawner)
* [FiveM_CustomMapAddons](https://github.com/HumanTree92/FiveM_CustomMapAddons)

# Archived Scripts:
Scripts that will no longer be Maintained.
* [hhrp_aircraftshop](https://github.com/HumanTree92/hhrp_aircraftshop)
* [hhrp_boatshop](https://github.com/HumanTree92/hhrp_boatshop)
* [hhrp_truckshop](https://github.com/HumanTree92/hhrp_truckshop)
* [hhrp_plasticsurgery](https://github.com/HumanTree92/hhrp_plasticsurgery)
* [hhrp_hospital](https://github.com/HumanTree92/hhrp_hospital)
* [hhrp_panicbutton](https://github.com/HumanTree92/hhrp_panicbutton)

# Visit Velociti Entertainment:
* TS3 - ts3.velocitientertainment.com
* [Discord](http://discord.velocitientertainment.com)
* [Website](http://velocitientertainment.com/)
* [Forums](http://velocitientertainment.com/forum)
* [About Us](http://velocitientertainment.com/pc-gaming/)
* [Donate](http://velocitientertainment.com/donations/)
* [Steam Group](http://steamcommunity.com/groups/velocitientertainment)
* [Facebook](http://facebook.com/VelocitiEntertainment)
* [Twitter](http://twitter.com/VelocitiEnt)
* [YouTube](http://youtube.com/user/HumanTree92)
* [Twitch](http://twitch.tv/humantree92)
* [eBay](http://ebay.com/usr/humantree92)

# Legal
### License
hhrp_advancedgarage - Advanced Garage for HHCore

Copyright (C) 2011-2020 Velociti Entertainment

This program Is free software: you can redistribute it And/Or modify it under the terms Of the GNU General Public License As published by the Free Software Foundation, either version 3 Of the License, Or (at your option) any later version.

This program Is distributed In the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty Of MERCHANTABILITY Or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License For more details.

You should have received a copy Of the GNU General Public License along with this program. If Not, see http://www.gnu.org/licenses/.
