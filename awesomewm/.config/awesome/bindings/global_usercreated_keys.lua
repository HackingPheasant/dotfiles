local awful = require("awful")

-- User created helper functios
local screenshot = require("helpers.screenshot")
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
    awful.key({                   }, "Print", function () screenshot.action("full") end,
              {description = "Screenshot entire screen", group = "Screenshots"}),
    awful.key({ altkey,           }, "Print", function () screenshot.action("selection") end,
              {description = "Screenshot selected area", group = "Screenshots"}),
    awful.key({ modkey,           }, "Print", function () screenshot.action("window") end,
              {description = "Screenshot current window", group = "Screenshots"}),
    --awful.key({ altkey, "v"       }, "Print", function () screenshot.action("clipboard") end,
    --          {description = "Screenshot selected area and copy to clipboard", group = "Sceenshots"}),
    --awful.key({ modkey, "b"       }, "Print", function () screenshot.action("browse") end,
    --          {description = "Browse Screenshots", group = "Screenshots"}),
    --awful.key({ modkey, "g"       }, "Print", function () screenshot.action("gimp") end,
    --          {description = "Edit most recent screenshot with gimp", group = "Screenshots"}),

    -- sound
    -- TODO: Move everything below this comment into helper/dedicated file
    awful.key({                   }, "XF86AudioMute", function () awful.spawn("amixer sset Master toggle") end,
              {description = "Toggle Sound", group = "Function Keys"}),
    awful.key({                   }, "XF86AudioRaiseVolume", function() awful.spawn("amixer sset Master 5%+") end,
              {description = "Raise Volume", group = "Function Keys"}),
    awful.key({                   }, "XF86AudioLowerVolume", function() awful.spawn("amixer sset Master 5%-") end,
              {description = "Lower Volume", group = "Function Keys"}),
    
    -- brightness
    -- xbacklight currently doesnt work on my laptop
    -- No outputs have backlight property
    -- TODO: FIX IT
    awful.key({                   }, "XF86MonBrightnessUp", function () awful.spawn("xbacklight -inc 5%") end,
              {description = "Increase Brightness", group = "Function Keys"}),
    awful.key({                   }, "XF86MonBrightnessDown", function () awful.spawn("xbacklight -dec 5%") end,
              {description = "Decrease Brightness", group = "Function Keys"})

    -- lockscreen
    -- awful.key({ ctrlkey           }, "l", function() awful.spawn("awesome-client '_G.show_lockscreen()'", false) end,
    --          {description = "lock the screen", group = "Utility"})
})
