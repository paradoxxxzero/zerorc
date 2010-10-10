---------------------------------------------------------------------------
-- @author Uli Schlachter
-- @copyright 2010 Uli Schlachter
-- @release v3.4-440-g38d4602
---------------------------------------------------------------------------

local pairs = pairs
local type = type
local setmetatable = setmetatable
local base = require("wibox.layout.base")
local widget_base = require("wibox.widget.base")

module("wibox.layout.margin")

--- Draw a margin layout
function draw(layout, wibox, cr, width, height)
    local x = layout.left
    local y = layout.top
    local w = layout.right
    local h = layout.bottom

    if not layout.widget or width <= x + w or height <= y + h then
        return
    end

    base.draw_widget(wibox, cr, layout.widget, x, y, width - x - w, height - y - h)
end

--- Fit a margin layout into the given space
function fit(layout, width, height)
    local extra_w = layout.left + layout.right
    local extra_h = layout.top + layout.bottom
    local w, h = 0, 0
    if layout.widget then
        w, h = layout.widget:fit(width - extra_w, height - extra_h)
    end
    return w + extra_w, h + extra_h
end

--- Set the widget that this layout adds a margin on.
function set_widget(layout, widget)
    if layout.widget then
        layout.widget:disconnect_signal("widget::updated", layout._emit_updated)
    end
    if widget then
        widget_base.check_widget(widget)
        widget:connect_signal("widget::updated", layout._emit_updated)
    end
    layout.widget = widget
    layout._emit_updated()
end

--- Set all the margins to val.
function set_margins(layout, val)
    layout.left = val
    layout.right = val
    layout.top = val
    layout.bottom = val
    layout:emit_signal("widget::updated")
end

--- Reset this layout. The widget will be unreferenced and the margins set to 0.
function reset(layout)
    layout:set_widget(nil)
    layout:set_margins(0)
end

--- Set the left margin that this layout adds to its widget.
-- @param layout The layout you are modifying.
-- @param margin The new margin to use.
-- @name set_left
-- @class function

--- Set the right margin that this layout adds to its widget.
-- @param layout The layout you are modifying.
-- @param margin The new margin to use.
-- @name set_right
-- @class function

--- Set the top margin that this layout adds to its widget.
-- @param layout The layout you are modifying.
-- @param margin The new margin to use.
-- @name set_top
-- @class function

--- Set the bottom margin that this layout adds to its widget.
-- @param layout The layout you are modifying.
-- @param margin The new margin to use.
-- @name set_bottom
-- @class function

-- Create setters for each direction
for k, v in pairs({ "left", "right", "top", "bottom" }) do
    _M["set_" .. v] = function(layout, val)
        layout[v] = val
        layout:emit_signal("widget::updated")
    end
end

--- Returns a new margin layout.
-- @param widget A widget to use (optional)
-- @param left A margin to use on the left side of the widget (optional)
-- @param right A margin to use on the right side of the widget (optional)
-- @param top A margin to use on the top side of the widget (optional)
-- @param bottom A margin to use on the bottom side of the widget (optional)
local function new(widget, left, right, top, bottom)
    local ret = widget_base.make_widget()

    for k, v in pairs(_M) do
        if type(v) == "function" then
            ret[k] = v
        end
    end

    ret._emit_updated = function()
        ret:emit_signal("widget::updated")
    end

    ret:set_left(left or 0)
    ret:set_right(right or 0)
    ret:set_top(top or 0)
    ret:set_bottom(bottom or 0)

    if widget then
        ret:set_widget(widget)
    end

    return ret
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
