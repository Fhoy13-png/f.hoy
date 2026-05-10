-- PlayerManager.lua
-- Server script to manage player joining, spawning, and team assignment

local TeamConfig = require(game:GetService("ServerScriptService"):WaitForChild("TeamConfig"))
local GameManager = require(game:GetService("ServerScriptService"):WaitForChild("GameManager"))

-- Initialize the game
GameManager:Initialize()

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- Handle player joining
Players.PlayerAdded:Connect(function(player)
    print("[PlayerManager] " .. player.Name .. " joined the game")
    
    -- Assign to team
    GameManager:AssignPlayerToTeam(player)
    
    -- Handle character spawning
    player.CharacterAdded:Connect(function(character)
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
        local teamName = player.Team.Name
        
        -- Find spawn location
        local spawnLocationName = (teamName == "Allies") and "AlliesSpawn" or "AxisSpawn"
        local spawnLocation = Workspace:FindFirstChild(spawnLocationName)
        
        if spawnLocation then
            -- Teleport to spawn
            humanoidRootPart.CFrame = spawnLocation.CFrame + Vector3.new(0, 3, 0)
            print("[PlayerManager] " .. player.Name .. " spawned at " .. spawnLocationName)
        else
            print("[PlayerManager] WARNING: " .. spawnLocationName .. " not found in Workspace!")
            -- Default spawn at origin
            humanoidRootPart.CFrame = CFrame.new(0, 10, 0)
        end
        
        -- Set team color
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.Health = 100
    end)
    
    -- Handle player leaving
    player.CharacterAdded:Connect(function()
        -- Nothing special needed, just tracking
    end)
end)

-- Handle player leaving
Players.PlayerRemoving:Connect(function(player)
    print("[PlayerManager] " .. player.Name .. " left the game")
    GameManager.playerTeams[player] = nil
end)

-- Game loop
while true do
    wait(1)  -- Update every 1 second
    
    if GameManager.gameState == "LOBBY" then
        local playerCount = #Players:GetPlayers()
        if playerCount >= TeamConfig.GameSettings.MinPlayersToStart then
            print("[PlayerManager] Enough players to start!")
            GameManager:StartGame()
        end
    end
    
    if GameManager.gameState == "PLAYING" then
        GameManager:Update(1)
    end
end
