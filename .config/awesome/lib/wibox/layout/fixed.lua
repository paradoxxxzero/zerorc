---------------------------------------------------------------------------
-- @author Uli Schlachter
-- @copyright 2010 Uli Schlachter
-- @release v3.4-440-g38d4602
---------------------------------------------------------------------------

local base = require("wibox.layout.base")
local widget_base = require("wibox.widget.base")
local table = table
local pairs = pairs

module("wibox.layout.fixed")

--- Draw a fixed layout. Each widget gets just the space it asks for.
-- @param dir "x" for a horizontal layout and "y" for vertical.
-- @param widgets The widgets to draw.
-- @param fill_space Use all the available space, giving all that is left to the
--                   last widget
-- @param cr The cairo context to use.
-- @param width The available width.
-- @param height The available height.
-- @return The total space needed by the layout.
function draw_fixed(dir, widgets, fill_space, wibox, cr, width, height)
    local pos = 0

    for k, v in pairs(widgets) do
        local x, y, w, h
        local in_dir
        if dir == "y" then
            x, y = 0, pos
            w, h = width, height - pos
            if k ~= #widgets or not fill_space then
                _, h = v:fit(w, h);
            end
            pos = pos + h
            in_dir = h
        else
            x, y = pos, 0
            w, h = width - pos, height
            if k ~= #widgets or not fill_space then
                w, _ = v:fit(w, h);
            end
            pos = pos + w
            in_dir = w
        end

        if (dir == "y" and pos > height) or
            (dir ~= "y" and pos > width) then
            break
        end
        base.draw_widget(wibox, cr, v, x, y, w, h)
    end
end

--- Add a widget to the given fixed layout
function add(layout, widget)
    widget_base.check_widget(widget)
    table.insert(layout.widgets, widget)
    widget:connect_signal("widget::updated", layout._emit_updated)
    layout._emit_updated()
end

--- Fit the fixed layout into the given space
-- @param dir "x" for a horizontal layout and "y" for vertical.
-- @param widgets The widgets to fit.
-- @param orig_width The available width.
-- @param orig_height The available height.
function fit_fixed(dir, widgets, orig_width, orig_height)
    local width, height = orig_width, orig_height
    local used_in_dir, used_max = 0, 0

    for k, v in pairs(widgets) do
        local w, h = v:fit(width, height)
        local in_dir, max
        if dir == "y" then
            max, in_dir = w, h
            height = height - in_dir
        else
            in_dir, max = w, h
            width = width - in_dir
        end
        if max > used_max then
            used_max = max
        end
        used_in_dir = used_in_dir + in_dir

        if width <= 0 or height <= 0 then
            if dir == "y" then
                used_in_dir = orig_height
            else
                used_in_dir = orig_width
            end
            break
        end
    end

    if dir == "y" then
        return used_max, used_in_dir
    end
    return used_in_dir, used_max
end

--- Reset a fixed layout. This removes all widgets from the layout.
function reset(layout)
    for k, v in pairs(layout.widgets) do
        v:disconnect_signal("widget::updated", layout._emit_updated)
    end
    layout.widgets = {}
    layout:emit_signal("widget::updated")
end

--- Set the layout's fill_space property. If this property is true, the last
-- widget will get all the space that is left. If this is false, the last widget
-- won't be handled specially and there can be space left unused.
function fill_space(layout, val)
    layout._fill_space = val
    layout:emit_signal("widget::updated")
end

local function get_layout(dir)
    local function draw(layout, ...)
        draw_fixed(dir, layout.widgets, layout._fill_space, ...)
    end
    local function fit(layout, ...)
        return fit_fixed(dir, layout.widgets, ...)
    end

    local ret = widget_base.make_widget()
    ret.draw = draw
    ret.fit = fit
    ret.add = add
    ret.reset = reset
    ret.fill_space = fill_space
    ret.widgets = {}
    ret._emit_updated = function()
        ret:emit_signal("widget::updated")
    end

    return ret
end

--- Returns a new horizontal fixed layout. Each widget will get as much space as it
-- asks for and each widget will be drawn next to its neighboring widget.
-- Widgets can be added via :add().
function horizontal()
    return get_layout("x")
end

--- Returns a new vertical fixed layout. Each widget will get as much space as it
-- asks for and each widget will be drawn next to its neighboring widget.
-- Widgets can be added via :add().
function vertical()
    return get_layout("y")
end

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
