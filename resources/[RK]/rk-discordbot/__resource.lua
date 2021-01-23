resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'littlebot'



-- Server
server_scripts {
	'@async/async.lua',
	'@mysql-async/lib/MySQL.lua',
	'@rk-core/locale.lua',
	'locales/en.lua',
	'locales/fr.lua',
	'config.lua',
	'server/main.lua'
}

-- Client
client_scripts {
	'@rk-core/locale.lua',
	'locales/en.lua',
	'locales/fr.lua',
	'client/main.lua'
}
