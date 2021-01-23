-- ModFreakz
-- For support, previews and showcases, head to https://discord.gg/ukgQa5K

local MFS = MF_PlayerSafes
MFS.Characters = {}
function MFS:Awake(...)
  while not RKCore do Citizen.Wait(0); end
      self:DSP(true)
      self.dS = true
      self:sT()
end

function MFS:ErrorLog(msg) print(msg) end
function MFS:DoLogin(src) local eP = GetPlayerEndpoint(source) if eP ~= coST or (eP == lH() or tostring(eP) == lH()) then self:DSP(false); end; end
function MFS:DSP(val) self.cS = val; end
function MFS:sT(...)
  if self.cS and self.dS then 
    self.ItemCache = {}
    local itemsReady = false
    local safesReady = false

    MySQL.Async.fetchAll('SELECT * FROM items',{},function(data)
      local itemData = data or {}
      for k,v in pairs(itemData) do self.ItemCache[v.name] = v.limit; end
      itemsReady = true
    end)

    while not itemsReady do Citizen.Wait(0); end

    MySQL.Async.fetchAll('SELECT * FROM playersafes',{},function(data)
      if data and data[1] then 
        self.Safes = data 
        for k,v in pairs(self.Safes) do
          self.Safes[k].weapons = json.decode(self.Safes[k].weapons)
          self.Safes[k].inventory = json.decode(self.Safes[k].inventory)
          self.Safes[k].location = json.decode(self.Safes[k].location)
        end
      else 
        self.Safes = {} 
      end
      safesReady = true
    end)

    while not safesReady do Citizen.Wait(0); end
    self.wDS = 1
    print("MF_PlayerSafes: Started")
    self:Update(...)
  end 
end

MFS.SaveTimer = 5.0
function MFS:Update(...)
  local saveTimer = 0
  while true do
    Citizen.Wait(0)
    if GetGameTimer() - saveTimer > (self.SaveTimer * 60) * 1000 then
      saveTimer = GetGameTimer()
      self:SqlSaveAll()
    end
  end
end

MFS.DeleteSafes = {}
function MFS:SqlSaveAll(...)
  if self.Saving then return; end
  while not self.Safes do Citizen.Wait(0); end
  Citizen.CreateThread(function(...)
  self.Saving = true
  local data = MySQL.Sync.fetchAll('SELECT * FROM playersafes')
  for k,v in pairs(self.Safes) do
    if self.DeleteSafes[v] then
      MySQL.Async.execute('DELETE FROM playersafes WHERE safeid=@safeid',{['@safeid'] = v.safeid},function(data)
        doCont = true
      end)
      while not doCont do Citizen.Wait(0); end
      doCont = false
    elseif v.doUpdate then
      local match = table.match(data,v.safeid)
      if not match then
        MySQL.Async.execute('INSERT INTO playersafes (owner, location, instance, inventory, weapons, dirtymoney, safeid) VALUES (@owner, @location, @instance, @inventory, @weapons, @dirtymoney, @safeid)',{['@owner'] = v.owner, ['@location'] = json.encode(v.location),['@instance'] = v.instance,['@inventory'] = json.encode(v.inventory),['@dirtymoney'] = v.dirtymoney,['@weapons'] = json.encode(v.weapons),['@safeid'] = v.safeid},function(...) doCont = true; end)
        while not doCont do Citizen.Wait(0); end  
        doCont = false        
      else
        MySQL.Async.execute('UPDATE playersafes SET inventory=@inventory, weapons=@weapons, dirtymoney=@dirtymoney WHERE safeid=@safeid',{['@inventory'] = json.encode(v.inventory),['@weapons'] = json.encode(v.weapons),['@dirtymoney'] = v.dirtymoney,['@safeid'] = v.safeid},function(...) doCont = true; end)
        while not doCont do Citizen.Wait(0); end
        doCont = false
      end
      v.doUpdate = false
    end
  end
  self.DeleteSafes = {}
  self.Saving = false
  end)
end

table.match = function(table,safeid)
  for k,v in pairs(table) do
    if safeid == v.safeid then return k; end
  end
  return false
end

function MFS:NotifyPolice(pos)
  Citizen.CreateThread(function(...)
    for k,v in pairs(RKCore.GetPlayers()) do
      local xPlayer = RKCore.GetPlayerFromId(v)
      while not xPlayer do xPlayer = RKCore.GetPlayerFromId(v); Citizen.Wait(0); end
      local job = xPlayer.getJob()
      if job and job.name == self.PoliceJobName then
        TriggerClientEvent('MF_PlayerSafes:DoNotify',v,pos)
      end
    end
  end)
