local awful = require("awful")

local common = require("common")
local modkey = common.modkey
local ctrlkey = common.ctrlkey
local shiftkey = common.shiftkey

-- General Awesome keys
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "w", function () common.mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),
    awful.key({ modkey, ctrlkey   }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, shiftkey  }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),
    awful.key({ modkey,           }, "Return", function () awful.spawn(common.terminal) end,
              {description = "open a terminal", group = "launcher"}),
})
