--[[

     Licensed under GNU General Public License v2
      * (c) 2013, Luca CPZ
      * (c) 2010, Adrian C. <anrxc@sysphere.org>

--]]

local helpers = require("lain.helpers")
local awful = require("awful")
local shell   = require("awful.util").shell
local wibox   = require("wibox")
local string  = string

-- ALSA volume
-- lain.widget.alsa

local function factory(args)
    local keyboard     = { widget = wibox.widget.textbox() }
    local args     = args or {}
    local timeout  = args.timeout or 3600
    local settings = args.settings or function() end
    local format = { shell, "-c", "xkb-switch" }

    function keyboard.update()
    
    helpers.async(format, function(layout1)
        awful.spawn.with_shell("bingwall.sh")
        keyboard_now = layout1
        widget = keyboard.widget
        settings()
    end)
   -- keyboard_now = 13 
   -- widget = keyboard.widget
   -- settings()

    end

    helpers.newtimer("layout_now", timeout, keyboard.update)

    return keyboard
end

return factory
