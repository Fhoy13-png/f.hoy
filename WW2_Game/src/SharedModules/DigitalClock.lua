-- DigitalClock.lua
-- Digital clock module for displaying time and converting between time zones

local DigitalClock = {}

-- Get current system time
function DigitalClock:GetCurrentTime()
    return os.time()
end

-- Get time components (hour, minute, second, millisecond)
function DigitalClock:GetTimeComponents(unixTimestamp)
    local date = os.date("*t", unixTimestamp)
    local milliseconds = math.floor((unixTimestamp % 1) * 1000)
    
    return {
        year = date.year,
        month = date.month,
        day = date.day,
        hour = date.hour,
        minute = date.min,
        second = date.sec,
        milliseconds = milliseconds,
        wday = date.wday,  -- Day of week (1=Sunday, 7=Saturday)
        yday = date.yday   -- Day of year
    }
end

-- Convert time to a specific timezone
function DigitalClock:ConvertToTimeZone(unixTimestamp, utcOffset)
    local offsetSeconds = utcOffset * 3600  -- Convert hours to seconds
    local adjustedTime = unixTimestamp + offsetSeconds
    
    return self:GetTimeComponents(adjustedTime)
end

-- Format time components into a string
function DigitalClock:FormatTime(timeComponents, format24Hour, showSeconds, showMilliseconds)
    local hour = timeComponents.hour
    local minute = timeComponents.minute
    local second = timeComponents.second
    local milliseconds = timeComponents.milliseconds
    
    -- Convert to 12-hour format if needed
    local ampm = ""
    if not format24Hour then
        ampm = hour >= 12 and " PM" or " AM"
        if hour > 12 then
            hour = hour - 12
        elseif hour == 0 then
            hour = 12
        end
    end
    
    -- Build time string
    local timeStr = string.format("%02d:%02d", hour, minute)
    
    if showSeconds then
        timeStr = timeStr .. string.format(":%02d", second)
    end
    
    if showMilliseconds then
        timeStr = timeStr .. string.format(".%03d", milliseconds)
    end
    
    timeStr = timeStr .. ampm
    
    return timeStr
end

-- Get formatted time for a specific timezone
function DigitalClock:GetFormattedTimeInZone(timezoneName, utcOffset, format24Hour, showSeconds, showMilliseconds)
    local currentTime = self:GetCurrentTime()
    local timeComponents = self:ConvertToTimeZone(currentTime, utcOffset)
    local formattedTime = self:FormatTime(timeComponents, format24Hour, showSeconds, showMilliseconds)
    
    return formattedTime, timeComponents
end

-- Get date string
function DigitalClock:GetFormattedDate(timeComponents)
    local dayNames = { "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" }
    local monthNames = { "January", "February", "March", "April", "May", "June",
                        "July", "August", "September", "October", "November", "December" }
    
    local dayName = dayNames[timeComponents.wday]
    local monthName = monthNames[timeComponents.month]
    
    return string.format("%s, %s %d, %d", dayName, monthName, timeComponents.day, timeComponents.year)
end

-- Get time until next event (e.g., next hour, next day)
function DigitalClock:TimeUntilEvent(unixTimestamp, eventType)
    local timeComponents = self:GetTimeComponents(unixTimestamp)
    local secondsUntil = 0
    
    if eventType == "nextHour" then
        secondsUntil = (3600 - (timeComponents.minute * 60 + timeComponents.second))
    elseif eventType == "nextDay" then
        secondsUntil = ((23 - timeComponents.hour) * 3600 + (59 - timeComponents.minute) * 60 + (60 - timeComponents.second))
    elseif eventType == "nextMinute" then
        secondsUntil = (60 - timeComponents.second)
    end
    
    return secondsUntil
end

return DigitalClock
