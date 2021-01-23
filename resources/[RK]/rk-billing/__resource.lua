resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'RKCore Billing'

version '1.1.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'@rk-core/locale.lua',
	'locales/de.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/es.lua',
	'locales/sv.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'@rk-core/locale.lua',
	'locales/de.lua',
	'locales/br.lua',
	'locales/en.lua',
	'locales/fi.lua',
	'locales/fr.lua',
	'locales/es.lua',
	'locales/sv.lua',
	'config.lua',
	'client/main.lua'
}

dependency 'rk-core'