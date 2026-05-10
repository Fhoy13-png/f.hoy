-- ClockDisplay.lua
-- Client-side script to display digital clocks for multiple time zones

local TimeZoneConfig = require(game:GetService("ReplicatedStorage"):WaitForChild("TimeZoneConfig"))
local DigitalClock = require(game:GetService("ReplicatedStorage"):WaitForChild("DigitalClock"))

local clockFolder = Instance.new("Folder")
clockFolder.Name = "DigitalClocks"
clockFolder.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local clockDisplays = {}

-- Create a clock display for each timezone
local function CreateClockDisplay(timezoneName, xPosition)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = timezoneName .. "_Clock"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = clockFolder
    
    -- Background
    local background = Instance.new("Frame")
    background.Name = "Background"
    background.Size = UDim2.new(0, 250, 0, 100)
    background.Position = UDim2.new(xPosition, 0, 0, 20)
    background.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    background.BorderColor3 = Color3.fromRGB(100, 100, 100)
    background.BorderSizePixel = 2
    background.Parent = screenGui
    
    -- Timezone label
    local label = Instance.new("TextLabel")
    label.Name = "TimezoneLabel"
    label.Size = UDim2.new(1, 0, 0, 30)
    label.Position = UDim2.new(0, 0, 0, 5)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(100, 200, 255)
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.Text = TimeZoneConfig.TimeZones[timezoneName].display
    label.Parent = background
    
    -- Time display
    local timeDisplay = Instance.new("TextLabel")
    timeDisplay.Name = "TimeDisplay"
    timeDisplay.Size = UDim2.new(1, 0, 0, 50)
    timeDisplay.Position = UDim2.new(0, 0, 0, 30)
    timeDisplay.BackgroundTransparency = 1
    timeDisplay.TextColor3 = Color3.fromRGB(0, 255, 100)
    timeDisplay.TextSize = 32
    timeDisplay.Font = Enum.Font.GothamMono
    timeDisplay.Text = "00:00:00"
    timeDisplay.Parent = background
    
    -- Date display (optional, below the main display)
    local dateDisplay = Instance.new("TextLabel")
    dateDisplay.Name = "DateDisplay"
    dateDisplay.Size = UDim2.new(1, 0, 0, 20)
    dateDisplay.Position = UDim2.new(0, 0, 1, 0)
    dateDisplay.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    dateDisplay.BorderColor3 = Color3.fromRGB(100, 100, 100)
    dateDisplay.BorderSizePixel = 2
    dateDisplay.TextColor3 = Color3.fromRGB(150, 150, 150)
    dateDisplay.TextSize = 10
    dateDisplay.Font = Enum.Font.Gotham
    dateDisplay.Text = "Loading..."
    dateDisplay.Parent = screenGui
    
    clockDisplays[timezoneName] = {
        screenGui = screenGui,
        timeDisplay = timeDisplay,
        dateDisplay = dateDisplay,
        timezoneName = timezoneName
    }
end

-- Update clock displays
local function UpdateClocks()
    local xPos = 0
    
    for _, timezoneName in ipairs(TimeZoneConfig.DefaultClocks) do
        if not clockDisplays[timezoneName] then
            CreateClockDisplay(timezoneName, UDim2.new(xPos / 2560, 0))
        end
        
        local clockDisplay = clockDisplays[timezoneName]
        local timezoneData = TimeZoneConfig.TimeZones[timezoneName]
        
        -- Get formatted time
        local formattedTime, timeComponents = DigitalClock:GetFormattedTimeInZone(
            timezoneName,
            timezoneData.offset,
            TimeZoneConfig.ClockSettings.Format24Hour,
            TimeZoneConfig.ClockSettings.ShowSeconds,
            TimeZoneConfig.ClockSettings.ShowMilliseconds
        )
        
        clockDisplay.timeDisplay.Text = formattedTime
        
        -- Update date
        local formattedDate = DigitalClock:GetFormattedDate(timeComponents)
        clockDisplay.dateDisplay.Text = formattedDate
        
        xPos = xPos + 260
    end
end

-- Start update loop
while true do
    UpdateClocks()
    wait(TimeZoneConfig.ClockSettings.UpdateInterval)
end
