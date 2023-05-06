fx_version('cerulean')
games({ 'gta5' })
lua54 'yes'

client_scripts{ 
"@NativeUILua_Reloaded/src/NativeUIReloaded.lua",
"client/*.lua", 
}
server_scripts { 
    '@oxmysql/lib/MySQL.lua',
    "server/functions.lua",
    "server/BUCKETS.lua",
 }

shared_scripts {
    '@ox_lib/init.lua',
    "config.lua",
}
