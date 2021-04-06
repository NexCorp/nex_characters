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

--[[ GLOBAL VARIABLES  ]]
NEX = nil
NexPlayerData = nil
NexSpawnPoint = Config.FirstSpawnPoint


--[[ LOCAL VARIABLES ]]
local stillWaitingCharacterChange = true
local isInSwitchingMenu = false
local characterSelected = 0
local newCharacter = 0
local disabledKeys = true
local isPlayerSwitching = false


Citizen.CreateThread(function()
    while NEX == nil do
        Citizen.Wait(3)
        TriggerEvent('nexus:getNexusObject', GetCurrentResourceName(), function(obj) 
            NEX = obj 
        end)
    end

    DisplayHud(false)
    DisplayRadar(false)

    --Compatibility mode with nexUI (Just with nexUI)
    --Here you can turn off your HUD 
    TriggerEvent('nex:UI:HUD:Display', false)

    TriggerEvent('nex:characters:PlayersIsSwitching')
    
    Citizen.Wait(2000)

    SendNUIMessage({
        action = "setServerConfig",
        title = Config.ServerName,
    })

    NEX.TriggerServerCallback('nex:characters:isPlayerReadyForPlay', function(isReady)
        -- isReady check if player is already log in into the world, so you can restart the script without problems.
        if isReady then
            SetNuiFocus(false, false)
            NEX.TriggerServerCallback('nex:characters:getMainInfo', function(data) 
                
                SendNUIMessage({
                    action = "closeui", -- closeui
                    characters = data,
                })
                isInSwitchingMenu = false
            end)
            DisplayHud(true)
            TriggerEvent('nex:UI:HUD:Display', true)
        else
            NEX.TriggerServerCallback('nex:characters:getMainInfo', function(data)
                SendNUIMessage({
                    action = "openui", -- openui
                    characters = data,
                })
                PreparePedForSelector(true)
                SetNuiFocus(true, true)
            end)
            NEX.UI.SendAlert('inform', '¡Bienvenido a '.. Config.ServerName ..'!', {})
        end
    end)
end)

RegisterCommand(Config.ForceUICommand, function(source, args, c)
    if characterSelected == 0 then
        print("Reloading UI...")
        NEX.TriggerServerCallback('nex:characters:getMainInfo', function(data)
            SendNUIMessage({
                action = "openui", -- openui
                characters = data,
            })
            PreparePedForSelector(true)
            SetNuiFocus(true, true)
        end)
    end
end, false)

RegisterCommand(Config.ExitToMainMenuCommand, function(source, args, raw)
    TriggerEvent('nex:Characters:ExitToMainMenu')
end, false)

--[[

 _____                _       
|  ___|              | |      
| |____   _____ _ __ | |_ ___ 
|  __\ \ / / _ \ '_ \| __/ __|
| |___\ V /  __/ | | | |_\__ \
\____/ \_/ \___|_| |_|\__|___/
                              

]]

RegisterNetEvent('nex:characters:PlayersIsSwitching')
RegisterNetEvent('nex:Characters:ExitToMainMenu')
RegisterNetEvent('nex:Characters:ConfirmLoaded')
RegisterNetEvent("nex:characters:prepareForSwitching")
RegisterNetEvent('nex:Characters:ForcePlayerLoad')

--- WIP | This may force to target player go to main menu

AddEventHandler('nex:Characters:ForcePlayerLoad', function()
    NEX.TriggerServerCallback('nex:characters:getMainInfo', function(data)
        SendNUIMessage({
            action = "openui", -- openui
            characters = data,
        })
        PreparePedForSelector(true)
        SetNuiFocus(true, true)
    end)
end)

