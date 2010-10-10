---------------------------------------------------------------------------
-- @author Uli Schlachter
-- @copyright 2010 Uli Schlachter
-- @release v3.4-440-g38d4602
---------------------------------------------------------------------------

local pairs = pairs
local pcall = pcall
local print = print

module("wibox.layout.base")

--- Figure out the geometry in device coordinate space. This will break if
-- someone rotates the coordinate space by a non-multiple of 90°.
function rect_to_device_geometry(cr, x, y, width, height)
    local function min(a, b)
        if a < b then return a end
        return b
    end
    local function max(a, b)
        if a > b then return a end
        return b
    end

    local x1, y1 = cr:user_to_device(x, y)
    local x2, y2 = cr:user_to_device(x + width, y + height)
    local x = min(x1, x2)
    local y = min(y1, y2)
    local width = max(x1, x2) - x
    local height = max(y1, y2) - y

    return x, y, width, height
end

--- Draw a widget via a cairo context
-- @param wibox The wibox on which we are drawing
-- @param cr The cairo context used
-- @param widget The widget to draw (this uses widget:draw(cr, width, height)).
-- @param x The position that the widget should get
-- @param y The position that the widget should get
-- @param width The widget's width
-- @param height The widget's height
function draw_widget(wibox, cr, widget, x, y, width, height)
    -- Use save() / restore() so that our modifications aren't permanent
    cr:save()

    -- Move (0, 0) to the place where the widget should show up
    cr:translate(x, y)

    -- Make sure the widget cannot draw outside of the allowed area
    cr:rectangle(0, 0, width, height)
    cr:clip()

    -- Let the widget draw itself
    local success, msg = pcall(widget.draw, widget, wibox, cr, width, height)
    if not success then
        print("Error while drawing widget: " .. msg)
    end

    -- Register the widget for input handling
    wibox:widget_at(widget, rect_to_device_geometry(cr, 0, 0, width, height))

    cr:restore()
end

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
