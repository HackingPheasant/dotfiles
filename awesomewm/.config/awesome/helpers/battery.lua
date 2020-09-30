-- Provides:
-- battery::status
--      status (String)
-- battery::charge
--      percentage (Integer)
-- battery::time
--      time (String)
-- battery::charger
--      plugged (Boolean)

local awful = require("awful")

local update_interval = 15

awful.widget.watch("acpi --battery", update_interval, function(widget, stdout, stderr, exitreason, exitcode)
    -- Known Potential Outputs:
    -- Battery 0: Charged, 100.0%
    -- Battery 0: Discharging, 53%, 02:30:53 remaining
    -- Battery 0: Charging, 90%, 00:21:16 until charged
    -- Battery 0: Charging, 53%, charging at zero rate - will never fully charge.
    -- Only first 3 types are handled at the moment
    for line in stdout:gmatch("[^\r\n]+") do 
        if line:gmatch(line, "Battery (%d+)") then
            if line:match("Charged") then
                status = "Charged";
                charge = 100;
                time = "";
            elseif line:match("Charging") then
                status = "Charging";
                charge = tonumber(line:match(" (%d*.%d+)%%"))
                time = line:match("(%d+:%d+):%d+");
            elseif line:match("Discharging") then
                status = "Discharging";
                charge = tonumber(line:match(" (%d*.%d+)%%"))
                time = line:match("(%d+:%d+):%d+");
            end
        end
    end
    
    -- Emit the values
    awesome.emit_signal("battery::status", status)
    awesome.emit_signal("battery::charge", charge)
    awesome.emit_signal("battery::time", time)
end)

awful.widget.watch("acpi --ac-adapter", update_interval, function(widget, stdout, stderr, exitreason, exitcode)
    -- Known Potential Outputs:
    -- Adapter 0: on-line 
    -- Adapter 0: off-line 
    for line in stdout:gmatch("[^\r\n]+") do
        if line:match("on%-?line") then
            ac_status = true; -- True, Charger plugged in
        else
            ac_status = false; -- False, Charger not plugged in
        end

    end

    awesome.emit_signal("battery::charger", ac_status)
end)
