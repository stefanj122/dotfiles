--[[

     Licensed under GNU General Public License v2
      * (c) 2013, Luca CPZ

--]]

local helpers  = require("lain.helpers")
local wibox    = require("wibox")
local awful    = require("awful")
local open     = io.open
local tonumber = tonumber


-- coretemp
-- lain.widget.temp

local function factory(args)
    local temp     = { widget = wibox.widget.textbox() }
    local args     = args or {}
    local timeout  = args.timeout or 2
    local tempfile = args.tempfile or "/sys/class/thermal/thermal_zone0/temp"
    local settings = args.settings or function() end
    
    function temp.update()
        local f = open(tempfile)
        if f then
            coretemp_now = tonumber(f:read("*all")) / 1000
         -- nvsmi = 1
            f:close()

           -- awful.spawn.async_with_shell("nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader",local function(stdout)
            --    nvsmi = stdout
            --end)
            nvsmi = io.popen("nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader"):read("*l")
        else
            coretemp_now = "N/A"
        end

        widget = temp.widget
        settings()
    end

    helpers.newtimer("coretemp", timeout, temp.update)

    return temp
end

return factory
