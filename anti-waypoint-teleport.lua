-- we can do it? why not lol

local IsTeleportChecking = false

function TeleportChecker(coord)
    CreateThread(function()
        IsTeleportChecking = true
        local blip = GetFirstBlipInfoId(8)
        local blipCoord = GetBlipInfoIdCoord(blip)
        while GetBlipInfoIdCoord(blip) == coord do
            Wait(20)
        end
        local playerCoord = GetEntityCoords(PlayerPedId())
        local afterDist = GetDistanceBetweenCoords(blipCoord.x, blipCoord.y, blipCoord.z, playerCoord.x, playerCoord.y,
            playerCoord.z, false)
        if afterDist < 1 and GetEntitySpeed(PlayerPedId()) < 1 then
            TriggerServerEvent('dev-anticheat:server:BanMe', 'teleport')
        end
        IsTeleportChecking = false
    end)
end

CreateThread(function()
    while true do
        if not ControlPlayer then return end -- this variable is inside anti-noclip.lua
        local blip = GetFirstBlipInfoId(8)
        if blip ~= 0 then
            local blipCoord = GetBlipInfoIdCoord(blip)
            if not IsTeleportChecking then TeleportChecker(blipCoord) end
        end
        Wait(500)
    end
end)

-- here we check if player has waypoint on map. so if his have waypoint we check if the player coords has been changed after 20 ms to the waypoint coords.
-- so the cheater can't teleport to the waypoint anymore and is detected be this code. if his try to move like 2 meter or 4 meter then teleport
-- it will check again because the waypoint is active.
