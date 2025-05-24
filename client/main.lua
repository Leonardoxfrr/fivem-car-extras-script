local isMenuOpen = false

-- ESX-Initialisierung für Legacy und Classic
local ESX = nil

if pcall(function() return exports['es_extended'] end) then
    ESX = exports['es_extended']:getSharedObject()
else
    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
            Citizen.Wait(10)
        end
    end)
end

-- Hilfsfunktion für ESX-Notifications (kompatibel mit allen Versionen)
local function ShowESXNotification(msg)
    if ESX and ESX.ShowNotification then
        ESX.ShowNotification(msg)
    else
        SetNotificationTextEntry('STRING')
        AddTextComponentString(msg)
        DrawNotification(false, false)
    end
end

function OpenExtrasMenu()
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    if vehicle == 0 or GetPedInVehicleSeat(vehicle, -1) ~= playerPed then
        ShowESXNotification('Du musst Fahrer eines Fahrzeugs sein!')
        return
    end

    local elements = {}
    for i = 0, 20 do
        if DoesExtraExist(vehicle, i) then
            local enabled = IsVehicleExtraTurnedOn(vehicle, i)
            table.insert(elements, {label = 'Extra '..i..' ['..(enabled and 'AN' or 'AUS')..']', value = i, enabled = enabled})
        end
    end

    if #elements == 0 then
        ShowESXNotification('Dieses Fahrzeug hat keine Extras!')
        return
    end

    menu = NativeUI.CreateMenu('Fahrzeug Extras', 'Extras auswählen')
    _menuPool = NativeUI.CreatePool()
    _menuPool:Add(menu)

    for _, extra in ipairs(elements) do
        local item = NativeUI.CreateItem(extra.label, '')
        item:RightLabel(extra.enabled and '✓' or '✗')
        menu:AddItem(item)
    end

    menu.OnItemSelect = function(sender, item, index)
        local extra = elements[index]
        local newState = not extra.enabled
        -- Speichere aktuellen Fahrzeugzustand
        local engineHealth = GetVehicleEngineHealth(vehicle)
        local bodyHealth = GetVehicleBodyHealth(vehicle)
        local petrolTankHealth = GetVehiclePetrolTankHealth(vehicle)
        local dirtLevel = GetVehicleDirtLevel(vehicle)
        local windows = {}
        for i=0,7 do windows[i]=IsVehicleWindowIntact(vehicle,i) end
        local doors = {}
        for i=0,5 do doors[i]=GetVehicleDoorAngleRatio(vehicle,i) end
        local tyres = {}
        for i=0,7 do tyres[i]=IsVehicleTyreBurst(vehicle,i,false) end

        SetVehicleExtra(vehicle, extra.value, newState and 0 or 1)
        ShowESXNotification('Extra '..extra.value..(newState and ' aktiviert' or ' deaktiviert'))
        -- Stelle Fahrzeugzustand wieder her
        SetVehicleEngineHealth(vehicle, engineHealth)
        SetVehicleBodyHealth(vehicle, bodyHealth)
        SetVehiclePetrolTankHealth(vehicle, petrolTankHealth)
        SetVehicleDirtLevel(vehicle, dirtLevel)
        for i=0,7 do if not windows[i] then SmashVehicleWindow(vehicle,i) end end
        for i=0,5 do if doors[i]>0 then SetVehicleDoorBroken(vehicle,i,true) end end
        for i=0,7 do if tyres[i] then SetVehicleTyreBurst(vehicle,i,true,1000.0) end end
        menu:Visible(false)
        isMenuOpen = false
    end

    menu:Visible(true)
    isMenuOpen = true

    Citizen.CreateThread(function()
        while isMenuOpen do
            Citizen.Wait(0)
            _menuPool:ProcessMenus()
            if not menu:Visible() then
                isMenuOpen = false
            end
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, Config.OpenKey) and not isMenuOpen then
            OpenExtrasMenu()
        end
    end
end)
