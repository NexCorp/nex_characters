--[[


$$\   $$\                            $$$$$$\  $$\                                                $$\                                   
$$$\  $$ |                          $$  __$$\ $$ |                                               $$ |                                  
$$$$\ $$ | $$$$$$\  $$\   $$\       $$ /  \__|$$$$$$$\   $$$$$$\   $$$$$$\  $$$$$$\   $$$$$$$\ $$$$$$\    $$$$$$\   $$$$$$\   $$$$$$$\ 
$$ $$\$$ |$$  __$$\ \$$\ $$  |      $$ |      $$  __$$\  \____$$\ $$  __$$\ \____$$\ $$  _____|\_$$  _|  $$  __$$\ $$  __$$\ $$  _____|
$$ \$$$$ |$$$$$$$$ | \$$$$  /       $$ |      $$ |  $$ | $$$$$$$ |$$ |  \__|$$$$$$$ |$$ /        $$ |    $$$$$$$$ |$$ |  \__|\$$$$$$\  
$$ |\$$$ |$$   ____| $$  $$<        $$ |  $$\ $$ |  $$ |$$  __$$ |$$ |     $$  __$$ |$$ |        $$ |$$\ $$   ____|$$ |       \____$$\ 
$$ | \$$ |\$$$$$$$\ $$  /\$$\       \$$$$$$  |$$ |  $$ |\$$$$$$$ |$$ |     \$$$$$$$ |\$$$$$$$\   \$$$$  |\$$$$$$$\ $$ |      $$$$$$$  |
\__|  \__| \_______|\__/  \__|       \______/ \__|  \__| \_______|\__|      \_______| \_______|   \____/  \_______|\__|      \_______/ 
                                                                                                                                       
                                                                                                                                       
Distributed by Ukader Network, whose developer has publicly released this copy to the general public. Use it under the GNU AGPL v3 license.

Support is limited, but you can contact the following links: 

Discord: AlexBanPer#4245
Mail: a.martinez@ukader.net

General Support: support@ukader.net
Official Discord: https://discord.gg/rmCv7UJVPD

We appreciate publishing any modification to this under the concepts of collaborative work. 

]]


Config = {}

-- Set first spawn of each character
Config.FirstSpawnPoint = vector3(-539.2, -214.52, 40.0)

Config.ServerName = "NexCore RP"

--[[
    Depending on the client's load, it may exist that sometimes the interface does not load correctly, therefore, 
    the player should place this command to force the load. 
]]
Config.ForceUICommand = "forcechar"
Config.ExitToMainMenuCommand = "exit"

-- Change this if you use a nex-basic extension (update in config_s.lua also)
Config.UseNexBasic = false