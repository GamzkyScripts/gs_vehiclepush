local closestVehicle, closestDistance, closestCoords

CreateThread(function()
    while true do
        Wait(250)

        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        local isInVehicle = IsPedInAnyVehicle(ped, false)

        if not isInVehicle then
            closestVehicle, closestCoords = lib.getClosestVehicle(pedCoords, 10.0)
            closestDistance = closestCoords and #(pedCoords - closestCoords) or 0
        else
            closestVehicle, closestDistance, closestCoords = nil, 0, nil
        end
    end
end)

CreateThread(function()
    while true do
        Wait(0)

        local ped = PlayerPedId()
        if not IsPedInAnyVehicle(ped, true) then
            local pedCoords = GetEntityCoords(ped, true)

            if closestVehicle and (closestDistance < 10.0) and IsVehiclePushable(closestVehicle) then
                local dimension = GetModelDimensions(GetEntityModel(closestVehicle))

                local frontCoords = GetOffsetFromEntityInWorldCoords(closestVehicle, 0.0, dimension.y, 0.0)
                local backCoords = GetOffsetFromEntityInWorldCoords(closestVehicle, 0.0, dimension.y * -1, 0.0)

                local distanceFront = #(pedCoords - frontCoords)
                local distanceBack = #(pedCoords - backCoords)

                local textCoords
                if (distanceFront > distanceBack) then
                    textCoords = GetOffsetFromEntityInWorldCoords(closestVehicle, 0.0, dimension.y * -1, 0.5)
                else
                    textCoords = GetOffsetFromEntityInWorldCoords(closestVehicle, 0.0, dimension.y, 0.5)
                end

                if (distanceFront < 4.0) or (distanceBack < 4.0) then
                    local text = Config.pushLabel
                    if (distanceFront < 1.2) or (distanceBack < 1.2) then
                        text = ('[~b~%s + %s~w~] %s'):format(Config.pushKeyPrimary.label, Config.pushKeySecondary.label, Config.pushLabel)
                        if IsControlPressed(0, Config.pushKeyPrimary.index) and IsControlPressed(0, Config.pushKeySecondary.index) then
                            if NetworkHasControlOfEntity(closestVehicle) then
                                local isVehicleInFront = false
                                if distanceBack < distanceFront then
                                    AttachEntityToEntity(
                                        ped, closestVehicle, 0, 0.0, dimension.y * -1 + 0.1, dimension.z + 1.0, 0.0, 0.0, 180.0, 0.0, false, false, true, false, true
                                    )
                                    isVehicleInFront = true
                                else
                                    AttachEntityToEntity(
                                        ped, closestVehicle, 0, 0.0, dimension.y - 0.3, dimension.z + 1.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, true
                                    )
                                end

                                lib.requestAnimDict(Config.animation.dict)
                                TaskPlayAnim(
                                    ped, Config.animation.dict, Config.animation.anim, 2.0, -8.0, -1, 35, 0, 0, 0, 0
                                )

                                Wait(200)

                                while true do
                                    Wait(0)

                                    for i = 1, #Config.disabledControls do
                                        DisableControlAction(0, Config.disabledControls[i], true)
                                    end

                                    if IsControlJustPressed(0, 34) then -- A
                                        local wheelAngle = GetVehicleWheelSteeringAngle(closestVehicle)
                                        if (wheelAngle < -0.1) then
                                            SetVehicleSteeringAngle(closestVehicle, 0.0)
                                        else
                                            SetVehicleSteeringAngle(closestVehicle, 30.0)
                                        end
                                    end

                                    if IsControlJustPressed(0, 35) then -- D
                                        local wheelAngle = GetVehicleWheelSteeringAngle(closestVehicle)
                                        if (wheelAngle > 0.1) then
                                            SetVehicleSteeringAngle(closestVehicle, 0.0)
                                        else
                                            SetVehicleSteeringAngle(closestVehicle, -30.0)
                                        end
                                    end

                                    if isVehicleInFront then
                                        SetVehicleForwardSpeed(closestVehicle, -1.0)
                                    else
                                        SetVehicleForwardSpeed(closestVehicle, 1.0)
                                    end

                                    -- If the player is not pressing the button anymore, stop pushing the vehicle
                                    if not IsControlPressed(0, Config.pushKeySecondary.index) or not IsEntityAttachedToEntity(ped, closestVehicle) then
                                        SetVehicleForwardSpeed(closestVehicle, 0.0)
                                        DetachEntity(ped, false, false)
                                        StopAnimTask(ped, Config.animation.dict, Config.animation.anim, 2.0)
                                        break
                                    end
                                end
                            else
                                Notify('~r~Enter the vehicle first to gain control of the vehicle.')
                            end
                        end
                    end

                    DrawText3D(textCoords, text)
                else
                    Wait(250)
                end
            else
                Wait(1000)
            end
        else
            Wait(500)
        end
    end
end)

function IsVehiclePushable(vehicle)
    if not IsVehicleSeatFree(closestVehicle, -1) then
        return false
    end

    if (GetVehicleEngineHealth(vehicle) > Config.engineHealth) then
        return false
    end

    local class = GetVehicleClass(vehicle)
    if Config.disabledClasses[class] then
        return false
    end

    return true
end

function Notify(message)
    SetNotificationTextEntry('STRING')
    AddTextComponentSubstringPlayerName(message)
    DrawNotification(false, true)
end

function DrawText3D(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    if onScreen then
        SetTextScale(0.3, 0.3)
        SetTextFont(4)
        SetTextProportional(true)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry('STRING')
        SetTextCentre(true)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 370
        DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
    end
end
