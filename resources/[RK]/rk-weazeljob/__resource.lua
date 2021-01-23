resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'RKCore Weazel Job'

version '1.0.0'

client_scripts {
  '@rk-core/locale.lua',
  'locales/en.lua',
  'locales/fr.lua',
  'config.lua',
  'client/main.lua',
   'client/annonce.lua', 
  'client/client.lua' 
}

server_scripts {
  '@rk-core/locale.lua',
  'locales/en.lua',
  'locales/fr.lua',
  'config.lua',
  'server/main.lua'
}
