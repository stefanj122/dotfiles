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
    local bright     = { widget = wibox.widget.textbox() }
    local args     = args or {}
    local timeout  = args.timeout or 5
    local settings = args.settings or function() end
    local format = { shell, "-c", "brightnessctl | grep 'Current' | cut -d '(' -f 2 | cut -d % -f 1" }

    function bright.update()
    
    helpers.async(format, function(brightness)
        bright_now = brightness
        widget = bright.widget
        settings()
    end)
--    bright_now = io.popen("xbacklight -get | xargs printf '%.0f'"):read("*l")

 --   widget = bright.widget
 --   settings()

    end

    helpers.newtimer("bright_now", timeout, bright.update)

    return bright
end

return factory
