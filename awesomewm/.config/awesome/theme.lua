---------------------
-- Geometric theme --
---------------------
local theme_name = "geometric"

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local xrdb = xresources.get_current_theme()
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local layout_icon_path = os.getenv("HOME") .. "/.config/awesome/themes/" .. theme_name .. "/layout/"
local titlebar_icon_path = os.getenv("HOME") .. "/.config/awesome/themes/" .. theme_name .. "/titlebar/"
local taglist_icon_path = os.getenv("HOME") .. "/.config/awesome/themes/" .. theme_name .. "/taglist/"
-- inherit default theme
-- until we have our own custom everything, we will override the important info
local theme = dofile(themes_path.."default/theme.lua")
-- local theme = {}

-- Set theme wallpaper.
-- It won't change anything if using an external program to set the wallpaper
theme.wallpaper = os.getenv("HOME") .. "/Pictures/Wallpapers/wallpaper.png"

-- Set the theme font. This is the font that will be used by default in menus, bars, titlebars etc.
theme.font          = "sans 8"

-- Get colors from .Xresources and set fallback colors

theme.useless_gap   = dpi(0)
theme.border_width  = dpi(1)

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "Papirus-Dark"

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
