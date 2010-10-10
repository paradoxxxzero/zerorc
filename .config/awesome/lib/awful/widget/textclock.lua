---------------------------------------------------------------------------
-- @author Julien Danjou &lt;julien@danjou.info&gt;
-- @copyright 2009 Julien Danjou
-- @release v3.4-440-g38d4602
---------------------------------------------------------------------------

local setmetatable = setmetatable
local os = os
local textbox = require("wibox.widget.textbox")
local capi = { timer = timer }

--- Text clock widget.
module("awful.widget.textclock")

--- Create a textclock widget. It draws the time it is in a textbox.
-- @param format The time format. Default is " %a %b %d, %H:%M ".
-- @param timeout How often update the time. Default is 60.
-- @return A textbox widget.
function new(format, timeout)
    local format = format or " %a %b %d, %H:%M "
    local timeout = timeout or 60

    local w = textbox()
    local timer = capi.timer { timeout = timeout }
    timer:connect_signal("timeout", function() w:set_markup(os.date(format)) end)
    timer:start()
    timer:emit_signal("timeout")
    return w
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
