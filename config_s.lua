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

ConfigServer = {}
ConfigServer.ExtensionsInUse = {
    nex_clothes = false,
    nex_metabolism = false,
    nex_skillz = false,
    nex_basic = false,
    nex_tattoos = false,
}

--[[
    The sentence is executed after create a new character, so this always be the same and include a @identifier & @characterId
]]
ConfigServer.CustomSQLStatements = {
    --'INSERT INTO users_something (identifier, characterId) VALUES (@identifier, @characterId)'
}