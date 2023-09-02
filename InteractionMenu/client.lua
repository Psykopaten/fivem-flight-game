local _menuPool = NativeUI.CreatePool()
local mainMenu = NativeUI.CreateMenu("Flight Game", GetPlayerName(PlayerId()))
_menuPool:Add(mainMenu)

-- Planes
-- { Configuration } --
local spawnplane = 'Spawn Plane'
local spawnCooldown = 10000 -- 10 seconds


local menuPool = NativeUI.CreatePool()

local submain = menuPool:AddSubMenu(mainMenu, 'Plane spawner', "", 1420, 0)
local NorwegianPlaneMenu = menuPool:AddSubMenu(submain, 'Norwegian', "", 1420, 0)
local ScandinavianPlaneMenu = menuPool:AddSubMenu(submain, 'Scandinavian', "", 1420, 0)

local NoPlaneMenus = {}
NoPlaneMenus.shamal = NativeUI.CreateItem('Shamal', spawnplane)
NoPlaneMenus.so13 = NativeUI.CreateItem('2014 Charger', spawnplane)

NorwegianPlaneMenu:AddItem(NoPlaneMenus.shamal)
NorwegianPlaneMenu:AddItem(NoPlaneMenus.so13)

NorwegianPlaneMenu.OnItemSelect = function(sender, item, index)
    if item == NoPlaneMenus.shamal then
        deleteVeh()
        spawnVehicle('shamal', 'Shamal')
    elseif item == NoPlaneMenus.so13 then
        deleteVeh()
        spawnVehicle('so13', '2014 Charger')
    end
end

local SASPlaneMenus = {}
SASPlaneMenus.a343 = NativeUI.CreateItem('Airbus A340-300', spawnplane)

ScandinavianPlaneMenu:AddItem(SASPlaneMenus.a343)

ScandinavianPlaneMenu.OnItemSelect = function(sender, item, index)
    if item == SASPlaneMenus.a343 then
        deleteVeh()
        spawnVehicle('Airbus A340-300', 'a343')
    end
end

-- DON'T EDIT BECAUSE idk just don't please

function deleteVeh()
    local ped = GetPlayerPed(-1)
    if (DoesEntityExist(ped) and not IsEntityDead(ped)) then 
        local pos = GetEntityCoords(ped)

		if (IsPedSittingInAnyVehicle(ped)) then 
			local handle = GetVehiclePedIsIn(ped, false)
			NetworkRequestControlOfEntity(handle)
			SetEntityHealth(handle, 100)
			SetEntityAsMissionEntity(handle, true, true)
			SetEntityAsNoLongerNeeded(handle)
			DeleteEntity(handle)
            ShowInfo("Your plane was replaced")
        end
    end
end

function ShowInfo(message)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(0,1)
end

local lastSpawnTime = 0

function spawnVehicle(vehicle, name)
    local currentTime = GetGameTimer()

    if currentTime - lastSpawnTime >= spawnCooldown then
        local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 8.0, 0.5))
        local heading = GetEntityHeading(PlayerPedId())
        local colorwhite = "~w~"
        local coloryellow = "~y~"
        local colorred = "~r~"
        local colorblue = "~b~"
        local ped = GetPlayerPed(-1)

        if DoesEntityExist(ped) then
            local vehiclehash = GetHashKey(vehicle)
            RequestModel(vehiclehash)

            Citizen.CreateThread(function()
                local waiting = 0
                while not HasModelLoaded(vehiclehash) do
                    waiting = waiting + 100
                    Citizen.Wait(100)
                    if waiting > 5000 then
                        ShowInfo(colorred .. "Could not load model in time. Crash was prevented.")
                        break
                    end
                end

                local spawnedVeh = CreateVehicle(vehiclehash, x, y, z, heading, 1, 0)
                SetPedIntoVehicle(PlayerPedId(), spawnedVeh, -1)
                SetVehicleDirtLevel(spawnedVeh, 0.0)
                SetVehicleEngineOn(spawnedVeh, false, true)
            end)

            ShowInfo("You spawned a " .. colorblue .. name .. ".")
            lastSpawnTime = currentTime
            Wait(1000)
            return true
        end

        ShowInfo("All parking spots are currently full.")
        return false
    else
        ShowInfo("You need to wait before you can spawn another plane.")
    end
end

function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
 end


function HelpText(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 1, 1, -1)
end

-- Cars

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function AddMenuDeleteVehicle(menu)
    local deleteItem = NativeUI.CreateItem("Delete Vehicle", "Deletes the closest vehicle to you right now")
    menu:AddItem(deleteItem)

    menu.OnItemSelect = function(sender, item, index)
        if item == deleteItem then
            DeleteClosestVehicle()
            ShowNotification("Closest vehicle has been deleted.")
        end
    end
end

function DeleteClosestVehicle()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    local vehicle = GetClosestVehicle(playerCoords.x, playerCoords.y, playerCoords.z, 5.0, 0, 70)
    
    if DoesEntityExist(vehicle) and not IsPedInAnyVehicle(playerPed, true) then
        DeleteEntity(vehicle)
    end
end

function AddMenuHealSelf(menu) 
    local click = NativeUI.CreateItem("Heal yourself", "Gain full health.")
    menu:AddItem(click)
    menu.OnItemSelect = function(sender, item, index)
        if item == click then
            SetEntityHealth(PlayerPedId(), 200)
            ShowNotification("You have been successfully healed!")
        end
    end
end

local lastRepairTime = 0
local repairCooldown = 5000

function AddMenuRepairPlane(menu)
    local click = NativeUI.CreateItem("Repair plane", "Repair current plane you are sitting in.")
    menu:AddItem(click)
    
    menu.OnItemSelect = function(sender, item, index)
        if item == click then
            local currentTime = GetGameTimer()
            
            if currentTime - lastRepairTime >= repairCooldown then
                local car = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                SetVehicleFixed(car)
                ShowNotification("Your vehicle was fixed!")
                
                lastRepairTime = currentTime
            else
                local remainingCooldown = (lastRepairTime + repairCooldown - currentTime) / 1000
                ShowNotification("You need to wait " .. math.ceil(remainingCooldown) .. " seconds before repairing again.")
            end
        end
    end
end

AddMenuDeleteVehicle(mainMenu)
AddMenuHealSelf(mainMenu)
AddMenuRepairPlane(mainMenu)
_menuPool:RefreshIndex()
menuPool:RefreshIndex()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _menuPool:ProcessMenus()
        menuPool:ProcessMenus() -- Process the submenu pool
        
        if IsControlJustPressed(1, 288) then
            mainMenu:Visible(not mainMenu:Visible())
        end
    end
end)