AddEventHandler('nex:Characters:ExitToMainMenu', function()
    -- Check if player is already switching
    if isPlayerSwitching then
        return NEX.UI.SendAlert("error", "Whoops!", "Espera antes de volver a cambiar personaje...", 3000, {})
    end

    if GetEntityHealth(PlayerPedId()) < 150 then
        return NEX.UI.SendAlert("error", "Whoops!", "Estas con 50% o menos de salud.", 3000, {})
    end

    if IsPedInAnyVehicle(PlayerPedId(), true) then
        return NEX.UI.SendAlert("error", "Whoops!", "No puedes cambiar de personaje cuando estas en un vehículo.", 3000, {})
    elseif isInSwitchingMenu then
        return NEX.UI.SendAlert("error", "Whoops!", "Ya estas en el menú de selección.", 3000, {})
    end

    --Trigger with NEX-BASICS
    if Config.UseNexBasic then
        NEX.TriggerServerCallback('nex:RPDeath:getDeathStatus', function(isDead)
            if not isDead then
                TriggerServerEvent('nex:characters:PlayerIsReadyForPlay', false)
                TriggerEvent('nex:characters:PlayersIsSwitching')
                TriggerEvent('nex:UI:HUD:Display', false)
                TriggerEvent('nex:characters:prepareForSwitching', true, true)
                PreparePedForSelector(true)
                isInSwitchingMenu = true
                stillWaitingCharacterChange = true
                Citizen.Wait(8000)
                isPlayerSwitching = false
                SetNuiFocus(true, true)
                NEX.TriggerServerCallback('nex:characters:getMainInfo', function(data) 
                    SendNUIMessage({
                        action = "openui",
                        characters = data,
                    })
                end)
            else
                return NEX.UI.SendAlert("error", "Whoops!", "No puedes cambiar de personaje en este estado. Si te vas a dormir, al regresar perderas todas tus pertenencias.", 3000, {})
            end
        end)
    else
        TriggerServerEvent('nex:characters:PlayerIsReadyForPlay', false)
        TriggerEvent('nex:characters:PlayersIsSwitching')
        TriggerEvent('nex:UI:HUD:Display', false)
        TriggerEvent('nex:characters:prepareForSwitching', true, true)
        PreparePedForSelector(true)
        isInSwitchingMenu = true
        stillWaitingCharacterChange = true
        Citizen.Wait(8000)
        isPlayerSwitching = false
        SetNuiFocus(true, true)
        NEX.TriggerServerCallback('nex:characters:getMainInfo', function(data) 
            SendNUIMessage({
                action = "openui",
                characters = data,
            })
        end)
    end
end)

AddEventHandler("nex:characters:prepareForSwitching", function(stillWaiting, isToMenu)
    --print(isPlayerSwitching, 1)
    if isPlayerSwitching then return end

    Citizen.CreateThread(function()
        isPlayerSwitching = true
        SwitchOutPlayer(PlayerPedId(), 0, 1)

        StartDisabledKeys()

        Citizen.Wait(3000)
        DoScreenFadeIn(1000)


        if not isToMenu or isToMenu == nil then
            if Config.UseNexBasic then
                NEX.TriggerServerCallback('nex:RPDeath:getDeathStatus', function(isDead)
                    if not isDead then
                        if stillWaiting then
                            while stillWaitingCharacterChange do
                                Citizen.Wait(15000)
                            end
                        else
                            while IsPlayerSwitchInProgress() do
                                Citizen.Wait(15000)
                                break
                            end
                        end

                        LoadPlayerData()
                    else
                        TriggerEvent('nex:RPDeath:RemoveItemsAfterDeath')
                    end
                end)
            else
                if stillWaiting then
                    while stillWaitingCharacterChange do
                        Citizen.Wait(15000)
                    end
                else
                    while IsPlayerSwitchInProgress() do
                        Citizen.Wait(15000)
                        break
                    end
                end

                LoadPlayerData()
            end
        end
    end)
end)


AddEventHandler('nex:Characters:ConfirmLoaded', function()
    LoadPlayerData()
end)

--[[


 _   _       _   _____       _ _ _                _        
| \ | |     (_) /  __ \     | | | |              | |       
|  \| |_   _ _  | /  \/ __ _| | | |__   __ _  ___| | _____ 
| . ` | | | | | | |    / _` | | | '_ \ / _` |/ __| |/ / __|
| |\  | |_| | | | \__/\ (_| | | | |_) | (_| | (__|   <\__ \
\_| \_/\__,_|_|  \____/\__,_|_|_|_.__/ \__,_|\___|_|\_\___/
                                                           
                                                           


]]

-- You may send specific CODE for character CK.
RegisterNUICallback('DeleteCharacter', function(data, cb)
    local xData = data
    local isWaiting = false
    characterSelected = data.charSelected
    NEX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'nex_characters_CK_Code',
	{
		title = ('Íngresa el código de CK otorgado por moderación:')
	},
	function(data, menu)
		local ckCode = tonumber(data.value)
		if ckCode == nil then
		    return NEX.UI.SendAlert("error", "Whoops!", "El Código debe ser númerico.", 2000, {})
        else
            if not isWaiting then
                NEX.TriggerServerCallback('nex:characters:ValidateCK', function(isValid)
                    if isValid then
                        NEX.UI.SendAlert("success", "¡Código válidado!", "Se procedera a eliminar tu personaje...", 4000, {})
                        menu.close()
                        SetNuiFocus(true, true)
                        SendNUIMessage({
                            action = "canSelectAgain"
                        })
                        SendNUIMessage({
                            action = "response",
                            responseCat = "enableLoading",
                            responseState = true,
                        })
                        
                        Citizen.Wait(4000 + math.random(1000, 3000))
                        NEX.TriggerServerCallback('nex:characters:getMainInfo', function(charData) 
                            SendNUIMessage({
                                action = "response",
                                responseCat = "onDeleteCharacterSuccess",
                                responseState = false,
                                response = {
                                    characters = charData,
                                    type = "success",
                                    title = "PERSONAJE ELIMINADO",
                                    msg = "¡Su personaje fue eliminado de forma PERMANENTE!"
                                },
                            })
                        end)
                    else
                        SendNUIMessage({
                            action = "canSelectAgain",
                        })
                        NEX.UI.SendAlert("error", "Whoops!", "Este código no es válido.", 4000, {})
                    end
                end, ckCode, characterSelected)
                isWaiting = true
            else
                NEX.UI.SendAlert("error", "Whoops!", "Por favor espera unos segundos antes de volver a verificar.", 4000, {})
                Citizen.Wait(3000)
                isWaiting = false
            end
		end
	end,
	function(data, menu)
        menu.close()
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "canSelectAgain",
        })
	end)
