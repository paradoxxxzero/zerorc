---------------------------------------------------------------------------
-- @author Uli Schlachter
-- @copyright 2010 Uli Schlachter
-- @release v3.4-440-g38d4602
---------------------------------------------------------------------------

local object = require("gears.object")
local pairs = pairs
local error = error
local type = type
local table = table

module("wibox.widget.base")

--- Set/get a widget's buttons
function buttons(widget, buttons)
    if buttons then
        widget.widget_buttons = buttons
    end

    return widget.widget_buttons
end

--- Handle a button event on a widget. This is used internally.
function handle_button(event, widget, x, y, button, modifiers)
    local function is_any(mod)
        if #mod ~= 1 then
            return false
        end
        if mod[1] ~= "Any" then
            return false
        end
        return true
    end

    local function tables_equal(a, b)
        if #a ~= #b then
            return false
        end
        for k, v in pairs(b) do
            if a[k] ~= v then
                return false
            end
        end
        return true
    end

    -- Find all matching button objects
    local matches = {}
    for k, v in pairs(widget.widget_buttons) do
        local match = true
        -- Is it the right button?
        if v.button ~= 0 and v.button ~= button then match = false end
        -- Are the correct modifiers pressed?
        if (not is_any(v.modifiers)) and (not tables_equal(v.modifiers, modifiers)) then match = false end
        if match then
            table.insert(matches, v)
        end
    end

    -- Emit the signals
    for k, v in pairs(matches) do
        v:emit_signal(event)
    end
end

--- Create a new widget. All widgets have to be generated via this function so
-- that the needed signals are added and mouse input handling is set up.
-- @param proxy If this is set, the returned widget will be a proxy for this
--              widget. It will be equivalent to this widget.
function make_widget(proxy)
    local ret = object()

    -- This signal is used by layouts to find out when they have to update.
    ret:add_signal("widget::updated")
    -- Mouse input, oh noes!
    ret:add_signal("button::press")
    ret:add_signal("button::release")
    ret:add_signal("mouse::enter")
    ret:add_signal("mouse::leave")

    -- No buttons yet
    ret.widget_buttons = {}
    ret.buttons = buttons

    -- Make buttons work
    ret:connect_signal("button::press", function(...)
        return handle_button("press", ...)
    end)
    ret:connect_signal("button::release", function(...)
        return handle_button("release", ...)
    end)

    if proxy then
        ret.size = function(_, ...) return proxy:size(...) end
        ret.draw = function(_, ...) return proxy:draw(...) end
        ret.fit = function(_, ...) return proxy:fit(...) end
        proxy:connect_signal("widget::updated", function()
            ret:emit_signal("widget::updated")
        end)
    end

    return ret
end

--- Do some sanity checking on widget. This function raises a lua error if
-- widget is not a valid widget.
function check_widget(widget)
    if type(widget) ~= "table" then
        error("widget is not a table?!")
    end
    for k, func in pairs({ "draw", "fit", "add_signal", "connect_signal", "disconnect_signal" }) do
        if type(widget[func]) ~= "function" then
            error("widget's " .. func .. "() is not a function?!")
        end
    end

    local width, height = widget:fit(0, 0)
    if type(width) ~= "number" or type(height) ~= "number" then
        error("widget's fit() didn't return two numbers")
    end
end

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