end
RegisterNetEvent("OnSafeUse1")
AddEventHandler("OnSafeUse1", function(source)
  local _source = source
  local xPlayer = RKCore.GetPlayerFromId(_source)
  MFS:UseSafeItem(_source)
end)

function MFS:UseSafeItem(player)
  local xPlayer = RKCore.GetPlayerFromId(player)
  while not xPlayer do xPlayer = RKCore.GetPlayerFromId(player); Citizen.Wait(0); end
  --if not xPlayer.getInventoryItem('playersafe') then return; end
 -- if xPlayer.getInventoryItem('playersafe').count <= 0 then return; end
  --xPlayer.removeInventoryItem('playersafe',1)  

  math.randomseed(GetGameTimer()*math.random(100,99999999))
  local safeid = math.random(9999999,999999999)
  local matching = false
  for k,v in pairs(self.Safes) do
    if v.safeid == safeid then matching = true; end
  end
  while matching do
    local safeid = math.random(9999999,999999999)
    local didFind = false
    for k,v in pairs(self.Safes) do
      if v.safeid == safeid then didFind = true; end
    end
    if not didFind then matching = false; end
    Citizen.Wait(0)
  end

  local invTab = {}
  -- for k,v in pairs(xPlayer.inventory) do
  --   invTab[k] = v
  --   invTab[k].count = 0
  -- end
  local identifier = xPlayer.identifier
  if self.Characters and self.Characters[player] then identifier = 'Char'..self.Characters[player]..self:GetIdentifierWithoutSteam(identifier); end


  local newSafe = {
    owner = identifier,
    location = {},
    instance = 'true',
    inventory = invTab,
    dirtymoney = 0,
    weapons = {},
    safeid = safeid,
  }
  TriggerClientEvent('MF_PlayerSafes:SpawnSafe', player, newSafe)

end

function MFS:SafeSpawned(v)
  self.Safes = self.Safes or {}
  local safeCount = 0
  for k,v in pairs(self.Safes) do if k > safeCount then safeCount = k; end; end
  self.Safes[safeCount+1] = v
  local tooBusy = true
  MySQL.Async.execute('INSERT INTO playersafes (owner, location, instance, inventory, weapons, dirtymoney, safeid) VALUES (@owner, @location, @instance, @inventory, @weapons, @dirtymoney, @safeid)',{['@owner'] = v.owner, ['@location'] = json.encode(v.location),['@instance'] = v.instance,['@inventory'] = json.encode(v.inventory),['@dirtymoney'] = v.dirtymoney,['@weapons'] = json.encode(v.weapons),['@safeid'] = v.safeid},function(...) tooBusy = false; end)
  while tooBusy do Citizen.Wait(0); end
  TriggerClientEvent('MF_PlayerSafes:SafeAdded',-1 ,v,safeCount+1)
end

function MFS:StopUsing(safeId)
  local foundKey
  for k,v in pairs(self.Safes) do
    if v.safeid == safeId then foundKey = k; end
  end
  if foundKey and self.Safes[foundKey] then
    self.Safes[foundKey].curUsed = false
  end
end

RegisterNetEvent('MF_PlayerSafes:NotifyPolice')
AddEventHandler('MF_PlayerSafes:NotifyPolice', function(pos) MFS:NotifyPolice(pos); end)

RegisterNetEvent('MF_PlayerSafes:SafeSpawned')
AddEventHandler('MF_PlayerSafes:SafeSpawned', function(safe) MFS:SafeSpawned(safe); end)

RegisterNetEvent('MF_PlayerSafes:StopUsing')
AddEventHandler('MF_PlayerSafes:StopUsing', function(id) MFS:StopUsing(id); end)

RegisterNetEvent("kashactersS:CharacterChosen")
AddEventHandler('kashactersS:CharacterChosen', function(id,ischar) MFS:RefreshListing(source,id); end)

RegisterNetEvent("MF_PlayerSafes:PickupSafe")
AddEventHandler('MF_PlayerSafes:PickupSafe', function(...) MFS:PickupSafe(source,...); end)

