local awful = require("awful")

-- User created helper functios
local helpers = require("helpers")
-- require("module.lockscreen")

local common = require("common")
local modkey = common.modkey
local altkey = common.altkey
local ctrlkey = common.ctrlkey
local shiftkey = common.shiftkey


-- My Customisations 
awful.keyboard.append_global_keybindings({ 
    awful.key({ modkey,           }, "e", function () awful.spawn(common.filemanager) end,
              {description = "open a filemanager", group = "launcher"}),

    -- screenshots
    -- TODO: Decide on non-conflicting keys to use
    awful.key({                   }, "Print", function () helpers.screenshot("full") end,
              {description = "Screenshot entire screen", group = "Screenshots"}),
    awful.key({ altkey,           }, "Print", function () helpers.screenshot("selection") end,
              {description = "Screenshot selected area", group = "Screenshots"}),
    awful.key({ modkey,           }, "Print", function () helpers.screenshot("window") end,
              {description = "Screenshot current window", group = "Screenshots"}),
    --awful.key({ altkey, "v"       }, "Print", function () helpers.screenshot("clipboard") end,
    --          {description = "Screenshot selected area and copy to clipboard", group = "Sceenshots"}),
    --awful.key({ modkey, "b"       }, "Print", function () helpers.screenshot("browse") end,
    --          {description = "Browse Screenshots", group = "Screenshots"}),
    --awful.key({ modkey, "g"       }, "Print", function () helpers.screenshot("gimp") end,
    --          {description = "Edit most recent screenshot with gimp", group = "Screenshots"}),

    -- sound
    -- TODO: Move everything below this comment into helper/dedicated file
    awful.key({                   }, "XF86AudioMute", function () awful.util.spawn("amixer sset Master toggle") end,
              {description = "Toggle Sound", group = "Function Keys"}),
    awful.key({                   }, "XF86AudioRaiseVolume", function () awful.util.spawn("amixer sset Master 5%+") end,
              {description = "Raise Volume", group = "Function Keys"}),
    awful.key({                   }, "XF86AudioLowerVolume", function () awful.util.spawn("amixer sset Master 5%-") end,
              {description = "Lower Volume", group = "Function Keys"}),
    
    -- brightness
    -- xbacklight currently doesnt work on my laptop
    -- No outputs have backlight property
    -- TODO: FIX IT
    awful.key({                   }, "XF86MonBrightnessUp", function () awful.util.spawn("xbacklight -inc 5%") end,
              {description = "Increase Brightness", group = "Function Keys"}),
    awful.key({                   }, "XF86MonBrightnessDown", function () awful.util.spawn("xbacklight -dec 5%") end,
              {description = "Decrease Brightness", group = "Function Keys"})

    -- lockscreen
    -- awful.key({ ctrlkey           }, "l", function() awful.spawn("awesome-client '_G.show_lockscreen()'", false) end,
    --          {description = "lock the screen", group = "Utility"})
})
