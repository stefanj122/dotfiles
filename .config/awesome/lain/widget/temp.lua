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
    local nvsmi1 = 0
    local cpu1 = 0
    nvsmi = 3
    

    function temp.update()

        
        awful.spawn.easy_async_with_shell("cat /sys/class/thermal/thermal_zone0/temp",function(out2,out3)
            coretemp_now = out2/1000
        end)
        coretemp_now = coretemp_now or 0
        coretemp_now = string.format("%.0f",coretemp_now)

        awful.spawn.easy_async_with_shell("nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader",function(out,out1)
            nvsmi = out
        end)
        nvsmi = nvsmi or 0
        nvsmi = string.format("%.0f",nvsmi)
        

    widget = temp.widget
    settings()
end

    helpers.newtimer("coretemp", timeout, temp.update)

    return temp
end

return factory