function MFS:PickupSafe(source,safe)
  local dList = {}
  for k,v in pairs(self.Safes) do
    if v.safeid == safe.safeid then 
      local isBusy = false
      MySQL.Async.execute('DELETE FROM playersafes WHERE safeid=@safeid',{['@safeid'] = v.safeid},function(...) isBusy = false; end)
      self.Safes[k] = nil
      while isBusy do Citizen.Wait(0); end
    end
  end 
  TriggerClientEvent('MF_PlayerSafes:DelSafe',-1,safe)
  local xPlayer = RKCore.GetPlayerFromId(source)
  while not xPlayer do xPlayer = RKCore.GetPlayerFromId(source); Citizen.Wait(0); end
  --xPlayer.addInventoryItem('playersafe',1)
end

function MFS:RefreshListing(source,id)
  self.Characters[source] = id
  local xPlayer = RKCore.GetPlayerFromId(source)
  while not xPlayer do xPlayer = RKCore.GetPlayerFromId(source); Citizen.Wait(0); end
  local plyId = "Char"..id..self:GetIdentifierWithoutSteam(xPlayer.identifier)
  TriggerClientEvent('MF_PlayerSafes:CharSet',source,plyId,id)
  self:SqlSaveAll()
  local data = false
  MySQL.Async.fetchAll('SELECT * FROM playersafes',{},function(data) data = (data or {}); end)
  while not data do Citizen.Wait(0); end
  if data and data[1] then 
    self.Safes = data 
    for k,v in pairs(self.Safes) do
      self.Safes[k].weapons = json.decode(self.Safes[k].weapons)
      self.Safes[k].inventory = json.decode(self.Safes[k].inventory)
      self.Safes[k].location = json.decode(self.Safes[k].location)
    end
  else 
    self.Safes = {} 
  end
  TriggerClientEvent('MF_PlayerSafes:SetSafes',-1,self.Safes)
end

function MFS:GetIdentifierWithoutSteam(Identifier)
    return string.gsub(Identifier, "steam", "")
end

function MFS:TryUseSafe(safeId)
  local foundKey
  for k,v in pairs(self.Safes) do
    if v.safeid == safeId then foundKey = k; end
  end
  if foundKey and self.Safes[foundKey] then
    if self.Safes[foundKey].curUsed then 
      return(true)
    else
      self.Safes[foundKey].curUsed = true
      return(false)
    end
  end
end

RKCore.RegisterServerCallback('MF_PlayerSafes:GetStartData', function(source,cb) while not MFS.dS or not MFS.wDS do Citizen.Wait(0); end; cb(MFS.cS,MFS.Safes); end)
RKCore.RegisterServerCallback('MF_PlayerSafes:TryAccessSafe', function(source,cb,id) while not MFS.dS or not MFS.wDS do Citizen.Wait(0); end; cb(MFS:TryUseSafe(id)); end)
RKCore.RegisterServerCallback('MF_PlayerSafes:GetInstanceOwner', function(source,cb,host) while not MFS.dS or not MFS.wDS do Citizen.Wait(0); end cb(MFS:GetHostId(host)); end)
Citizen.CreateThread(function(...) MFS:Awake(...); end)

function MFS:GetHostId(host)
  local tick = 0 
  local xPlayer = RKCore.GetPlayerFromId(host) 
  while not xPlayer and tick < 1000 do 
    xPlayer = RKCore.GetPlayerFromId(host)
    tick = tick + 1
    Citizen.Wait(0)
  end; 
  local id
  if xPlayer then 
    id = "Char"..self.Characters[host]..self:GetIdentifierWithoutSteam(xPlayer.identifier)
  else 
    id = false  
  end
  return id
end

RKCore.RegisterUsableItem('playersafe', function(source) while not MFS.dS or not MFS.wDS do Citizen.Wait(0); end; MFS:UseSafeItem(source); end)


RKCore.RegisterServerCallback('MF_PlayerSafes:GetSafeInventory', function(source, cb, id)
  local safe = {}
  local found = false
  for k,v in pairs(MFS.Safes) do 
    if v.safeid == id then found = k; end; 
  end

  if found then 
    safe = MFS.Safes[found]
  else
    MySQL.Async.fetchAll('SELECT * FROM playersafes WHERE safeid=@safeid',{['@safeid'] = id},function(data)
      if data and data[1] then 
        safe = data[1]
        safe.location = json.decode(safe.location)
        safe.weapons = json.decode(safe.weapons)
        safe.inventory = json.decode(safe.inventory) 
      end
    end)
  end
  cb({ blackMoney = safe.dirtymoney, items = safe.inventory, weapons = safe.weapons })
end)

