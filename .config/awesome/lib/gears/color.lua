---------------------------------------------------------------------------
-- @author Uli Schlachter
-- @copyright 2010 Uli Schlachter
-- @release v3.4-440-g38d4602
---------------------------------------------------------------------------

local setmetatable = setmetatable
local string = string
local table = table
local tonumber = tonumber
local unpack = unpack
local pairs = pairs
local type = type
local capi = {
    oocairo = oocairo
}

module("gears.color")

--- Parse a HTML-color.
-- This function can parse colors like #rrggbb and #rrggbbaa.
-- For example, parse_color("#00ff00ff") would return 0, 1, 0, 1.
-- Thanks to #lua for this. :)
-- @param col The color to parse
-- @return 4 values which each are in the range [0, 1].
function parse_color(col)
    local rgb = {}
    for pair in string.gmatch(col, "[^#].") do
        local i = tonumber(pair, 16)
        if i then
            table.insert(rgb, i / 255)
        end
    end
    while #rgb < 4 do
        table.insert(rgb, 1)
    end
    return unpack(rgb)
end

--- Find all numbers in a string
-- @param s The string to parse
-- @return Each number found as a separate value
local function parse_numbers(s)
    local res = {}
    for k in string.gmatch(s, "-?[0-9]+[.]?[0-9]*") do
        table.insert(res, tonumber(k))
    end
    return unpack(res)
end

--- Create a solid pattern
-- @param col The color for the pattern
-- @return A cairo pattern object
function create_solid_pattern(col)
    local col = col
    if col == nil then
        col = "#000000"
    end
    return capi.oocairo.pattern_create_rgba(parse_color(col))
end

--- Create an image pattern from a png file
-- @param file The filename of the file
-- @return a cairo pattern object
function create_png_pattern(file)
    local image = capi.oocairo.image_surface_create_from_png(file)
    return capi.oocairo.pattern_create_for_surface(image)
end

--- Add stops to the given pattern.
-- @param p The cairo pattern to add stops to
-- @param iterator An iterator that returns strings. Each of those strings
--                 should be in the form place,color where place is in [0, 1].
function add_stops(p, iterator)
    for k in iterator do
        local sub = string.gmatch(k, "[^,]+")
        local point, color = sub(), sub()
        p:add_color_stop_rgba(point, parse_color(color))
    end
end

--- Create a linear pattern object.
-- The pattern is created from a string. This string should have the following
-- form: "x0,y0:x1,y1:<stops>"
-- x0,y0 and x1,y1 are the start and stop point of the pattern.
-- For the explanation of "<stops>", see add_stops().
-- @param arg The argument describing the pattern
-- @return a cairo pattern object
-- @nname create_linear_pattern
-- @nclass function

--- Create a radial pattern object.
-- The pattern is created from a string. This string should have the following
-- form: "x0,y0,r0:x1,y1,r1:<stops>"
-- x0,y0 and x1,y1 are the start and stop point of the pattern.
-- r0 and r1 are the radii of the start / stop circle.
-- For the explanation of "<stops>", see add_stops().
-- @param arg The argument describing the pattern
-- @return a cairo pattern object
-- @nname create_radial_pattern
-- @nclass function

for k, v in pairs({ linear = capi.oocairo.pattern_create_linear,
                    radial = capi.oocairo.pattern_create_radial}) do
    _M["create_" .. k .. "_pattern"] = function(arg)
        local iterator = string.gmatch(arg, "[^:]+")
        -- Create a table where each entry is a number from the original string
        local args = { parse_numbers(iterator()) }
        local to = { parse_numbers(iterator()) }
        -- Now merge those two tables
        for k, v in pairs(to) do
            table.insert(args, v)
        end
        -- And call our creator function with the values
        local p = v(unpack(args))

        add_stops(p, iterator)
        return p
    end
end

types = {
    solid = create_solid_pattern,
    png = create_png_pattern,
    linear = create_linear_pattern,
    radial = create_radial_pattern
}

--- Create a pattern from a given string.
-- This function can create solid, linear, radial and png patterns. In general,
-- patterns are specified as "type:arguments". "arguments" is specific to the
-- pattern used. For example, one can use
-- "linear:50,50,10:55,55,30:0,#ff0000:0.5,#00ff00:1,#0000ff"
-- Any argument that cannot be understood is passed to create_solid_pattern().
-- @see create_solid_pattern, create_png_pattern, create_linear_pattern,
--      create_radial_pattern
-- @param col The string describing the pattern.
-- @return a cairo pattern object
function create_pattern(col)
    if type(col) == "string" then
        local t = string.match(col, "[^:]+")
        if types[t] then
            local pos = string.len(t)
            local arg = string.sub(col, pos + 2)
            return types[t](arg)
        end
    end
    return create_solid_pattern(col)
end

setmetatable(_M, { __call = function (_, ...) return create_pattern(...) end })

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
