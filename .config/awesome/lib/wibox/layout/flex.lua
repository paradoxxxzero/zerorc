---------------------------------------------------------------------------
-- @author Uli Schlachter
-- @copyright 2010 Uli Schlachter
-- @release v3.4-440-g38d4602
---------------------------------------------------------------------------

local base = require("wibox.layout.base")
local fixed = require("wibox.layout.fixed")
local widget_base = require("wibox.widget.base")
local table = table
local pairs = pairs
local floor = math.floor

module("wibox.layout.flex")

local function round(x)
    return floor(x + 0.5)
end

--- Draw a flex layout. Each widget gets an equal share of the available space
-- @param dir "x" for a horizontal layout and "y" for vertical.
-- @param widgets The widgets to draw.
-- @param cr The cairo context to use.
-- @param width The available width.
-- @param height The available height.
-- @return The total space needed by the layout.
function draw_flex(dir, widgets, wibox, cr, width, height)
    local pos = 0

    local num = #widgets
    local space_per_item
    if dir == "y" then
        space_per_item = height / num
    else
        space_per_item = width / num
    end

    for k, v in pairs(widgets) do
        local x, y, w, h
        if dir == "y" then
            x, y = 0, round(pos)
            w, h = width, floor(space_per_item)
        else
            x, y = round(pos), 0
            w, h = floor(space_per_item), height
        end
        base.draw_widget(wibox, cr, v, x, y, w, h)

        pos = pos + space_per_item

        if (dir == "y" and pos >= height) or
            (dir ~= "y" and pos >= width) then
            break
        end
    end
end

local function add(layout, widget)
    widget_base.check_widget(widget)
    table.insert(layout.widgets, widget)
    widget:connect_signal("widget::updated", layout._emit_updated)
    layout._emit_updated()
end

local function reset(layout)
    for k, v in pairs(layout.widgets) do
        v:disconnect_signal("widget::updated", layout._emit_updated)
    end
    layout.widgets = {}
    layout:emit_signal("widget::updated")
end

local function get_layout(dir)
    local function draw(layout, wibox, cr, width, height)
        draw_flex(dir, layout.widgets, wibox, cr, width, height)
    end

    local function fit(layout, width, height)
        return fixed.fit_fixed(dir, layout.widgets, width, height)
    end

    local ret = widget_base.make_widget()
    ret.draw = draw
    ret.fit = fit
    ret.add = add
    ret.reset = reset
    ret.widgets = {}
    ret._emit_updated = function()
        ret:emit_signal("widget::updated")
    end

    return ret
end

--- Returns a new horizontal flex layout. A flex layout shares the available space
-- equally among all widgets. Widgets can be added via :add(widget).
function horizontal()
    return get_layout("x")
end

--- Returns a new vertical flex layout. A flex layout shares the available space
-- equally among all widgets. Widgets can be added via :add(widget).
function vertical()
    return get_layout("y")
end

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
