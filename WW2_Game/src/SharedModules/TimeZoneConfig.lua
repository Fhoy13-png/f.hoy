-- TimeZoneConfig.lua
-- Time zone configuration and UTC offsets

local TimeZoneConfig = {}

-- Time zones mapped by name with UTC offsets (in hours)
TimeZoneConfig.TimeZones = {
    -- North America
    PST = { name = "Pacific Standard Time", offset = -8, display = "PST (UTC-8)" },
    MST = { name = "Mountain Standard Time", offset = -7, display = "MST (UTC-7)" },
    CST = { name = "Central Standard Time", offset = -6, display = "CST (UTC-6)" },
    EST = { name = "Eastern Standard Time", offset = -5, display = "EST (UTC-5)" },
    
    -- Europe
    GMT = { name = "Greenwich Mean Time", offset = 0, display = "GMT (UTC+0)" },
    CET = { name = "Central European Time", offset = 1, display = "CET (UTC+1)" },
    EET = { name = "Eastern European Time", offset = 2, display = "EET (UTC+2)" },
    
    -- Asia
    IST = { name = "India Standard Time", offset = 5.5, display = "IST (UTC+5:30)" },
    JST = { name = "Japan Standard Time", offset = 9, display = "JST (UTC+9)" },
    AEST = { name = "Australian Eastern Standard Time", offset = 10, display = "AEST (UTC+10)" },
    
    -- Other
    UTC = { name = "Coordinated Universal Time", offset = 0, display = "UTC (UTC+0)" },
}

-- Default clocks to display
TimeZoneConfig.DefaultClocks = { "EST", "GMT", "JST", "PST" }

-- Clock display settings
TimeZoneConfig.ClockSettings = {
    UpdateInterval = 0.1,  -- Update every 0.1 seconds
    Format24Hour = true,   -- Use 24-hour format
    ShowSeconds = true,    -- Display seconds
    ShowMilliseconds = false  -- Display milliseconds
}

return TimeZoneConfig
