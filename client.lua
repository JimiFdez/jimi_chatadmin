local admins = {}

-- Agrega aquí los identificadores de los administradores (pueden ser steam:xxxx, discord:xxxx o license:xxxx)
admins = {
    "steam:123456789012345",
    "discord:987654321098765",
    "license:123456789012345"
}

RegisterCommand('chatadmin', function(source, args, rawCommand)
    local playerId = source
    local playerName = GetPlayerName(playerId)
    local playerIdentifier = GetPlayerIdentifier(playerId)

    -- Verifica si el jugador es un administrador
    if IsAdmin(playerIdentifier) then
        local message = table.concat(args, " ")  -- Obtiene el mensaje del comando
        TriggerEvent('chatMessage', playerId, "^1[ADMIN] " .. playerName, {255, 0, 0}, message)  -- Envía el mensaje solo al jugador que lo envía
        TriggerEvent('chatAdminMessage', "^1[ADMIN] " .. playerName, {255, 0, 0}, message)  -- Envía el mensaje a todos los administradores
    else
        TriggerClientEvent('chatMessage', playerId, "^1[ERROR] No tienes permisos para usar este comando.", {255, 0, 0})
    end
end, false)

function IsAdmin(identifier)
    for _, adminIdentifier in ipairs(admins) do
        if adminIdentifier == identifier then
            return true
        end
    end
    return false
end

RegisterServerEvent('chatAdminMessage')
AddEventHandler('chatAdminMessage', function(prefix, color, message)
    local players = GetPlayers()
    for _, player in ipairs(players) do
        local playerIdentifier = GetPlayerIdentifier(player)
        if IsAdmin(playerIdentifier) then
            TriggerClientEvent('chatMessage', player, prefix, color, message)
        end
    end
end)
