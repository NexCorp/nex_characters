fx_version 'cerulean'
games { 'gta5' }
author 'AlexBanPer'
description 'Character UI and controlling'
version '1.0.0'

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    'config_s.lua',
    "server/main.lua",
}

client_scripts {
    "client/main.lua",
}

shared_scripts {
    'config.lua'
}

ui_page {
    'html/ui.html',
}
files {
    'html/ui.html',
    'html/css/main.css',
    'html/js/app.js',
}
