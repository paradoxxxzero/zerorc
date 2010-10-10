---------------------------------------------------------------------------
-- @author Julien Danjou &lt;julien@danjou.info&gt;
-- @copyright 2009 Julien Danjou
-- @release v3.4-440-g38d4602
---------------------------------------------------------------------------

local setmetatable = setmetatable
local ipairs = ipairs
local math = math
local table = table
local type = type
local color = require("gears.color")
local base = require("wibox.widget.base")

--- A graph widget.
module("awful.widget.graph")

local data = setmetatable({}, { __mode = "k" })

--- Set the graph border color.
-- If the value is nil, no border will be drawn.
-- @name set_border_color
-- @class function
-- @param graph The graph.
-- @param color The border color to set.

--- Set the graph foreground color.
-- @name set_color
-- @class function
-- @param graph The graph.
-- @param color The graph color.

--- Set the graph background color.
-- @name set_background_color
-- @class function
-- @param graph The graph.
-- @param color The graph background color.

--- Set the maximum value the graph should handle.
-- If "scale" is also set, the graph never scales up below this value, but it
-- automatically scales down to make all data fit.
-- @name set_max_value
-- @class function
-- @param graph The graph.
-- @param value The value.

--- Set the graph to automatically scale its values. Default is false.
-- @name set_scale
-- @class function
-- @param graph The graph.
-- @param scale A boolean value

--- Set the graph to draw stacks. Default is false.
-- @name set_stack
-- @class function
-- @param progressbar The graph.
-- @param stack A boolean value.

--- Set the graph stacking colors. Order matters.
-- @name set_stack_colors
-- @class function
-- @param graph The graph.
-- @param stack_colors A table with stacking colors.

local properties = { "width", "height", "border_color", "stack",
                     "stack_colors", "color", "background_color",
                     "max_value", "scale" }

function draw(graph, wibox, cr, width, height)
    local max_value = data[graph].max_value
    local values = data[graph].values

    local border_width = 0
    if data[graph].border_color then
        border_width = 1
    end

    cr:set_line_width(1)

    -- Draw a stacked graph
    if data[graph].stack then

        if data[graph].scale then
            for _, v in ipairs(values) do
                for __, sv in ipairs(v) do
                    if sv > max_value then
                        max_value = sv
                    end
                end
            end
        end

        -- Draw the background first
        cr:rectangle(border_width, border_width,
                     width - (2 * border_width),
                     height)
        cr:set_source(color(data[graph].background_color or "#000000aa"))
        cr:fill()

        for i = 0, width - (2 * border_width) do
            local rel_i = 0
            local rel_x = width - border_width - i - 0.5

            if data[graph].stack_colors then
                for idx, col in ipairs(data[graph].stack_colors) do
                    local stack_values = values[idx]
                    if stack_values and i < #stack_values then
                        local value = stack_values[#stack_values - i] + rel_i

                        cr:move_to(rel_x, border_width - 0.5 +
                                          (height - 2 * border_width) * (1 - (rel_i / max_value)))
                        cr:line_to(rel_x, border_width - 0.5 +
                                          (height - 2 * border_width) * (1 - (value / max_value)))
                        cr:set_source(color(col or "#ff0000"))
                        cr:stroke()
                        rel_i = value
                    end
                end
            end
        end
    else
        if data[graph].scale then
            for _, v in ipairs(values) do
                if v > max_value then
                    max_value = v
                end
            end
        end

        cr:rectangle(border_width, border_width,
                     width - (2 * border_width),
                     height - (2 * border_width))
        cr:set_source(color(data[graph].color or "#ff0000"))
        cr:fill()

        -- Draw the background on no value
        if #values ~= 0 then
            -- Draw reverse
            for i = 0, #values - 1 do
                local value = values[#values - i]
                if value >= 0 then
                    value = value / max_value
                    cr:move_to(width - border_width - i - 0.5,
                               border_width - 0.5 +
                                   (height - 2 * border_width) * (1 - value))
                    cr:line_to(width - border_width - i - 0.5,
                               border_width - 1)
                end
            end
            cr:set_source(color(data[graph].background_color or "#000000aa"))
            cr:stroke()
        end

        -- If we didn't draw values in full length, draw a square
        -- over the last, left, part to reset everything to 0
        if #values < width - (2 * border_width) then
            cr:rectangle(border_width, border_width,
                         width - (2 * border_width) - #values,
                         height - (2 * border_width))
            cr:set_source(color(data[graph].background_color or "#000000aa"))
            cr:fill()
        end
    end

    -- Draw the border last so that it overlaps already drawn values
    if data[graph].border_color then
        -- Draw the border
        cr:rectangle(0.5, 0.5, width - 1, height - 1)
        cr:set_source(color(data[graph].border_color or "#ffffff"))
        cr:stroke()
    end
end

function fit(graph, width, height)
    return data[graph].width, data[graph].height
end

--- Add a value to the graph
-- @param graph The graph.
-- @param value The value between 0 and 1.
-- @param group The stack color group index.
local function add_value(graph, value, group)
    if not graph then return end

    local value = value or 0
    local values = data[graph].values
    local max_value = data[graph].max_value
    value = math.max(0, value)
    if not data[graph].scale then
        value = math.min(max_value, value)
    end

    if data[graph].stack and group then
        if not  data[graph].values[group]
        or type(data[graph].values[group]) ~= "table"
        then
            data[graph].values[group] = {}
        end
        values = data[graph].values[group]
    end
    table.insert(values, value)

    local border_width = 0
    if data[graph].border then border_width = 2 end

    -- Ensure we never have more data than we can draw
    while #values > data[graph].width - border_width do
        table.remove(values, 1)
    end

    graph:emit_signal("widget::updated")
    return graph
end


--- Set the graph height.
-- @param graph The graph.
-- @param height The height to set.
function set_height(graph, height)
    if height >= 5 then
        data[graph].height = height
        graph:emit_signal("widget::updated")
    end
    return graph
end

--- Set the graph width.
-- @param graph The graph.
-- @param width The width to set.
function set_width(graph, width)
    if width >= 5 then
        data[graph].width = width
        graph:emit_signal("widget::updated")
    end
    return graph
end

-- Build properties function
for _, prop in ipairs(properties) do
    if not _M["set_" .. prop] then
        _M["set_" .. prop] = function(graph, value)
            data[graph][prop] = value
            graph:emit_signal("widget::updated")
            return graph
        end
    end
end

--- Create a graph widget.
-- @param args Standard widget() arguments. You should add width and height
-- key to set graph geometry.
-- @return A graph widget.
function new(args)
    local args = args or {}

    local width = args.width or 100
    local height = args.height or 20

    if width < 5 or height < 5 then return end

    local graph = base.make_widget()

    data[graph] = { width = width, height = height, values = {}, max_value = 1 }

    -- Set methods
    graph.add_value = add_value
    graph.draw = draw
    graph.fit = fit

    for _, prop in ipairs(properties) do
        graph["set_" .. prop] = _M["set_" .. prop]
    end

    return graph
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
