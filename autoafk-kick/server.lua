-- Define the threshold for considering a player as AFK (in seconds) 
-- Feel free to edit the line below this, so you can edit the threshold to your liking.
local AFK_THRESHOLD = 600  -- 10 minutes


--Please do NOT edit anything after this
local lastInputTime = {}

local function UpdateLastInputTime(player)
    lastInputTime[player] = os.time()
end

local function IsPlayerAFK(player)
    local currentTime = os.time()
    local lastInput = lastInputTime[player] or 0
    local elapsedTime = currentTime - lastInput
    return elapsedTime >= AFK_THRESHOLD
end

AddEventHandler('playerDropped', function()
    local playerId = source
    lastInputTime[playerId] = nil
end)

AddEventHandler('playerConnecting', function()
    local playerId = source
    UpdateLastInputTime(playerId)
end)

AddEventHandler('playerSpawned', function()
    local playerId = source
    UpdateLastInputTime(playerId)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)    
        for _, playerId in ipairs(GetPlayers()) do
            if IsPlayerAFK(playerId) then
                DropPlayer(playerId, "You were kicked for being AFK.")
            end
        end
    end
end)
