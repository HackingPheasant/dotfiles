local awful = require("awful")

local common = require("common")

--  Mouse bindings
awful.mouse.append_global_mousebindings({
    awful.button({ }, 3, function () common.mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
})
