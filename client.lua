-- Helper function to play the animation
function PlayFireworkAnimation(playerPed)
    RequestAnimDict("anim@mp_fireworks")
    while not HasAnimDictLoaded("anim@mp_fireworks") do
        Wait(0)
    end
    TaskPlayAnim(playerPed, "anim@mp_fireworks", "place_firework_3_box", 8.0, -8.0, 2000, 0, 0, false, false, false)
    Wait(2000) -- Wait for animation to finish
end

-- Helper function to spawn the firework battery
function SpawnFireworkBattery(modelHash, fireworkX, fireworkY, fireworkZ, playerPed)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(0)
    end

    local battery = CreateObject(modelHash, fireworkX, fireworkY, fireworkZ - 0.98, true, true, false)
    PlaceObjectOnGroundProperly(battery)
    SetEntityHeading(battery, GetEntityHeading(playerPed)) -- Align with player's facing direction
    return battery
end

-- Helper function to launch the firework sequence
function LaunchFireworkSequence(battery, effect, colors, shotCount, cooldown)
    local batteryCoords = GetEntityCoords(battery)

    RequestNamedPtfxAsset("scr_indep_fireworks")
    while not HasNamedPtfxAssetLoaded("scr_indep_fireworks") do
        Wait(0)
    end

    local colorIndex = 1

    -- Launch multiple shots
    for i = 1, shotCount do
        local color = colors[colorIndex]
        UseParticleFxAssetNextCall("scr_indep_fireworks")
        StartParticleFxNonLoopedAtCoord(
            effect,
            batteryCoords.x, batteryCoords.y, batteryCoords.z + 0.5, -- Use the battery's position and adjust the height slightly
            0.0, 0.0, 0.0,
            1.0,
            false, false, false
        )

        SetParticleFxNonLoopedColour(color[1] / 255, color[2] / 255, color[3] / 255)

        Wait(cooldown) -- Apply the cooldown between shots

        colorIndex = colorIndex + 1
        if colorIndex > #colors then
            colorIndex = 1
        end
    end

    DeleteObject(battery)
end

-- Firework 1 command (15 shots)
RegisterCommand("firework1", function(source, args, rawCommand)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local forwardVector = GetEntityForwardVector(playerPed)

    local fireworkX = playerCoords.x + forwardVector.x * 1.5
    local fireworkY = playerCoords.y + forwardVector.y * 1.5
    local fireworkZ = playerCoords.z

    PlayFireworkAnimation(playerPed)

    local batteryHash = GetHashKey("ind_prop_firework_03")
    local battery = SpawnFireworkBattery(batteryHash, fireworkX, fireworkY, fireworkZ, playerPed)

    TriggerEvent("firework:battery_launch", battery)
end, false)

RegisterNetEvent("firework:battery_launch")
AddEventHandler("firework:battery_launch", function(battery)
    local particles = {"scr_indep_firework_starburst"}
    local colors = {
        {255, 0, 0},
        {0, 255, 0},
        {0, 0, 255},
    }

    -- Launch 15 shots
    LaunchFireworkSequence(battery, particles[math.random(#particles)], colors, 15, 1500 + math.random(500))
end)

-- Firework 2 command (1 shot)
RegisterCommand("firework2", function(source, args, rawCommand)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local forwardVector = GetEntityForwardVector(playerPed)

    local fireworkX = playerCoords.x + forwardVector.x * 1.5
    local fireworkY = playerCoords.y + forwardVector.y * 1.5
    local fireworkZ = playerCoords.z

    PlayFireworkAnimation(playerPed)

    local batteryHash = GetHashKey("ind_prop_firework_04")
    local battery = SpawnFireworkBattery(batteryHash, fireworkX, fireworkY, fireworkZ, playerPed)

    TriggerEvent("firework2:battery_launch", battery)
end, false)

RegisterNetEvent("firework2:battery_launch")
AddEventHandler("firework2:battery_launch", function(battery)
    local particles = {"scr_indep_firework_shotburst"}
    local colors = {
        {255, 0, 0},
        {0, 255, 0},
        {0, 0, 255},
    }

    -- Launch 1 shot
    LaunchFireworkSequence(battery, particles[math.random(#particles)], colors, 1, 1500 + math.random(500))
end)

-- Firework 3 command (100 shots with cooldown of 0.4 seconds)
RegisterCommand("firework3", function(source, args, rawCommand)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local forwardVector = GetEntityForwardVector(playerPed)

    local fireworkX = playerCoords.x + forwardVector.x * 1.5
    local fireworkY = playerCoords.y + forwardVector.y * 1.5
    local fireworkZ = playerCoords.z

    PlayFireworkAnimation(playerPed)

    local batteryHash = GetHashKey("ind_prop_firework_02") -- Using the same model as firework2
    local battery = SpawnFireworkBattery(batteryHash, fireworkX, fireworkY, fireworkZ, playerPed)

    TriggerEvent("firework3:battery_launch", battery)
end, false)

RegisterNetEvent("firework3:battery_launch")
AddEventHandler("firework3:battery_launch", function(battery)
    local particles = {"scr_indep_firework_shotburst"}
    local colors = {
        {255, 255, 255},       -- Red
    }
    

    -- Launch 100 shots with a 0.4-second cooldown between shots
    LaunchFireworkSequence(battery, particles[math.random(#particles)], colors, 100, 200) -- 400ms cooldown
end)
