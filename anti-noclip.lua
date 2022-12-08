-- so we have W, S, D, A key for player movement and it also for noclip movement. we can catch him be this code. lol
-- don't forget to change trigger server side to ban player.

local ControlPlayer = True -- added check to change this variable to False if player is admin.
local IsHoldingControlKeys = false
local IsNoClipChecking = false
function IsMovingControlPressed()
    return (
        IsControlJustPressed(0, 32) or
            IsDisabledControlJustPressed(0, 32) or
            IsControlJustPressed(0, 33) or
            IsDisabledControlJustPressed(0, 33) or
            IsControlJustPressed(0, 34) or
            IsDisabledControlJustPressed(0, 34) or
            IsControlJustPressed(0, 35) or
            IsDisabledControlJustPressed(0, 35)
        )
end

function IsMovingControlRelased()
    return (
        IsControlJustReleased(0, 32) or
            IsDisabledControlJustReleased(0, 32) or
            IsControlJustReleased(0, 33) or
            IsDisabledControlJustReleased(0, 33) or
            IsControlJustReleased(0, 34) or
            IsDisabledControlJustReleased(0, 34) or
            IsControlJustReleased(0, 35) or
            IsDisabledControlJustReleased(0, 35)
        )
end


function IsPlayerActiveNoclip()
    IsNoClipChecking = true
    CreateThread(function()
        while IsHoldingControlKeys do
            local ped = PlayerPedId()
            if IsPedStill(ped) and not IsPedInAnyVehicle(ped, false) and not IsPedRagdoll(ped) then
                local coords = GetEntityCoords(ped)
                Wait(1000)
                local newCoord = GetEntityCoords(ped)
                local dist = #(coords - newCoord)
                if dist > 10 and GetEntitySpeed(ped) == 0.0 then
                    TriggerServerEvent('dev-anticheat:server:BanMe', 'noclip')
                    break
                end
            elseif IsPedInAnyVehicle(ped, false) and not IsPedRagdoll(ped) then
                local vehicle = GetVehiclePedIsIn(ped, false)
                if IsVehicleStopped(vehicle) then
                    local coords = GetEntityCoords(ped)
                    Wait(1000)
                    local newCoord = GetEntityCoords(ped)
                    local dist = #(coords - newCoord)
                    if dist > 10 and GetEntitySpeed(vehicle) == 0.0 then
                        TriggerServerEvent('dev-anticheat:server:BanMe', 'noclip')
                    end
                    break
                end
            end
            Wait(20)
        end
        IsNoClipChecking = false
    end)
end


CreateThread(function()
    while true do
        if not ControlPlayer then return end
        if IsMovingControlPressed() then
            IsHoldingControlKeys = true
            if not IsNoClipChecking then IsPlayerActiveNoclip() end
        elseif IsMovingControlRelased() then
            IsHoldingControlKeys = false
        end
        Wait(0)
    end
end)

-- checker: if his turn on the noclip, IsPedStill is always return true
-- so when player holding movemnt keys the player should change him coords and IsPedStill should be false. so when player coords changed and IsPedStill is true
-- that's mean the player enable noclip!!!
