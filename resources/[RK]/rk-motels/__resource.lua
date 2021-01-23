resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
    '@rk-core/locale.lua',
    'config/config.lua',
    'server/main.lua',
    'server/clothing.lua',
    'locales/en.lua'
}

client_scripts {
    '@rk-core/locale.lua',
    'config/config.lua',
    'client/main.lua',
    'client/functions.lua',
    'locales/en.lua'
}
