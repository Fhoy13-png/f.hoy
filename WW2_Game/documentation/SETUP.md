# WW2 Game Setup Guide

## Initial Setup Steps

### 1. Roblox Studio Setup
- Open Roblox Studio
- Create a new game place
- Enable **Team Create** if working with others

### 2. Game Structure
Create the following in ServerScriptService:
```
ServerScriptService/
├── TeamConfig (ModuleScript)
├── GameManager (ModuleScript)
├── PlayerManager (Script)
└── WeaponManager (Script) [To be added]
```

### 3. Map Setup
Create spawn locations in Workspace:
- **AlliesSpawn**: A SpawnLocation for Allies team
- **AxisSpawn**: A SpawnLocation for Axis team
- Add terrain and buildings for WW2 battlefield

### 4. Team Configuration
Teams are created automatically when GameManager initializes.
Customize in `TeamConfig.lua`:
- Team colors
- Player limits
- Spawn locations
- Game duration

### 5. Testing
1. Run the game in Studio
2. Test with multiple players (use Test > Run or Alt+P)
3. Verify team assignment and spawning

## Game Modes (To Implement)

### Team Deathmatch
- Highest kills wins
- Time limit: 10 minutes
- Respawn on death

### Capture the Flag
- Flag locations at each spawn
- Capture enemy flag to home base
- Teamwork required

### Territory Control
- Numbered zones on map
- Control zones to earn points
- Hold zones for victory

## Weapon System (To Implement)

Each team will have access to:
- **Primary Weapons**: Rifles and SMGs
- **Secondary Weapons**: Pistols
- **Melee Weapons**: Knives
- **Throwables**: Grenades, Smoke

## Database Integration (To Implement)

Use DataStore to save:
- Player stats (kills, deaths, wins)
- Progression levels
- Unlocked cosmetics
- Badges and achievements

