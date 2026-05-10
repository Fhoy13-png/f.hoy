-- TeamConfig.lua
-- Team configuration and constants

local TeamConfig = {}

-- Team Definitions
TeamConfig.Teams = {
    Allies = {
        Name = "Allies",
        Color = Color3.fromRGB(0, 100, 200),  -- Blue
        SpawnLocation = "AlliesSpawn",
        ID = 1
    },
    Axis = {
        Name = "Axis",
        Color = Color3.fromRGB(139, 0, 0),   -- Dark Red
        SpawnLocation = "AxisSpawn",
        ID = 2
    }
}

-- Game Settings
TeamConfig.GameSettings = {
    MaxPlayersPerTeam = 16,
    RespawnTime = 5,
    GameDuration = 600,  -- 10 minutes
    MinPlayersToStart = 2,
    TeamBalanceCheckInterval = 30
}

-- Loadout Configuration
TeamConfig.DefaultLoadout = {
    Primary = "M1Garand",  -- Allies default
    Secondary = "M1911",
    Melee = "Knife",
    Throwable = "Grenade"
}

TeamConfig.AxisLoadout = {
    Primary = "Kar98k",
    Secondary = "Luger",
    Melee = "Knife",
    Throwable = "Grenade"
}

return TeamConfig
