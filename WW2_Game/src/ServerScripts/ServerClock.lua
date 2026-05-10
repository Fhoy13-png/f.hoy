-- ServerClock.lua
-- Server-side script to synchronize time across all clients

local TimeZoneConfig = require(game:GetService("ReplicatedStorage"):WaitForChild("TimeZoneConfig"))
local DigitalClock = require(game:GetService("ReplicatedStorage"):WaitForChild("DigitalClock"))

local serverClock = {}
serverClock.startTime = tick()
serverClock.elapsedTime = 0

-- Get synchronized server time
function serverClock:GetSyncedTime()
    self.elapsedTime = tick() - self.startTime
    return os.time() + self.elapsedTime
end

-- Print server time info periodically (for testing)
while true do
    local currentTime = serverClock:GetSyncedTime()
    local timeComponents = DigitalClock:GetTimeComponents(currentTime)
    
    print("[Server Clock] Current UTC Time: " .. DigitalClock:FormatTime(timeComponents, true, true, false))
    
    -- Log time in different zones
    for timezoneName, tzData in pairs(TimeZoneConfig.TimeZones) do
        if table.find(TimeZoneConfig.DefaultClocks, timezoneName) then
            local tzTimeComponents = DigitalClock:ConvertToTimeZone(currentTime, tzData.offset)
            local formattedTime = DigitalClock:FormatTime(tzTimeComponents, true, true, false)
            print(string.format("  [%s] %s", tzData.display, formattedTime))
        end
    end
    
    wait(5)  -- Update server logs every 5 seconds
end
