local awful = require("awful")

-- Table of layouts to cover with awful.layout.inc, order matters.
tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
        awful.layout.suit.tile,             -- left
        awful.layout.suit.tile.bottom,      -- top
        awful.layout.suit.tile.top,         -- bottom
        awful.layout.suit.tile.left,        -- right
        awful.layout.suit.floating,         -- floating (all programs)
        awful.layout.suit.corner.nw,        -- top left
        awful.layout.suit.fair,             -- even distributed (vertical, left-to-right)
        awful.layout.suit.fair.horizontal,  -- even distributed (horizontal, top-to-bottom)
        -- awful.layout.suit.spiral.dwindle,
        -- awful.layout.suit.spiral,
        -- awful.layout.suit.max,
        -- awful.layout.suit.max.fullscreen,
        -- awful.layout.suit.magnifier,
        -- awful.layout.suit.corner.ne,
        -- awful.layout.suit.corner.sw,
        -- awful.layout.suit.corner.se,
    })
end)
