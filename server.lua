local blockedPlayers = {}

local function GetCharacterName(src)
    local Player = exports.qbx_core:GetPlayer(src)
    if Player and Player.PlayerData and Player.PlayerData.charinfo then
        local firstname = Player.PlayerData.charinfo.firstname or ""
        local lastname = Player.PlayerData.charinfo.lastname or ""
        return firstname .. " " .. lastname
    end
    return nil
end

local function NormalizeName(name)
    if not name then return "" end
    -- Remove all spaces, special characters, and convert to lowercase
    name = string.gsub(name, "%s+", "")
    name = string.gsub(name, "[^%w]", "")
    return string.lower(name)
end

local function CheckPlayerName(src)
    local fivemName = GetPlayerName(src)
    
    if not fivemName then
        print("[Name Checker] ERROR: Could not get FiveM name for source: " .. src)
        return
    end
    
    Wait(1000) -- Wait for character data to load
    
    local characterName = GetCharacterName(src)
    
    if not characterName then
        print("[Name Checker] WARNING: Could not get character name for: " .. fivemName)
        return
    end
    
    local normalizedFivem = NormalizeName(fivemName)
    local normalizedChar = NormalizeName(characterName)
    
    print("[Name Checker] Checking - FiveM: '" .. normalizedFivem .. "' vs Character: '" .. normalizedChar .. "'")
    
    if normalizedFivem ~= normalizedChar then
        blockedPlayers[src] = true
        TriggerClientEvent('namecheck:showWarning', src, fivemName, characterName)
        print("^1[Name Checker] BLOCKED: " .. fivemName .. " | Character: " .. characterName .. "^0")
        
        -- Start 10 second countdown then kick
        SetTimeout(10000, function()
            -- Check if player still has wrong name
            local stillWrong = blockedPlayers[src]
            if stillWrong then
                DropPlayer(src, "⛔ KICKED: Name Mismatch\n\nYour FiveM name does not match your character name.\n\nFiveM Name: " .. fivemName .. "\nCharacter Name: " .. characterName .. "\n\nPlease change your FiveM/Steam name to match your character and reconnect.")
                print("^1[Name Checker] KICKED: " .. fivemName .. " after 10 seconds^0")
            end
        end)
    else
        blockedPlayers[src] = false
        TriggerClientEvent('namecheck:hideWarning', src)
        print("^2[Name Checker] VERIFIED: " .. fivemName .. "^0")
    end
end

-- QBox player loaded event
RegisterNetEvent('qbx_core:server:onPlayerLoaded', function()
    local src = source
    CheckPlayerName(src)
end)

-- QBCore compatibility (if using older version)
RegisterNetEvent('QBCore:Server:PlayerLoaded', function(Player)
    local src = Player.PlayerData.source
    CheckPlayerName(src)
end)

-- Manual recheck from client
RegisterNetEvent('namecheck:recheckName', function()
    local src = source
    CheckPlayerName(src)
end)

-- Player disconnect cleanup
AddEventHandler('playerDropped', function()
    local src = source
    if blockedPlayers[src] then
        blockedPlayers[src] = nil
        print("[Name Checker] Removed blocked player from list: " .. GetPlayerName(src))
    end
end)

print("^2========================================")
print("[Name Checker] Server script loaded!")
print("[Name Checker] Version 2.0.0")
print("========================================^0")
