local awful = require("awful")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")
local common = {}


function common.init(args)
    local args = args or {}
    -- Variable definitions
    
    -- Default appications (with fallbacks)
    common.terminal = args.terminal or os.getenv("TERMINAL") or "kitty" or "x-terminal-emulator" or "xterm"
    common.browser = args.browser or os.getenv("BROWSER") or "firefox" or "chromium-browser"
    common.editor = args.editor or os.getenv("EDITOR") or "vim" or "nano"
    common.filemanager = args.filemanager or "nautilus"
    common.editor_cmd = args.editor_cmd or common.terminal .. " -e " .. common.editor

    -- Default directories
    common.screenshot_dir = args.screenshot_dir or os.getenv("HOME") .. "/Pictures/Screenshots/"

    -- Default modkey.
    -- Usually, Mod4 is the key with a logo between Control and Alt.
    -- If you do not like this or do not have such a key,
    -- I suggest you to remap Mod4 to another key using xmodmap or other tools.
    -- However, you can use another modifier like Mod1, but it may interact with others.
    common.modkey = args.modkey or "Mod4"
    common.altkey = args.altkey or "Mod1"
    common.ctrlkey = args.ctrlkey or "Control"
    common.shiftkey = args.shiftkey or "Shift"


    -- Menu
    -- Create a launcher widget and a main menu
    local SYSTEMCTL="systemctl -q --no-block"

    common.mysessionmenu = {
        -- { "Lock", SYSTEMCTL .. " --user start lock.target" },
        { "Sleep", SYSTEMCTL .. " suspend" },
        { "Logout", SYSTEMCTL .. " --user exit" },
        { "Restart", SYSTEMCTL .. " reboot" },
        { "Shutdown", SYSTEMCTL .. " poweroff" },
    }

    common.mysystemmenu = {
        { "General Overview", common.terminal .. " -e gotop" },
        { "Detailed Overview", common.terminal .. " -e htop" },
        { "Volume", common.terminal .. " -e alsamixer" }, 
        { "Printers", "xdg-open http://localhost:631"}, 
    }

    common.myawesomemenu = {
       { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
       { "edit config", common.editor_cmd .. " " .. awesome.conffile },
       { "restart", awesome.restart },
       { "quit", function() awesome.quit() end },
    }

    -- Create main menu

    common. mymainmenu = awful.menu({ items = {
        { "Firefox", common.browser },
        { "Open Terminal", common.terminal },
        { "System", common.mysystemmenu },
        { "Session", common.mysessionmenu },
        { "Awesome Settings", common.myawesomemenu, beautiful.awesome_icon }
    }})
end

--return common
return setmetatable(common, {})