end)

RegisterNUICallback('CreatingNewCharacter', function(data, cb)
    local xData = data
    Citizen.Wait(2000 + math.random(1000, 3000))
    NEX.TriggerServerCallback('nex:characters:ServerValidations', function(isCreated)
        if isCreated then
            Citizen.Wait(300)
            NEX.TriggerServerCallback('nex:characters:getMainInfo', function(charData) 
                SendNUIMessage({
                    action = "response",
                    responseCat = "onCreateCharacterSuccess",
                    responseState = false,
                    response = {
                        characters = charData,
                        type = "success",
                        title = "NUEVO PERSONAJE",
                        msg = "¡Nuevo personaje creado con éxito!"
                    },
                })
            end)
        else
            SendNUIMessage({
                action = "response",
                responseCat = "onCreateCharacterError",
                responseState = false,
                response = {
                    type = "error",
                    title = "Error Encontrado",
                    msg = "Verifica que todos los campos sean correctos, si el problema persiste, contacta con un administrador."
                }
            })
        end
    end, xData)
    cb('ok')
end)

RegisterNUICallback('PlayWithHim', function(data, cb)
    DoScreenFadeOut(1000)
    SendNUIMessage({
        action = "closeui",
        characters = {},
    })
    stillWaitingCharacterChange = false
    characterSelected = data.charSelected
    TriggerServerEvent('nex:characters:prepareForSwitching', data.charSelected)
    SetNuiFocus(false, false)
    Citizen.Wait(3500)
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    Citizen.Wait(2000)
    NEX.ShowNotification('~y~[~b~PERSONAJE~y~] ~g~Tu personaje se ha cargado con éxito.')
end)

--[[

______                _   _                 
|  ___|              | | (_)                
| |_ _   _ _ __   ___| |_ _  ___  _ __  ___ 
|  _| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
| | | |_| | | | | (__| |_| | (_) | | | \__ \
\_|  \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
                     

]]

function LoadPlayerData()
    Citizen.Wait(2000)
    TriggerServerEvent('nex:characters:PlayerIsReadyForPlay', true)
    TriggerServerEvent('nex:StatusHUD:GetData')
    
    SwitchInPlayer(PlayerPedId())

    Citizen.Wait(1000)
    PlaySoundFrontend(-1, "Zoom_Out", "DLC_HEIST_PLANNING_BOARD_SOUNDS", 1)
    PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)
    NEX.UI.SendAlert("inform", "Cargando...", "Estamos cargando tus opciones, por favor espera.", 4000, {})
    TriggerServerEvent('nex:Clothing:TryLoadCharacter') 
    StopSound(-1)
    ReleaseSoundId(-1)
    TriggerServerEvent('requestupdatecid')

    Citizen.Wait(7000)
    PreparePedForSelector(false)
    TriggerEvent('nex:Core:onPlayerSpawn')
    NEX.UI.SendAlert("inform", "Cargando...", "Tu personaje ha sido cargado con éxito", 4000, {})
    disabledKeys = false
    TriggerEvent('nex:UI:HUD:Display', true)
    TriggerEvent('nex:Tattoos:LoadPlayerTattooes')
    isPlayerSwitching = false
end

function PreparePedForSelector(toggle)
    local playerPed = GetPlayerPed(-1)
    isInSwitchingMenu = toggle
    DisplayHud(not toggle)
    SetEntityInvincible(playerPed, toggle)
    FreezeEntityPosition(playerPed, toggle)
    ClearPedTasksImmediately(playerPed)
    ClearPedBloodDamage(playerPed)
    NEX.UI.Menu.CloseAll()
end

function StartDisabledKeys()
    Citizen.CreateThread(function()
        while disabledKeys do
            Citizen.Wait(5)
            DisableControlAction(0, 288, true)
            DisableControlAction(0, 289, true)
            DisableControlAction(0, 170, true)
            DisableControlAction(0, 166, true)
            DisableControlAction(0, 167, true)
            DisableControlAction(0, 168, true)
            DisableControlAction(0, 169, true)
            DisableControlAction(0, 56, true)
            DisableControlAction(0, 57, true)
            DisableControlAction(0, 82, true)
            DisableControlAction(0, 81, true)
        end
    end)
end