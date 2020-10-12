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
    -- miscellaneous
    awful.key({ modkey,           }, "e", function () awful.spawn(common.filemanager) end,
              {description = "open a filemanager", group = "launcher"}),

    -- screenshots
    awful.key({                   }, "Print", function () screenshot.action("full") end,
              {description = "Screenshot entire screen", group = "Screenshots"}),
    awful.key({ altkey,           }, "Print", function () screenshot.action("selection") end,
              {description = "Screenshot selected area", group = "Screenshots"}),
    awful.key({ modkey,           }, "Print", function () screenshot.action("window") end,
              {description = "Screenshot current window", group = "Screenshots"}),

    -- sound
    -- TODO: Move everything below this comment into helper/dedicated file
    awful.key({                   }, "XF86AudioMute", function () awful.spawn("amixer sset Master toggle") end,
              {description = "Toggle Sound", group = "Function Keys"}),
    awful.key({                   }, "XF86AudioRaiseVolume", function() awful.spawn("amixer sset Master 5%+") end,
              {description = "Raise Volume", group = "Function Keys"}),
    awful.key({                   }, "XF86AudioLowerVolume", function() awful.spawn("amixer sset Master 5%-") end,
              {description = "Lower Volume", group = "Function Keys"}),
    
    -- brightness
    awful.key({                   }, "XF86MonBrightnessUp", function () awful.spawn("light -A 5%") end,
              {description = "Increase Brightness", group = "Function Keys"}),
    awful.key({                   }, "XF86MonBrightnessDown", function () awful.spawn("light -U 5%") end,
              {description = "Decrease Brightness", group = "Function Keys"})
})
