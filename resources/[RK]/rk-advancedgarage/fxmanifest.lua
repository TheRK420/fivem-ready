fx_version 'adamant'

game 'gta5'

description 'RKCore Advanced Garage'

version '1.0.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@rk-core/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@rk-core/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua'
}

dependencies {
	'rk-core'
}
