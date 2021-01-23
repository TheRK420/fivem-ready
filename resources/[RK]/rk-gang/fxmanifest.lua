fx_version 'adamant'

game 'gta5'

description 'Sody Clubs'

version '1.0.1'

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    '@rk-core/locale.lua',
    'locales/en.lua',
	'config.lua',
	'server.lua',
}

client_scripts {
    '@rk-core/locale.lua',
    'locales/en.lua',
	'config.lua',
	'client.lua',
}
