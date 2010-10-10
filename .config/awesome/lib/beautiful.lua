----------------------------------------------------------------------------
-- @author Damien Leone &lt;damien.leone@gmail.com&gt;
-- @author Julien Danjou &lt;julien@danjou.info&gt;
-- @copyright 2008-2009 Damien Leone, Julien Danjou
-- @release v3.4-440-g38d4602
----------------------------------------------------------------------------

-- Grab environment
local os = os
local print = print
local pcall = pcall
local pairs = pairs
local type = type
local dofile = dofile
local setmetatable = setmetatable
local util = require("awful.util")
local capi =
{
    screen = screen,
    awesome = awesome,
    oocairo = oocairo,
    oopango = oopango
}

--- Theme library.
module("beautiful")

-- Local data
local theme
local font
local font_height

function get_font()
    return font
end

function get_font_height()
    return font_height
end

local function set_font(f)
    font = capi.oopango.font_description_from_string(f)

    -- Create a temporary surface that we need for computing the size :(
    local surface = capi.oocairo.image_surface_create("argb32", 1, 1)
    local cr = capi.oocairo.context_create(surface)
    local layout
    -- Api breakage in oopango
    if capi.oopango.cairo_layout_create then
        layout = capi.oopango.cairo_layout_create(cr)
    else
        layout = capi.oopango.cairo.layout_create(cr)
    end

    layout:set_font_description(font)

    local width, height = layout:get_pixel_size()
    font_height = height
end

--- Init function, should be runned at the beginning of configuration file.
-- @param path The theme file path.
function init(path)
    if path then
        local success
        success, theme = pcall(function() return dofile(path) end)

        if not success then
            return print("E: beautiful: error loading theme file " .. theme)
        elseif theme then
            -- try and grab user's $HOME directory
            local homedir = os.getenv("HOME")
            -- expand '~'
            if homedir then
                for k, v in pairs(theme) do
                    if type(v) == "string" then theme[k] = v:gsub("~", homedir) end
                end
            end

            -- setup wallpaper
            if theme.wallpaper_cmd then
                for s = 1, capi.screen.count() do
                    util.spawn(theme.wallpaper_cmd[util.cycle(#theme.wallpaper_cmd, s)], false, s)
                end
            end
            if theme.font then set_font(theme.font) end
            if theme.fg_normal then capi.awesome.fg = theme.fg_normal end
            if theme.bg_normal then capi.awesome.bg = theme.bg_normal end
        else
            return print("E: beautiful: error loading theme file " .. path)
        end
    else
        return print("E: beautiful: error loading theme: no path specified")
    end
end

--- Get the current theme.
-- @return The current theme table.
function get()
    return theme
end

-- Set the default font
set_font("sans 8")

setmetatable(_M, { __index = function(t, k) return theme[k] end })

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
