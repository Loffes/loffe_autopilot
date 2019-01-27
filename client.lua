ESX                           = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

end)

local autopilot = false

Citizen.CreateThread(function()
    while true do
        Wait(500)
        local Vehicle = GetVehiclePedIsUsing(PlayerPedId())
        if GetEntityModel(Vehicle) == -1848994066 then
            if GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId() then
                while not autopilot and GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId() do
                    Wait(5)
                    drawTxt('Autopilot: ~r~AV', 0.07, 0.32, 0.4)
                    drawTxt('Sätt på: /autopilot', 0.07, 0.36, 0.4)
                    drawTxt('Autopilot: ~r~AV', 0.07, 0.32, 0.4)
                    drawTxt('Sätt på: /autopilot', 0.07, 0.36, 0.4)
                    drawTxt('Autopilot: ~r~AV', 0.07, 0.32, 0.4)
                end
            end
        end
    end
end)

RegisterCommand('autopilot', function(source)
    local Vehicle = GetVehiclePedIsUsing(PlayerPedId())
    if GetEntityModel(Vehicle) == -1848994066 then
        if GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId() then
            autopilot = true
            local coords = GetBlipInfoIdCoord(GetFirstBlipInfoId(8))
            local speed = 55
            local timesRepeated = 0 
            Wait(50)
            TaskVehicleDriveToCoord(PlayerPedId(), Vehicle, coords, GetVehicleMaxSpeed(GetVehiclePedIsUsing(PlayerPedId())), 0, -1848994066, 263100, 10.0)
            SetDriveTaskDrivingStyle(PlayerPedId(), 263100)       
            SetPedKeepTask(PlayerPedId(), true)
            local hasArrived = false
            while not hasArrived do
                Wait(5)
                SetEntityMaxSpeed(Vehicle, speed/3.6)
                if GetPedInVehicleSeat(Vehicle, -1) == PlayerPedId() then
                    drawTxt('Autopilot: ~g~PÅ', 0.07, 0.24, 0.4)
                    drawTxt('Inställd på: ' .. speed .. 'KM/H', 0.07, 0.28, 0.4)
                    drawTxt('Öka farten: ↑', 0.07, 0.32, 0.4)
                    drawTxt('Sänk farten: ↓', 0.07, 0.36, 0.4)
                    drawTxt('Ta över: X', 0.07, 0.4, 0.4)
                    drawTxt('Fågelväg: ' .. math.ceil(GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, false)) .. 'M', 0.07, 0.44, 0.4)
                    if GetDistanceBetweenCoords(coords, GetEntityCoords(PlayerPedId()), false) <= 25.0 then
                        hasArrived = true
                        ClearPedTasks(PlayerPedId())
                        ClearPedSecondaryTask(PlayerPedId())
                        ESX.ShowNotification('Du är nu ~g~framme~w~!')
                    end
                    if IsControlJustPressed(0, 73) then
                        hasArrived = true
                        ESX.ShowNotification('Autopilot är nu ~r~av')
                        ClearPedTasks(PlayerPedId())
                        ClearPedSecondaryTask(PlayerPedId())
                    end
                    if IsControlJustPressed(0, 173) then
                        if speed >= 6 then
                            local Slower = speed-10
                            speed = Slower
                            SetEntityMaxSpeed(Vehicle, speed/3.6)
                        end
                    elseif IsControlJustPressed(0, 27) then
                        if speed <= 200 then
                            local Faster = speed+10
                            speed = Faster
                            SetEntityMaxSpeed(Vehicle, speed/3.6)
                        end
                    end
                else
                    hasArrived = true
                end
            end
            autopilot = false
            ClearPedTasks(PlayerPedId())
            ClearPedSecondaryTask(PlayerPedId())
            SetEntityMaxSpeed(Vehicle, 9999/3.6)
        else
            ESX.ShowNotification('Du kan ~r~inte~w~ använda autopilot som passagerare!')
        end
    else
        ESX.ShowNotification('Ditt fordon stödjer ~r~inte~w~ autopilot!')
    end
end, false)

function drawTxt(text, x, y, scale)
	SetTextFont(8)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(255, 255, 255, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
    DrawText(x, y)
    DrawRect(0.0, 0.36, 0.3, 0.25, 41, 11, 41, 68)
end