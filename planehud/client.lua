local isReverseThrusting = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = GetPlayerPed(-1)
        local playerVehicle = GetVehiclePedIsIn(playerPed, false)
        
        if DoesEntityExist(playerVehicle) and IsThisModelAPlane(GetEntityModel(playerVehicle)) then
            local playerCoords = GetEntityCoords(playerVehicle)
            local altitude = playerCoords.z
            local speed = GetEntitySpeed(playerVehicle) * 2.23694
            
            local currentGear = GetVehicleCurrentGear(playerVehicle)
            isReverseThrusting = currentGear == 0
            
            local altitudeText = string.format("Altitude: %.2f meters", altitude)
            local speedText = string.format("Speed: %.2f knots", speed)
            local thrustText = isReverseThrusting and "~g~Reverse Thrust" or "~r~Reverse Thrust"
            local headingText = string.format("Heading: %.2f", GetEntityHeading(playerVehicle))

            local pitch = GetEntityPitch(playerVehicle)
            local pitchText = string.format("Pitch: %.2f degrees", pitch)
            
            DrawTextOnScreen(altitudeText, 0.015, 0.75, 0.4, 255, 255, 255)
            DrawTextOnScreen(speedText, 0.1, 0.75, 0.4, 255, 255, 255)
            DrawTextOnScreen(thrustText, 0.015, 0.72, 0.4, 255, isReverseThrusting and 0 or 255, 0)
            DrawTextOnScreen(headingText, 0.47, 0.02, 0.4, 255, 255, 255)
            DrawTextOnScreen(pitchText, 0.47, 0.05, 0.4, 255, 255, 255)
        end
    end
end)

function DrawTextOnScreen(text, x, y, scale, r, g, b)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, 255)
    
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end
