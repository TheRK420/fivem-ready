fx_version 'adamant'

game 'gta5'

description 'ESX Menu Default'

version '1.0.4'

client_scripts {
	'@rk-core/client/wrapper.lua',
	'client/main.lua'
}

ui_page {
	'html/ui.html'
}

files {
	'html/ui.html',
	'html/css/app.css',
	'html/js/mustache.min.js',
	'html/js/app.js',
	'html/fonts/pdown.ttf',
	'html/fonts/bankgothic.ttf'
}

dependencies {
	'rk-core'
}
