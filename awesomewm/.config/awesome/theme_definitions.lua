local xresources = require('beautiful.xresources')
local xrdb = xresources.get_current_theme()

-- Following will give you a rough idea of what should be set to
-- what, if you where to compare to xrdb color values.
--
-- color0:  black
-- color1:  red
-- color2:  green
-- color3:  yellow
-- color4:  blue
-- color5:  purple/magenta
-- color6:  cyan
-- color7:  gray (darker)
-- color8:  gray (lighter/brighter)
-- color9:  red (lighter/brighter)
-- color10: green (lighter/brighter)
-- color11: yellow (lighter/brighter)
-- color12: blue (lighter/brighter)
-- color13: purple/magenta (lighter/brighter)
-- color14: cyan (lighter/brighter)
-- color15: white
--
-- REMEBER: arrays start at 1 in lua (by default)

local theme_definitions = {
    nord = {
        font = 'sans 8',
        bg = '#2E3440',
        fg = '#D8DEE9',
        colors = {
            '#3B4252',
            '#BF616A',
            '#A3BE8C',
            '#EBCB8B',
            '#81A1C1',
            '#B48EAD',
            '#88C0D0',
            '#E5E9F0',
            '#4C566A',
            '#BF616A',
            '#A3BE8C',
            '#EBCB8B',
            '#81A1C1',
            '#B48EAD',
            '#8FBCBB',
            '#ECEFF4'
        },
        icon_theme = "Papirus-Dark"
    },
    awm_default = {
        font = 'sans 8',
        bg = '#222222',
        fg = '#aaaaaa',
        colors = {
            '#000000',
            xrdb.color1,
            xrdb.color2,
            xrdb.color3,
            xrdb.color4,
            xrdb.color5,
            xrdb.color6,
            xrdb.color7,
            '#444444',
            '#ff0000',
            '#91231c',
            xrdb.color11,
            '#535d6c',
            xrdb.color13,
            xrdb.color14,
            '#ffffff'
        },
        icon_theme = "Papirus-Dark"
    },
    xrdb = {
        -- xrdb, make sure you have the xrdb values already defined before using this
        bg = xrdb.background,
        fg = xrdb.foreground,
        colors = {
            xrdb.color0,
            xrdb.color1,
            xrdb.color2,
            xrdb.color3,
            xrdb.color4,
            xrdb.color5,
            xrdb.color6,
            xrdb.color7,
            xrdb.color8,
            xrdb.color9,
            xrdb.color10,
            xrdb.color11,
            xrdb.color12,
            xrdb.color13,
            xrdb.color14,
            xrdb.color15
        }
    }
}

return theme_definitions
