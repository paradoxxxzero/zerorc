---------------------------------------------------------------------------
-- @author Uli Schlachter
-- @copyright 2010 Uli Schlachter
-- @release v3.4-440-g38d4602
---------------------------------------------------------------------------

require("wibox.layout")
require("wibox.widget")

local capi = {
    drawin = drawin,
    oocairo = oocairo,
    timer = timer
}
local setmetatable = setmetatable
local pairs = pairs
local type = type
local table = table
local color = require("gears.color")
local object = require("gears.object")
local sort = require("gears.sort")
local beautiful = require("beautiful")

module("wibox")

local function do_redraw(wibox)
    if not wibox.drawin.screen or not wibox.drawin.visible then
        return
    end

    local geom = wibox.drawin:geometry()
    local cr = capi.oocairo.context_create(wibox.drawin.surface)

    -- Clear the drawin
    cr:save()
    cr:set_operator("source")
    cr:set_source(wibox.background_color)
    cr:paint()
    cr:restore()

    -- Draw the widget
    wibox._widget_geometries = {}
    if wibox.widget and not wibox.widget.__fake_widget then
        cr:set_source(wibox.foreground_color)
        wibox.widget:draw(wibox, cr, geom.width, geom.height)
        wibox:widget_at(wibox.widget, 0, 0, geom.width, geom.height)
    end

    wibox.drawin:refresh()
end

--- Register a widget's position.
-- This is internal, don't call it yourself! Only wibox.layout.base.draw_widget
-- is allowed to call this.
function widget_at(wibox, widget, x, y, width, height)
    local t = {
        widget = widget,
        x = x, y = y,
        width = width, height = height
    }
    table.insert(wibox._widget_geometries, t)
end

--- Find a widget by a point.
-- The wibox must have drawn itself at least once for this to work.
-- @param wibox The wibox to look at
-- @param x X coordinate of the point
-- @param y Y coordinate of the point
-- @return A sorted table with all widgets that contain the given point. The
--         widgets are sorted by relevance.
function find_widgets(wibox, x, y)
    local matches = {}
    -- Find all widgets that contain the point
    for k, v in pairs(wibox._widget_geometries) do
        local match = true
        if v.x > x or v.x + v.width < x then match = false end
        if v.y > y or v.y + v.height < y then match = false end
        if match then
            table.insert(matches, v)
        end
    end

    -- Sort the matches by area, the assumption here is that widgets don't
    -- overlap and so smaller widgets are "more specific".
    local function cmp(a, b)
        local area_a = a.width * a.height
        local area_b = b.width * b.height
        return area_a < area_b
    end
    sort(matches, cmp)

    return matches
end

--- Set the widget that the wibox displays
function set_widget(wibox, widget)
    if wibox.widget and not wibox.widget.__fake_widget then
        -- Disconnect from the old widget so that we aren't updated due to it
        wibox.widget:disconnect_signal("widget::updated", wibox.draw)
    end

    if not widget then
        wibox.widget = { __fake_widget = true }
    else
        wibox.widget = widget
        widget:connect_signal("widget::updated", wibox.draw)
    end

    -- Make sure the wibox is updated
    wibox.draw()
end

--- Set the background of the wibox
-- @param wibox The wibox to use
-- @param c The background to use. This must either be a cairo pattern object,
--          nil or a string that gears.color() understands.
function set_bg(wibox, c)
    local c = c
    if type(c) == "string" then
        c = color(c)
    end
    wibox.background_color = c
    wibox.draw()
end

--- Set the foreground of the wibox
-- @param wibox The wibox to use
-- @param c The foreground to use. This must either be a cairo pattern object,
--          nil or a string that gears.color() understands.
function set_fg(wibox, c)
    local c = c
    if type(c) == "string" then
        c = color(c)
    end
    wibox.foreground_color = c
    wibox.draw()
end

--- Helper function to make wibox:buttons() work as expected
function buttons(box, ...)
    return box.drawin:buttons(...)
end

--- Helper function to make wibox:struts() work as expected
function struts(box, ...)
    return box.drawin:struts(...)
end

