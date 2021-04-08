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

NEX = nil

Citizen.CreateThread(function()
    while NEX == nil do
        TriggerEvent('nexus:getNexusObject', function(obj) NEX = obj end)
        Citizen.Wait(15)
    end

    print("[NexCore] [^2INFO^7] NexCharacters initialized successfully")

    NEX.RegisterServerCallback('nex:characters:getMainInfo', function(source, cb)
        local xPlayer = NEX.GetPlayerFromId(source)
        if xPlayer then
            xPlayer.SetPlayerSwitchState(true)
            MySQL.Async.fetchAll('SELECT users.unlockCharacters, users_characters.* FROM users_characters INNER JOIN users ON users_characters.identifier = users.identifier WHERE users.identifier = @identifier', {
                ['@identifier'] = xPlayer.getIdentifier(),
            }, function(result)
                local data = nil
                if result[1] ~= nil then
                    local unlockCharacters = 0
                    if result ~= nil and result[1] ~= nil then
                        unlockCharacters = result[1].unlockCharacters
                    end

                    data = {
                        group       = xPlayer.getGroup(),
                        id          = xPlayer.getDBId(),
                        unlocked    = unlockCharacters,
                        characters  = result
                    }
                else
                    data = {
                        group       = xPlayer.getGroup(),
                        id          = xPlayer.dbId,
                        unlocked    = 0,
                        characters  = {}
                    }
                end
                
                cb(data)
            end)
        end
    end)

    NEX.RegisterServerCallback('nex:characters:ServerValidations', function(source, cb, xData)
        local xPlayer = NEX.GetPlayerFromId(source)
        local canContinue = false
        if xData.firstname and xData.lastname and xData.charId and xData.sex ~= nil and xData.dob and xData.terms and xData.height then
            if (string.len(xData.firstname) >= 2 and string.len(xData.lastname) >= 2) and 
            (xData.charId > 0) and (xData.sex >= 0 and xData.sex <= 1) and 
            (tonumber(xData.height) >= 150 and tonumber(xData.height) <= 200) 
            then
                local maxCharacters = xPlayer.getUnlockedCharacters() + 1
                local sex = "m"
                if xData.sex == 0 then
                    sex = "f"
                end

                if (xPlayer.getUnlockedCharacters() == 0 and xData.charId == 1) or (xData.charId <= maxCharacters) then
                    MySQL.Async.insert('INSERT INTO users_characters (identifier, firstname, lastname, dob, height, sex) VALUES (@identifier, @firstname, @lastname, @dob, @height, @sex)', {
                        ['@identifier'] = xPlayer.identifier,
                        ['@firstname'] = xData.firstname,
                        ['@lastname'] = xData.lastname,
                        ['@dob'] = xData.dob,
                        ['@height'] = xData.height,
                        ['@sex'] = sex
                    }, function(lastId)
                        print("[Characters] [^2INFO^7] Player " .. xPlayer.getName() .. " has created a new character (".. lastId ..") called ".. xData.firstname .. " " .. xData.lastname ..".")
                        
                        
                        local model = 1885233650
                        if xData.sex == 0 then
                            model = -1667301416 -- FEMALE
                        end

                        --[[
                            IMPORTANT:

                            Our system has some complexities, since this adaptation was for private use, our systems are made for certain resources with which we will release with NexCore.
                            If you have user records and then activate some option to use the extension, you will have to manually create the missing records for each player, however, it is likely that each system integrates an automatic method.
                        ]]

                        if ConfigServer.ExtensionsInUse.nex_clothes then
                            MySQL.Async.execute('INSERT INTO users_clothes (identifier, characterId, model) VALUES (@identifier, @characterId, @model)', {
                                ['@identifier'] = xPlayer.identifier,
                                ['@characterId'] = lastId,
                                ['@model'] = model
                            })
                        end

                        if ConfigServer.ExtensionsInUse.nex_metabolism then
                            MySQL.Async.execute('INSERT INTO users_metabolism (identifier, charId) VALUES (@identifier, @characterId)', {
                                ['@identifier'] = xPlayer.identifier,
                                ['@characterId'] = lastId
                            })
                        end

                        if ConfigServer.ExtensionsInUse.nex_skillz then
                            MySQL.Async.execute('INSERT INTO users_skillz (identifier, charId) VALUES (@identifier, @characterId)', {
                                ['@identifier'] = xPlayer.identifier,
                                ['@characterId'] = lastId
                            })
                        end

                        if ConfigServer.ExtensionsInUse.nex_tattoos then
                            MySQL.Async.execute('INSERT INTO users_tattoos (identifier, charId) VALUES (@identifier, @characterId)', {
                                ['@identifier'] = xPlayer.identifier,
                                ['@characterId'] = lastId
                            })
                        end

                        if ConfigServer.ExtensionsInUse.nex_basic then
                            MySQL.Async.execute('INSERT INTO users_jail (identifier, charId) VALUES (@identifier, @characterId)', {
                                ['@identifier'] = xPlayer.identifier,
                                ['@characterId'] = lastId
                            })

                            MySQL.Async.execute('INSERT INTO users_comserv (identifier, charId) VALUES (@identifier, @characterId)', {
                                ['@identifier'] = xPlayer.identifier,
                                ['@characterId'] = lastId
                            })
                        end

                        
                        for _, statement in pairs(ConfigServer.CustomSQLStatements) do
                            MySQL.Async.execute(statement, {
                                ['@identifier'] = xPlayer.identifier,
                                ['@characterId'] = lastId
                            })
                        end

                        canContinue = true
                    end)
                end
            end
        end
        Citizen.Wait(300)
        cb(canContinue)
    end)

    NEX.RegisterServerCallback('nex:characters:isPlayerReadyForPlay', function(source, cb)
        local xPlayer = NEX.GetPlayerFromId(source)
        if xPlayer then
            return cb(xPlayer.IsPlayerReadyForPlay())
        else
            cb(false)
        end
    end)

    NEX.RegisterServerCallback('nex:characters:ValidateCK', function(source, cb, code, charId)
        local xPlayer = NEX.GetPlayerFromId(source)
        MySQL.Async.fetchAll('SELECT * FROM nexus_ck WHERE identifier=@identifier AND code=@code AND charId=@charId AND used = 0', {
            ['@identifier'] = xPlayer.identifier,
            ['@charId'] = charId,
            ['@code'] = code,
        }, function(result)
            if result then
                if result[1] then
                    MySQL.Async.execute('DELETE FROM users_characters WHERE identifier=@identifier AND characterId=@charId', {
                        ['@identifier'] = xPlayer.identifier,
                        ['@charId'] = charId,
                    }, function(rowsChanged)
                        MySQL.Async.execute('UPDATE nexus_ck SET used=1 WHERE id = @id', {
                            ['@id'] = result[1].id,
                        }, function(rowsChanged2) end)
                        print("[Characters] [^2INFO^7] Player " .. xPlayer.getName() .. " delete character (".. charId ..") using code: ".. code .. ".")
                        cb(true)
                    end)
                else
                    cb(false)
                end
            else
                cb(false)
            end
        end)
    end)
end)


RegisterServerEvent('nex:characters:PlayerIsReadyForPlay')
AddEventHandler('nex:characters:PlayerIsReadyForPlay', function(toggle)
    local xPlayer = NEX.GetPlayerFromId(source)
    if xPlayer then
        xPlayer.SetPlayerReadyForPlay(toggle)
    end
    Citizen.Wait(1500)
    if xPlayer then
        xPlayer.SetPlayerReadyForPlay(toggle)
    end

    if toggle then
        xPlayer.setJob(1, xPlayer.job.name, xPlayer.job.grade)
    end
end)

RegisterServerEvent('nex:characters:prepareForSwitching')
AddEventHandler('nex:characters:prepareForSwitching', function(charId)
    local xPlayer = NEX.GetPlayerFromId(source)
    local _source = source
    local _charId = charId
    Citizen.CreateThread(function()
		if xPlayer then
			NEX.SwitchPlayerData(xPlayer, _source, _charId, function(canSwitch)
				if canSwitch then
					xPlayer.showNotification('~g~Character loaded, logging in...')
				end
			end)
		end
	end)
end)