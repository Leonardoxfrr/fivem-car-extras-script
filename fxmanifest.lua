fx_version 'cerulean'
game 'gta5'

author 'Dein Name'
description 'Fahrzeug-Extras Menü über NativeUI (F11) für ESX'
version '1.0.0'

client_scripts {
    '@NativeUI/NativeUI.lua',
    'client/main.lua',
    'config.lua'
}

server_scripts {
    '@es_extended/locale.lua',
    'server/main.lua'
}

dependency 'es_extended'
