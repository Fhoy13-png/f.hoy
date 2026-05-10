# Digital Clock System - Setup Guide

## Overview

The Digital Clock system displays the current time across multiple time zones with real-time updates. Perfect for a global game where players are in different regions.

## Features

✅ **Multi-Timezone Support** - Display times for multiple zones simultaneously
✅ **Real-Time Updates** - Clock updates 10 times per second
✅ **Customizable Format** - Toggle 12/24-hour format, seconds, milliseconds
✅ **Date Display** - Shows full date with day of week
✅ **Server Sync** - All clients synchronized to server time
✅ **Accurate Conversion** - Proper UTC offset handling including half-hour zones (IST)

## Installation Steps

### 1. Move Files to ReplicatedStorage

Copy these modules to **ReplicatedStorage**:
- `TimeZoneConfig.lua`
- `DigitalClock.lua`

They must be in ReplicatedStorage so both server and client can access them.

### 2. Add Server Script

Place `ServerClock.lua` in **ServerScriptService**:
- This synchronizes time across all clients
- Logs current times to server console

### 3. Add Client Script

Place `ClockDisplay.lua` in **StarterPlayer > StarterCharacterScripts** or **StarterPlayer > StarterPlayerScripts**:
- Creates GUI for clock displays
- Updates clock every frame

### 4. Configure Time Zones

Edit `TimeZoneConfig.lua` to customize:

```lua
TimeZoneConfig.DefaultClocks = { "EST", "GMT", "JST", "PST" }
```

Change this to display different zones. Available zones:
- **North America**: PST, MST, CST, EST
- **Europe**: GMT, CET, EET
- **Asia**: IST, JST, AEST
- **Universal**: UTC

### 5. Configure Display Settings

```lua
TimeZoneConfig.ClockSettings = {
    UpdateInterval = 0.1,      -- Update every 0.1 seconds
    Format24Hour = true,       -- Use 24-hour format (false = 12-hour)
    ShowSeconds = true,        -- Display seconds
    ShowMilliseconds = false   -- Display milliseconds
}
```

## Usage Examples

### Get Current Time in Specific Zone

```lua
local DigitalClock = require(game.ReplicatedStorage.DigitalClock)
local TimeZoneConfig = require(game.ReplicatedStorage.TimeZoneConfig)

local jstData = TimeZoneConfig.TimeZones.JST
local jstTime, components = DigitalClock:GetFormattedTimeInZone(
    "JST",
    jstData.offset,
    true,  -- 24-hour format
    true,  -- show seconds
    false  -- don't show milliseconds
)

print(jstTime)  -- Output: "18:30:45"
```

### Add Custom Time Zone

Edit `TimeZoneConfig.lua`:

```lua
TimeZoneConfig.TimeZones.CUSTOM = {
    name = "My Custom Zone",
    offset = 5.5,  -- UTC+5:30
    display = "CUSTOM (UTC+5:30)"
}
```

Then add to DefaultClocks:

```lua
TimeZoneConfig.DefaultClocks = { "EST", "GMT", "CUSTOM" }
```

## Clock Display Layout

By default, clocks are displayed in the top-left corner of the screen, stacked horizontally:

```
┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│ EST (UTC-5) │ │ GMT (UTC+0) │ │ JST (UTC+9) │
│   14:30:45  │ │   19:30:45  │ │   04:30:45  │
├─────────────┤ ├─────────────┤ ├─────────────┤
│ Monday,     │ │ Monday,     │ │ Tuesday,    │
│ May 10, 2026│ │ May 10, 2026│ │ May 11, 2026│
└─────────────┘ └─────────────┘ └─────────────┘
```

## Customizing Appearance

Edit `ClockDisplay.lua` to change:

```lua
-- Position (modify xPosition parameter)
screenGui.Position = UDim2.new(0, 20, 0, 20)  -- X=20, Y=20

-- Size
background.Size = UDim2.new(0, 250, 0, 100)  -- Width=250, Height=100

-- Colors
background.BackgroundColor3 = Color3.fromRGB(40, 40, 40)      -- Dark gray background
timeDisplay.TextColor3 = Color3.fromRGB(0, 255, 100)          -- Bright green text
label.TextColor3 = Color3.fromRGB(100, 200, 255)             -- Light blue label

-- Font sizes
label.TextSize = 14
timeDisplay.TextSize = 32
```

## Performance Considerations

- Clock updates 10 times per second by default (adjustable)
- Each timezone display uses minimal CPU
- Recommended max 8-10 simultaneous clocks
- Can display up to 20+ zones without performance issues

## Troubleshooting

### Clocks Not Showing
1. Verify modules are in **ReplicatedStorage**
2. Check that Client script is in correct location
3. Look for errors in Output console

### Time Looks Wrong
1. Check server time with `/time` command
2. Verify UTC offsets in TimeZoneConfig
3. Ensure Format24Hour setting is correct

### Clocks Not Updating
1. Check UpdateInterval setting (set to 0.1 or less)
2. Verify wait() time in update loop matches interval
3. Look for script errors in Output

## Advanced Usage

### Sync with Game Events

```lua
local timeUntilNextHour = DigitalClock:TimeUntilEvent(os.time(), "nextHour")
print("Next round in " .. timeUntilNextHour .. " seconds")
```

### Schedule Events by Time Zone

```lua
local estTime, components = DigitalClock:GetFormattedTimeInZone("EST", -5, true, true, false)

if components.hour == 20 and components.minute == 0 then
    -- Start event at 8 PM EST
    print("Event starting!")
end
```

## API Reference

### DigitalClock Module

```lua
DigitalClock:GetCurrentTime()
-- Returns Unix timestamp

DigitalClock:GetTimeComponents(unixTimestamp)
-- Returns table with year, month, day, hour, minute, second, milliseconds, wday, yday

DigitalClock:ConvertToTimeZone(unixTimestamp, utcOffset)
-- Returns time components adjusted for timezone

DigitalClock:FormatTime(timeComponents, format24Hour, showSeconds, showMilliseconds)
-- Returns formatted time string like "14:30:45" or "2:30:45 PM"

DigitalClock:GetFormattedTimeInZone(timezoneName, utcOffset, format24Hour, showSeconds, showMilliseconds)
-- Returns formatted time and components for a specific timezone

DigitalClock:GetFormattedDate(timeComponents)
-- Returns formatted date like "Monday, May 10, 2026"

DigitalClock:TimeUntilEvent(unixTimestamp, eventType)
-- Returns seconds until next event ("nextHour", "nextDay", "nextMinute")
```
