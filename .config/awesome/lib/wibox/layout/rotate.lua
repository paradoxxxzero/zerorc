---------------------------------------------------------------------------
-- @author Uli Schlachter
-- @copyright 2010 Uli Schlachter
-- @release v3.4-440-g38d4602
---------------------------------------------------------------------------

local error = error
local pairs = pairs
local pi = math.pi
local type = type
local setmetatable = setmetatable
local tostring = tostring
local base = require("wibox.layout.base")
local widget_base = require("wibox.widget.base")

module("wibox.layout.rotate")

local function transform(layout, width, height)
    local dir = layout:get_direction()
    if dir == "east" or dir == "west" then
        return height, width
    end
    return width, height
end

--- Draw this layout
function draw(layout, wibox, cr, width, height)
    if not layout.widget then return { width = 0, height = 0 } end

    cr:save()
    local dir = layout:get_direction()

    if dir == "west" then
        cr:rotate(pi / 2)
        cr:translate(0, -width)
    elseif dir == "south" then
        cr:rotate(pi)
        cr:translate(-width, -height)
    elseif dir == "east" then
        cr:rotate(3 * pi / 2)
        cr:translate(-height, 0)
    end

    -- Since we rotated, we might have to swap width and height.
    -- transform() does that for us.
    layout.widget:draw(wibox, cr, transform(layout, width, height))

    -- Undo the rotation and translation from above.
    cr:restore()
end

--- Fit this layout into the given area
function fit(layout, width, height)
    if not layout.widget then
        return 0, 0
    end
    return transform(layout, layout.widget:fit(transform(layout, width, height)))
end

--- Set the widget that this layout rotates.
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

--- Reset this layout. The widget will be removed and the rotation reset.
function reset(layout)
    layout.direction = nil
    layout:set_widget(nil)
end

--- Set the direction of this rotating layout. Valid values are "north", "east",
-- "south" and "west". On an invalid value, this function will throw an error.
function set_direction(layout, dir)
    local allowed = {
        north = true,
        east = true,
        south = true,
        west = true
    }

    if not allowed[dir] then
        error("Invalid direction for rotate layout: " .. tostring(dir))
    end

    layout.direction = dir
    layout._emit_updated()
end

--- Get the direction of this rotating layout
function get_direction(layout)
    return layout.direction or "north"
end

--- Returns a new rotate layout. A rotate layout rotates a given widget. Use
-- :set_widget() to set the widget and :set_direction() for the direction.
-- The default direction is "north" which doesn't change anything.
local function new()
    local ret = widget_base.make_widget()

    for k, v in pairs(_M) do
        if type(v) == "function" then
            ret[k] = v
        end
    end

    ret._emit_updated = function()
        ret:emit_signal("widget::updated")
    end

    return ret
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
