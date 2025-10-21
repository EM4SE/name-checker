--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║                                                              ║
    ║                 NAME CHECKER - CLIENT SIDE                   ║
    ║                                                              ║
    ║  Author: EMASE                                               ║
    ║  Description: FiveM Name Verification System                 ║
    ║  Version: 2.0.0                                              ║
    ║                                                              ║
    ║  This script ensures players' FiveM names match their        ║
    ║  character names with a stylish warning UI and countdown.    ║
    ║                                                              ║
    ╚══════════════════════════════════════════════════════════════╝
--]]

-- ═══════════════════════════════════════════════════════════════
--  VARIABLES
-- ═══════════════════════════════════════════════════════════════
local showingWarning = false
local currentFivemName = ""
local currentCharName = ""
local kickTimer = 10

-- ═══════════════════════════════════════════════════════════════
--  CONTROL DISABLER
--  Disables all controls when warning is shown (except ESC)
-- ═══════════════════════════════════════════════════════════════
CreateThread(function()
    while true do
        Wait(0)
        if showingWarning then
            DisableAllControlActions(0)
            
            -- Allow ESC and pause menu
            EnableControlAction(0, 200, true) -- ESC
            EnableControlAction(0, 322, true) -- ESC alternate
            EnableControlAction(0, 199, true) -- Pause menu
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════
--  WARNING POPUP SYSTEM
--  Shows fullscreen warning with countdown timer
-- ═══════════════════════════════════════════════════════════════
RegisterNetEvent('namecheck:showWarning', function(fivemName, characterName)
    showingWarning = true
    currentFivemName = fivemName
    currentCharName = characterName
    kickTimer = 10
    
    print("[Name Checker] Warning popup activated! Kicking in 10 seconds...")
    
    -- ───────────────────────────────────────────────────────────
    --  COUNTDOWN TIMER THREAD
    -- ───────────────────────────────────────────────────────────
    CreateThread(function()
        while showingWarning and kickTimer > 0 do
            Wait(1000)
            kickTimer = kickTimer - 1
            print("[Name Checker] Kicking in " .. kickTimer .. " seconds...")
        end
    end)
    
    -- ───────────────────────────────────────────────────────────
    --  UI RENDER THREAD
    --  Draws the warning interface every frame
    -- ───────────────────────────────────────────────────────────
    CreateThread(function()
        while showingWarning do
            Wait(0)
            
            -- Full screen dark overlay with vignette effect
            DrawRect(0.5, 0.5, 1.0, 1.0, 0, 0, 0, 240)
            
            -- Outer glow effect (red)
            DrawRect(0.5, 0.5, 0.72, 0.58, 185, 28, 28, 100)
            DrawRect(0.5, 0.5, 0.70, 0.56, 185, 28, 28, 150)
            
            -- Red warning box border
            DrawRect(0.5, 0.5, 0.68, 0.54, 185, 28, 28, 255)
            
            -- Inner black box
            DrawRect(0.5, 0.5, 0.66, 0.52, 15, 15, 15, 255)
            
            -- Top accent bar
            DrawRect(0.5, 0.245, 0.66, 0.008, 185, 28, 28, 255)
            
            -- Flashing red line at very top
            local flash = math.floor(GetGameTimer() / 400) % 2
            if flash == 0 then
                DrawRect(0.5, 0.242, 0.66, 0.004, 255, 50, 50, 255)
            end
            
            -- Title with icon (bigger and more prominent)
            SetTextFont(4)
            SetTextScale(1.0, 1.0)
            SetTextColour(255, 255, 255, 255)
            SetTextCentre(true)
            SetTextDropshadow(0, 0, 0, 0, 0)
            SetTextEntry("STRING")
            AddTextComponentString("âš  WARNING âš ")
            DrawText(0.5, 0.265)
            
            -- Subtitle
            SetTextFont(4)
            SetTextScale(0.65, 0.65)
            SetTextColour(255, 80, 80, 255)
            SetTextCentre(true)
            SetTextDropshadow(2, 0, 0, 0, 255)
            SetTextEntry("STRING")
            AddTextComponentString("ACCESS DENIED")
            DrawText(0.5, 0.310)
            
            -- Main warning text
            SetTextFont(0)
            SetTextScale(0.45, 0.45)
            SetTextColour(220, 220, 220, 255)
            SetTextCentre(true)
            SetTextEntry("STRING")
            AddTextComponentString("Name Mismatch Detected!")
            DrawText(0.5, 0.365)
            
            -- Info text
            SetTextFont(0)
            SetTextScale(0.35, 0.35)
            SetTextColour(180, 180, 180, 255)
            SetTextCentre(true)
            SetTextEntry("STRING")
            AddTextComponentString("Your FiveM name must match your character name")
            DrawText(0.5, 0.400)
            
            -- Separator line 1
            DrawRect(0.5, 0.435, 0.58, 0.002, 255, 255, 255, 80)
            
            -- FiveM Name Section
            SetTextFont(4)
            SetTextScale(0.40, 0.40)
            SetTextColour(255, 150, 150, 255)
            SetTextCentre(true)
            SetTextEntry("STRING")
            AddTextComponentString("FiveM Name")
            DrawText(0.5, 0.450)
            
            SetTextFont(4)
            SetTextScale(0.50, 0.50)
            SetTextColour(255, 100, 100, 255)
            SetTextCentre(true)
            SetTextDropshadow(1, 0, 0, 0, 200)
            SetTextEntry("STRING")
            AddTextComponentString(currentFivemName)
            DrawText(0.5, 0.485)
            
            -- VS Divider
            SetTextFont(4)
            SetTextScale(0.45, 0.45)
            SetTextColour(255, 200, 50, 255)
            SetTextCentre(true)
            SetTextEntry("STRING")
            AddTextComponentString("â‰ ")
            DrawText(0.5, 0.530)
            
            -- Character Name Section
            SetTextFont(4)
            SetTextScale(0.40, 0.40)
            SetTextColour(150, 255, 150, 255)
            SetTextCentre(true)
            SetTextEntry("STRING")
            AddTextComponentString("Character Name")
            DrawText(0.5, 0.565)
            
            SetTextFont(4)
            SetTextScale(0.50, 0.50)
            SetTextColour(100, 255, 100, 255)
            SetTextCentre(true)
            SetTextDropshadow(1, 0, 0, 0, 200)
            SetTextEntry("STRING")
            AddTextComponentString(currentCharName)
            DrawText(0.5, 0.600)
            
            -- Separator line 2
            DrawRect(0.5, 0.640, 0.58, 0.002, 255, 255, 255, 80)
            
            -- COUNTDOWN TIMER (Enhanced with glow)
            local timerColor = {255, 80, 80, 255}
            local glowIntensity = 150
            
            if kickTimer <= 3 then
                -- Flash faster and more intense when timer is low
                local fastFlash = math.floor(GetGameTimer() / 200) % 2
                if fastFlash == 0 then
                    timerColor = {255, 255, 255, 255}
                    glowIntensity = 255
                else
                    timerColor = {255, 50, 50, 255}
                    glowIntensity = 200
                end
            end
            
            -- Timer glow effect
            if kickTimer <= 5 then
                DrawRect(0.5, 0.680, 0.35, 0.065, timerColor[1], timerColor[2], timerColor[3], 30)
            end
            
            -- Timer text
            SetTextFont(4)
            SetTextScale(1.2, 1.2)
            SetTextColour(timerColor[1], timerColor[2], timerColor[3], timerColor[4])
            SetTextCentre(true)
            SetTextDropshadow(4, 0, 0, 0, glowIntensity)
            SetTextEntry("STRING")
            AddTextComponentString("KICKING IN: " .. kickTimer .. "s")
            DrawText(0.5, 0.660)
            
            -- Bottom instructions
            SetTextFont(0)
            SetTextScale(0.38, 0.38)
            SetTextColour(255, 220, 100, 255)
            SetTextCentre(true)
            SetTextEntry("STRING")
            AddTextComponentString("â„¹ Change your FiveM/Steam name and reconnect")
            DrawText(0.5, 0.725)
            
            -- Footer
            SetTextFont(0)
            SetTextScale(0.30, 0.30)
            SetTextColour(100, 100, 100, 255)
            SetTextCentre(true)
            SetTextEntry("STRING")
            AddTextComponentString("Name Checker by EMASE")
            DrawText(0.5, 0.755)
        end
    end)
end)

-- ═══════════════════════════════════════════════════════════════
--  HIDE WARNING
--  Removes warning popup when name is verified
-- ═══════════════════════════════════════════════════════════════
RegisterNetEvent('namecheck:hideWarning', function()
    showingWarning = false
    kickTimer = 0
    print("[Name Checker] Warning popup deactivated - Name verified!")
end)

-- ═══════════════════════════════════════════════════════════════
--  INITIALIZATION
-- ═══════════════════════════════════════════════════════════════
print("^2[Name Checker] Client script loaded!^0")
print("^2[Name Checker] Created by EMASE^0")