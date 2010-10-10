---------------------------------------------------------------------------
-- @author Uli Schlachter
-- @copyright 2010 Uli Schlachter
-- @release v3.4-440-g38d4602
---------------------------------------------------------------------------

local oocairo = require("oocairo")
local base = require("wibox.widget.base")
local color = require("gears.color")
local layout_base = require("wibox.layout.base")
local setmetatable = setmetatable
local pairs = pairs
local type = type

module("wibox.widget.background")

--- Draw this widget
function draw(box, wibox, cr, width, height)
    if not box.widget then
        return
    end

    cr:save()

    if box.background then
        cr:set_source(box.background)
        cr:paint()
    end
    if box.bgimage then
        local pattern = oocairo.pattern_create_for_surface(box.bgimage)
        cr:set_source(pattern)
        cr:paint()
    end

    cr:restore()

    layout_base.draw_widget(wibox, cr, box.widget, 0, 0, width, height)
end

--- Fit this widget into the given area
function fit(box, width, height)
    if not box.widget then
        return 0, 0
    end

    return box.widget:fit(width, height)
end

--- Set the widget that is drawn on top of the background
function set_widget(box, widget)
    if box.widget then
        box.widget:disconnect_signal("widget::updated", box._emit_updated)
    end
    if widget then
        base.check_widget(widget)
        widget:connect_signal("widget::updated", box._emit_updated)
    end
    box.widget = widget
    box._emit_updated()
end

--- Set the background to use
function set_bg(box, bg)
    if bg then
        box.background = color(bg)
    else
        box.background = nil
    end
    box._emit_updated()
end

--- Set the background image to use
function set_bgimage(box, image)
    local image = image

    if type(image) == "string" then
        image = oocairo.image_surface_create_from_png(image)
    end

    box.bgimage = image
    box._emit_updated()
end

local function new()
    local ret = base.make_widget()

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

setmetatable(_M, { __call = function (_, ...) return new(...) end })

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
