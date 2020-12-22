# hhrp_taximeter


![alt text](https://i.imgur.com/1Q2ralm.jpg "HHCore TaxiMeter")


HHCore Taxi Meter is a plugin that adds a fare meter to your server. Great for those
who work as an Uber, Taxi, Limo, Tow, Aircraft Ferry or any other job that might
charge per mile of travel.

Right now it supports two types of fares. A "Flat Rate" fare which is simple
enough and a "distance" fare which shows a fare total based upon the distance
traveled. The driver is the "owner" of the meter and any passengers in the car
will be able to see the meter if it is active.

In the configuration file you can set restrictions on what vehicle and what HHCore
jobs can use the meter. Currently supports both imperial and metric measurements.

The meter can be launched by using LEFTCTRL + G

# Requirements
HHCore

# Installation
Run inside of your server-data/resources folder

```
git clone https://github.com/michaelhodgejr/hhrp_taximeter.git [HHCore]/hhrp_taximeter
```

Add to your server.cfg file

```
start hhrp_taximeter
```

Create your config file from the default.

```
  cp config.default config.lua
```
# Known Issues
When a passenger gets in the vehicle, the driver will need to toggle the radar to
make it appear.

# Upgrading