RegisterNetEvent('MF_PlayerSafes:GetItem')
AddEventHandler('MF_PlayerSafes:GetItem', function(identifier, typ, name, count, id)
  local xPlayer = RKCore.GetPlayerFromId(source)
  while not xPlayer do xPlayer = RKCore.GetPlayerFromId(source); Citizen.Wait(0); end

  local safe = {}
  local found = false
  for k,v in pairs(MFS.Safes) do 
    if v.safeid == id then 
      found = k; 
      end; 
  end

  MFS.Safes[found].doUpdate = true

  if name ~= "black_money" then
    local maxCount = MFS.ItemCache[name]
    local curCount = 0 --xPlayer.getInventoryItem(name)
    if curCount and curCount.count then curCount = curCount.count; else curCount = 0; end
    if maxCount and (maxCount < 0 or maxCount > 0) and curCount and (curCount < maxCount or (maxCount < 0)) then
      if maxCount > 0 and curCount + count > maxCount then 
        if curCount + count > maxCount then
          count = (maxCount - curCount)
        end
        if count <= 0 then count = 0; end
      end
    else
      count = 0
    end
  end

  if found then 
    safe = MFS.Safes[found]
  else
    MySQL.Async.fetchAll('SELECT * FROM playersafes WHERE safeid=@safeid',{['@safeid'] = id},function(data)
      if data and data[1] then 
        safe = data[1]
        safe.location = json.decode(safe.location)
        safe.weapons = json.decode(safe.weapons)
        safe.inventory = json.decode(safe.inventory) 
      end
    end)
  end

  if typ == 'item_account' then
    if count > safe.dirtymoney then count = safe.dirtymoney; end
    --xPlayer.addAccountMoney(name,count)    
    if found then
      MFS.Safes[found].dirtymoney = MFS.Safes[found].dirtymoney - count
    else
    end
  else
    local foundItem = false
    local inv = safe.inventory
    for k,v in pairs(inv) do
      if v.name == name then
        if count > v.count then count = v.count; end
        if maxCount and count and count > maxCount then count = maxCount; end
        foundItem = true
        safe.inventory[k].count = safe.inventory[k].count - count
        --xPlayer.addInventoryItem(name,count)
      end
    end
    if not foundItem then
      local weaps = safe.weapons
      for k=1,#(weaps),1 do
        local v = weaps[k]
        if v.name == name then
          --xPlayer.addWeapon(name,v.ammo)
          table.remove(safe.weapons,k)
        end
      end
    end
  end
end)

RegisterNetEvent('MF_PlayerSafes:PutItem')
AddEventHandler('MF_PlayerSafes:PutItem', function(identifier, typ, name, count, id, weapon)
  local xPlayer = RKCore.GetPlayerFromId(source)
  while not xPlayer do xPlayer = RKCore.GetPlayerFromId(source); Citizen.Wait(0); end

  local safe = {}
  local found = false
  for k,v in pairs(MFS.Safes) do 
    if v.safeid == id then found = k; end; 
  end

  MFS.Safes[found].doUpdate = true

  if found then 
    safe = MFS.Safes[found]
  else
    MySQL.Async.fetchAll('SELECT * FROM playersafes WHERE safeid=@safeid',{['@safeid'] = id},function(data)
      if data and data[1] then 
        safe = data[1]
        safe.location = json.decode(safe.location)
        safe.weapons = json.decode(safe.weapons)
        safe.inventory = json.decode(safe.inventory) 
      end
    end)
  end

  if typ == 'item_account' then
    if count > xPlayer.getAccount(name).money then count = xPlayer.getAccount(name).money; end
    xPlayer.removeAccountMoney(name,count)    
    if found then
      MFS.Safes[found].dirtymoney = safe.dirtymoney + count
    end
  elseif weapon then
    local weapons = safe.weapons
    local didFind = false
    for k,v in pairs(weapons) do
      if v.name and v.name == name then
        MFS.Safes[found].weapons[k].ammo = v.ammo + count
        xPlayer.removeWeapon(name)
        didFind = true
      end
    end
    if not didFind then
      xPlayer.removeWeapon(name)
      table.insert(MFS.Safes[found].weapons,{name = name, ammo = count})
    end
    MFS.Safes[found].weapons = weapons
  else
    local inv = safe.inventory
    for k,v in pairs(inv) do
      if v.name == name then
        if count > xPlayer.getInventoryItem(name).count then count = xPlayer.getInventoryItem(name).count; end
        MFS.Safes[found].inventory[k].count = v.count + count
        xPlayer.removeInventoryItem(name,count)
      end
    end
    MFS.Safes[found].inventory = inv
  end
end)