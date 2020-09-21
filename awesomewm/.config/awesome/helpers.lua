-- Functions that you use more than once and in different files would
-- be nice to define here.
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local wibox = require("wibox")

local naughty = require("naughty")

local common = require("common")

local helpers = {}


-- Screenshots
--------------------------------------------------------------------------------

-- TODO: 
-- notification action buttons
-- grab current window via awesome, so one less external dependency
-- sort out my icon situation
function helpers.screenshot(action, delay)
    local cmd
    local timestamp = os.date("'%Y-%m-%d %H-%M-%S'")
    local filename = common.screenshot_dir.."'Screenshot from '"..timestamp..".png"
    local maim_args = "-u -b 3 -m 5"
    -- local icon = icons.screenshot

    local prefix
    if delay then
        prefix = "sleep "..tostring(delay).." && "
    else
        prefix = ""
    end

    if action == "full" then
        cmd = prefix.."maim "..maim_args.." "..filename
        print(filename)
        awful.spawn.easy_async_with_shell(cmd, function(_, __, ___, ____)
            naughty.notify({ title = "Screenshot", message = "Screenshot taken", icon = icon })
        end)
    elseif action == "selection" then
        cmd = "maim "..maim_args.." -s "..filename
        naughty.notify({ title = "Screenshot", message = "Select area to capture.", icon = icon })
        awful.spawn.easy_async_with_shell(cmd, function(_, __, ___, exit_code)
            if exit_code == 0 then
                naughty.notify({ title = "Screenshot", message = "Selection captured", icon = icon })
            end
        end)
    elseif action == "window" then
        cmd = "maim "..maim_args.." -i $(xdotool getactivewindow) "..filename
        awful.spawn.easy_async_with_shell(cmd, function(_, __, ___, exit_code)
            if exit_code == 0 then
                naughty.notify({ title = "Screenshot", message = "Window captured", icon = icon })
            end
        end)
    elseif action == "clipboard" then
        naughty.notify({ title = "Screenshot", message = "Select area to copy to clipboard.", icon = icon })
        cmd = "maim "..maim_args.." -s | xclip -selection clipboard -t image/png"
        awful.spawn.easy_async_with_shell(cmd, function(_, __, ___, exit_code)
            if exit_code == 0 then
                naughty.notify({ title = "Screenshot", message = "Copied selection to clipboard", icon = icon })
            end
        end)
    elseif action == "browse" then
        awful.spawn.with_shell("cd "..screenshot_dir.." && feh $(ls -t)")
    elseif action == "gimp" then
        awful.spawn.with_shell("cd "..screenshot_dir.." && gimp $(ls -t | head -n1)")
        naughty.notify({ message = "Opening last screenshot with GIMP", icon = icon })
    end

end

return helpers
