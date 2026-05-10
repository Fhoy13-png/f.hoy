-- GameManager.lua
-- Core game manager for WW2 battle system

local TeamConfig = require(script.Parent:WaitForChild("TeamConfig"))

local GameManager = {}
GameManager.gameState = "LOBBY"  -- LOBBY, STARTING, PLAYING, ENDED
GameManager.gameTime = 0
GameManager.teamScores = {
    Allies = 0,
    Axis = 0
}
GameManager.playerTeams = {}  -- Maps player to their team
GameManager.activePlayers = {}

-- Initialize the game
function GameManager:Initialize()
    print("[GameManager] Initializing WW2 Battle Game...")
    
    -- Create teams in game
    local alliesTeam = Instance.new("Team")
    alliesTeam.Name = "Allies"
    alliesTeam.TeamColor = BrickColor.new("Blue")
    alliesTeam.Parent = game:GetService("Teams")
    
    local axisTeam = Instance.new("Team")
    axisTeam.Name = "Axis"
    axisTeam.TeamColor = BrickColor.new("Maroon")
    axisTeam.Parent = game:GetService("Teams")
    
    print("[GameManager] Teams created: Allies and Axis")
end

-- Assign player to team with auto-balancing
function GameManager:AssignPlayerToTeam(player)
    local alliesCount = #game:GetService("Teams"):FindFirstChild("Allies"):GetPlayers()
    local axisCount = #game:GetService("Teams"):FindFirstChild("Axis"):GetPlayers()
    
    local assignedTeam
    if alliesCount <= axisCount then
        assignedTeam = game:GetService("Teams"):FindFirstChild("Allies")
        print("[GameManager] Player " .. player.Name .. " assigned to Allies")
    else
        assignedTeam = game:GetService("Teams"):FindFirstChild("Axis")
        print("[GameManager] Player " .. player.Name .. " assigned to Axis")
    end
    
    player.Team = assignedTeam
    self.playerTeams[player] = assignedTeam.Name
    return assignedTeam
end

-- Start the game
function GameManager:StartGame()
    if self.gameState == "PLAYING" then
        print("[GameManager] Game already in progress!")
        return false
    end
    
    local playerCount = #game:GetService("Players"):GetPlayers()
    if playerCount < TeamConfig.GameSettings.MinPlayersToStart then
        print("[GameManager] Not enough players to start. Need at least " .. TeamConfig.GameSettings.MinPlayersToStart)
        return false
    end
    
    self.gameState = "PLAYING"
    self.gameTime = TeamConfig.GameSettings.GameDuration
    print("[GameManager] Game started! Duration: " .. self.gameTime .. " seconds")
    return true
end

-- Update game state
function GameManager:Update(deltaTime)
    if self.gameState == "PLAYING" then
        self.gameTime = self.gameTime - deltaTime
        
        if self.gameTime <= 0 then
            self:EndGame()
        end
    end
end

-- End the game
function GameManager:EndGame()
    self.gameState = "ENDED"
    
    local allyScore = self.teamScores.Allies
    local axisScore = self.teamScores.Axis
    
    if allyScore > axisScore then
        print("[GameManager] GAME OVER! Allies Win! Score: " .. allyScore .. " - " .. axisScore)
    elseif axisScore > allyScore then
        print("[GameManager] GAME OVER! Axis Win! Score: " .. axisScore .. " - " .. allyScore)
    else
        print("[GameManager] GAME OVER! It's a TIE! Score: " .. allyScore .. " - " .. axisScore)
    end
    
    wait(5)  -- Show results for 5 seconds
    self:ResetGame()
end

-- Reset game to lobby
function GameManager:ResetGame()
    self.gameState = "LOBBY"
    self.gameTime = 0
    self.teamScores = { Allies = 0, Axis = 0 }
    self.playerTeams = {}
    self.activePlayers = {}
    
    print("[GameManager] Game reset to LOBBY")
end

-- Add kill to team score
function GameManager:AddKill(team, amount)
    amount = amount or 1
    if self.teamScores[team] then
        self.teamScores[team] = self.teamScores[team] + amount
        print("[GameManager] " .. team .. " score: " .. self.teamScores[team])
    end
end

-- Get current game status
function GameManager:GetGameStatus()
    return {
        state = self.gameState,
        timeRemaining = self.gameTime,
        alliesScore = self.teamScores.Allies,
        axisScore = self.teamScores.Axis,
        playerCount = #game:GetService("Players"):GetPlayers()
    }
end

return GameManager
