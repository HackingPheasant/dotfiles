-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
-- Declarative object management
local ruled = require("ruled")

-- Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message
    }
end)

-- Enviroment/Variable definitions and Theme Setup
-- Themes define colours, icons, font and wallpapers.
local themes = {
    "geometric",        -- 1 --
}

-- Change this number to use a different theme
local chosen_theme = themes[1]
local theme_dir = os.getenv("HOME") .. "/.config/awesome/themes/"
beautiful.init( theme_dir .. chosen_theme .. "/theme.lua" )

local common = require("common")
common.init {
  -- Override any parametrs in common.lua. For example:
  --terminal = "xterm"
  --modkey = "Mod4"
  --editor = "nano"
}

require("init")
require("layouts")
require("wallpaper")
require("tags")
-- wibar layout: Require them in the order you want them to appear (as well as specifying 
-- left/middle/right in the  *.lua files) on the wibar/wibox
require("widgets.launcher")         -- Left
require("widgets.taglist")          -- Left
require("widgets.promptbox")        -- Left
require("widgets.tasklist")         -- Middle
require("widgets.keyboardlayout")   -- Right
require("widgets.systray")          -- Right
require("widgets.textclock")        -- Right
require("widgets.layoutbox")        -- Right
require("panel")                    -- Puts it all together on the wibar/wibox
require("program_menubar")
require("bindings.global_mouse")
require("bindings.global_general_keys")
require("bindings.global_tags_keys")
require("bindings.global_focus_keys")
require("bindings.global_layout_keys")
require("bindings.global_usercreated_keys")
require("bindings.client_mouse")
require("bindings.client_keys")
require("client_rules")
require("titlebars")
require("notifications")

-- Startup applications
-- Runs your autostart.sh script, which should include all the commands you
-- would like to run every time AwesomeWM restarts
awful.spawn.with_shell( os.getenv("HOME") .. "/.config/awesome/autorun.sh")