--- Helper function to make wibox:geometry() work as expected
function geometry(box, ...)
    return box.drawin:geometry(...)
end

local function emit_difference(name, list, skip)
    local function in_table(table, val)
        for k, v in pairs(table) do
            if v == val then
                return true
            end
        end
        return false
    end

    for k, v in pairs(list) do
        if not in_table(skip, v) then
            v:emit_signal(name)
        end
    end
end

local function handle_leave(wibox)
    emit_difference("mouse::leave", wibox._widgets_under_mouse, {})
    wibox._widgets_under_mouse = {}
end

local function handle_motion(wibox, x, y)
    if x < 0 or y < 0 or x > wibox.drawin.width or y > wibox.drawin.height then
        return handle_leave(wibox)
    end

    -- Build a plain list of all widgets on that point
    local widgets_list = wibox:find_widgets(x, y)
    local widgets = {}
    for k, v in pairs(widgets_list) do
        widgets[#widgets + 1] = v.widget
    end

    -- First, "leave" all widgets that were left
    emit_difference("mouse::leave", wibox._widgets_under_mouse, widgets)
    -- Then enter some widgets
    emit_difference("mouse::enter", widgets, wibox._widgets_under_mouse)

    wibox._widgets_under_mouse = widgets
end

local function setup_signals(wibox)
    local w = wibox.drawin

    local function clone_signal(name)
        wibox:add_signal(name)
        -- When "name" is emitted on wibox.drawin, also emit it on wibox
        w:connect_signal(name, function(_, ...)
            wibox:emit_signal(name, ...)
        end)
    end
    clone_signal("mouse::enter")
    clone_signal("mouse::leave")
    clone_signal("mouse::move")
    clone_signal("property::border_color")
    clone_signal("property::border_width")
    clone_signal("property::buttons")
    clone_signal("property::cursor")
    clone_signal("property::height")
    clone_signal("property::ontop")
    clone_signal("property::opacity")
    clone_signal("property::screen")
    clone_signal("property::struts")
    clone_signal("property::visible")
    clone_signal("property::widgets")
    clone_signal("property::width")
    clone_signal("property::x")
    clone_signal("property::y")

    -- Update the wibox when its geometry changes
    w:connect_signal("property::height", wibox.draw)
    w:connect_signal("property::width", wibox.draw)
    w:connect_signal("property::screen", wibox.draw)
    w:connect_signal("property::visible", wibox.draw)

    local function button_signal(name)
        w:connect_signal(name, function(w, x, y, ...)
            local widgets = wibox:find_widgets(x, y)
            for k, v in pairs(widgets) do
                -- Calculate x/y inside of the widget
                local lx = x - v.x
                local ly = y - v.y
                v.widget:emit_signal(name, lx, ly, ...)
            end
        end)
    end
    button_signal("button::press")
    button_signal("button::release")

    wibox:connect_signal("mouse::move", handle_motion)
    wibox:connect_signal("mouse::leave", handle_leave)
end

local function new(args)
    local ret = object()
    local w = capi.drawin(args)

    ret.drawin = w

    for k, v in pairs(_M) do
        if type(v) == "function" then
            ret[k] = v
        end
    end

    -- We use a timer with timeout 0, this makes sure that the wibox will only
    -- redrawn once even if there are multiple widget::updated events
    local t = capi.timer({ timeout = 0 })
    local function update_wibox()
        t:stop()
        do_redraw(ret)
    end
    t:connect_signal("timeout", update_wibox)

    -- Start our timer when the widget changed
    ret.draw = function()
        if not t.started then
            t:start()
        end
    end

    setup_signals(ret)

    -- Set the default background
    ret:set_bg(args.bg or beautiful.bg_normal)
    ret:set_fg(args.fg or beautiful.fg_normal)

    -- Make sure the wibox is drawn at least once
    ret.draw()

    -- Due to the metatable below, we need this trick
    ret.widget = { __fake_widget = true }
    ret._widget_geometries = {}
    ret._widgets_under_mouse = {}

    -- Redirect all non-existing indexes to the "real" drawin
    setmetatable(ret, {
        __index = w,
        __newindex = w
    })

    return ret
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
