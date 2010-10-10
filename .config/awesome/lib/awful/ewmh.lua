---------------------------------------------------------------------------
-- @author Julien Danjou &lt;julien@danjou.info&gt;
-- @copyright 2009 Julien Danjou
-- @release v3.4-440-g38d4602
---------------------------------------------------------------------------

local setmetatable = setmetatable
local client = client
local screen = screen
local ipairs = ipairs
local math = math

--- Implements EWMH requests handling.
module("awful.ewmh")

local data = setmetatable({}, { __mode = 'k' })

local function store_geometry(window, reqtype)
    if not data[window] then data[window] = {} end
    if not data[window][reqtype] then data[window][reqtype] = {} end
    data[window][reqtype] = window:geometry()
    data[window][reqtype].screen = window.screen
end

-- Maximize a window horizontally.
-- @param window The window.
-- @param set Set or unset the maximized values.
local function maximized_horizontal(window, set)
    if set then
        store_geometry(window, "maximized")
        local g = screen[window.screen].workarea
        window:geometry { width = g.width, x = g.x }
    elseif data[window] and data[window].maximized
        and data[window].maximized.x
        and data[window].maximized.width then
        window:geometry { width = data[window].maximized.width,
                          x = data[window].maximized.x }
    end
end

-- Maximize a window vertically.
-- @param window The window.
-- @param set Set or unset the maximized values.
local function maximized_vertical(window, set)
    if set then
        store_geometry(window, "maximized")
        local g = screen[window.screen].workarea
        window:geometry { height = g.height, y = g.y }
    elseif data[window] and data[window].maximized
        and data[window].maximized.y
        and data[window].maximized.height then
        window:geometry { height = data[window].maximized.height,
                          y = data[window].maximized.y }
    end
end

-- Fullscreen a window.
-- @param window The window.
-- @param set Set or unset the fullscreen values.
local function fullscreen(window, set)
    if set then
        store_geometry(window, "fullscreen")
        data[window].fullscreen.border_width = window.border_width
        local g = screen[window.screen].geometry
        window:geometry(screen[window.screen].geometry)
        window.border_width = 0
    elseif data[window] and data[window].fullscreen then
        window:geometry(data[window].fullscreen)
        window.border_width = data[window].fullscreen.border_width
    end
end

local function screen_change(window)
    if data[window] then
        for _, reqtype in ipairs({ "maximized", "fullscreen" }) do
            if data[window][reqtype] then
                if data[window][reqtype].width then
                    data[window][reqtype].width = math.min(data[window][reqtype].width,
                                                           screen[window.screen].workarea.width)
                end
                if data[window][reqtype].height then
                    data[window][reqtype].height = math.min(data[window][reqtype].height,
                                                             screen[window.screen].workarea.height)
                end
                if data[window][reqtype].screen then
                    local from = screen[data[window][reqtype].screen].workarea
                    local to = screen[window.screen].workarea
                    local new_x, new_y
                    if data[window][reqtype].x then
                        new_x = to.x + data[window][reqtype].x - from.x
                        if new_x > to.x + to.width then new_x = to.x end
                        data[window][reqtype].x = new_x
                    end
                    if data[window][reqtype].y then
                        new_y = to.y + data[window][reqtype].y - from.y
                        if new_y > to.y + to.width then new_y = to.y end
                        data[window][reqtype].y = new_y
                    end
                end
            end
        end
    end
end

client.connect_signal("request::maximized_horizontal", maximized_horizontal)
client.connect_signal("request::maximized_vertical", maximized_vertical)
client.connect_signal("request::fullscreen", fullscreen)
client.connect_signal("property::screen", screen_change)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
