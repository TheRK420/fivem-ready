fx_version 'adamant'

game 'gta5'

description 'Roleplay Items | By Nevo'

version '1.0.0'

client_scripts {
	'@hhrp-core/locale.lua',
	'locales/en.lua',
	'config.lua',
	'client/main.lua'
}

server_scripts {
	"@mysql-async/lib/MySQL.lua",
	'@hhrp-core/locale.lua',
	'locales/en.lua',
	'config.lua',
	'server/server.lua'
}

dependencies {
	'hhrp-core'
}

