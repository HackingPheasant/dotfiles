local awful = require("awful")
local wibox = require("wibox")

-- Create a textclock widget
local mysystray = wibox.widget.systray()
mysystray.visible = true

table.insert(globalwidgets.right, mysystray)
