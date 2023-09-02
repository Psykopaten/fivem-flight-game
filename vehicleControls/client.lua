local engineStarted = false
local engineStartTimer = 0
local engineStartDuration = 1000
local notificationVisible = false
local canToggleEngine = true
local vehicleStopped = false
local stopEngineTimer = 0
local stopEngineDuration = 1000

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        
        if IsPedInAnyVehicle(playerPed, false) then
            if not engineStarted then
                if not notificationVisible then
                    DisplayHelpText("Hold ~INPUT_CONTEXT~ to start the engine.")
                    notificationVisible = true
                end
                if IsControlJustPressed(0, 38) then
                    if canToggleEngine then
                        engineStartTimer = GetGameTimer()
                    end
                end
            else
                local currentSpeed = GetEntitySpeed(vehicle)
                if currentSpeed < 0.1 then
                    vehicleStopped = true
                else
                    vehicleStopped = false
                end
                
                if vehicleStopped then
                    if engineStarted then
                    DisplayHelpText("Hold ~INPUT_CONTEXT~ to turn off the engine.")
                        if IsControlPressed(0, 38) then
                            if stopEngineTimer == 0 then
                                stopEngineTimer = GetGameTimer()
                            elseif GetGameTimer() - stopEngineTimer >= stopEngineDuration then
                                engineStarted = false
                                SetVehicleEngineOn(vehicle, false, true)
                                DisplayHelpText("Engine stopped.")
                                stopEngineTimer = 0
                            end
                        else
                            stopEngineTimer = 0
                        end
                    end
                end
            end
        else
            notificationVisible = false
            vehicleStopped = false
            stopEngineTimer = 0
        end
        
        if engineStartTimer > 0 then
            if IsControlPressed(0, 38) then
                if GetGameTimer() - engineStartTimer >= engineStartDuration then
                    engineStarted = not engineStarted
                    if engineStarted then
                        SetVehicleEngineOn(vehicle, true, true)
                        DisplayHelpText("Engine started!")
                    else
                        SetVehicleEngineOn(vehicle, false, true)
                        DisplayHelpText("Engine stopped.")
                    end
                    canToggleEngine = false
                    Citizen.Wait(1000)
                    canToggleEngine = true
                end
            else
                engineStartTimer = 0
            end
        end
    end
end)

function DisplayHelpText(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
