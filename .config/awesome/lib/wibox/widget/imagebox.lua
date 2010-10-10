---------------------------------------------------------------------------
-- @author Uli Schlachter
-- @copyright 2010 Uli Schlachter
-- @release v3.4-440-g38d4602
---------------------------------------------------------------------------

local oocairo = require("oocairo")
local base = require("wibox.widget.base")
local setmetatable = setmetatable
local pairs = pairs
local type = type
local pcall = pcall
local print = print

module("wibox.widget.imagebox")

--- Draw an imagebox with the given cairo context in the given geometry.
function draw(box, wibox, cr, width, height)
    if not box.image then return end

    cr:save()

    if not box.resize_forbidden then
        -- Let's scale the image so that it fits into (width, height)
        local w = box.image:get_width()
        local h = box.image:get_height()
        local aspect = width / w
        local aspect_h = height / h
        if aspect > aspect_h then aspect = aspect_h end

        cr:scale(aspect, aspect)
    end
    cr:set_source(box.image)
    cr:paint()

    cr:restore()
end

--- Fit the imagebox into the given geometry
function fit(box, width, height)
    if not box.image then
        return 0, 0
    end

    local w = box.image:get_width()
    local h = box.image:get_height()

    if w > width then
        h = h * width / w
        w = width
    end
    if h > height then
        w = w * height / h
        h = height
    end

    if not box.resize_forbidden then
        local aspect = width / w
        local aspect_h = height / h

        -- Use the smaller one of the two aspect ratios.
        if aspect > aspect_h then aspect = aspect_h end

        w, h = w * aspect, h * aspect
    end

    return w, h
end

--- Set an imagebox' image
-- @param image Either a string or a cairo image surface. A string is
--              interpreted as the path to a png image file.
function set_image(box, image)
    local image = image

    if type(image) == "string" then
        local success, result = pcall(oocairo.image_surface_create_from_png, image)
        if not success then
            print("Error while reading '" .. image .. "': " .. result)
            return false
        end
        image = result
    end

    box.image = image

    box:emit_signal("widget::updated")
    return true
end

--- Should the image be resized to fit into the available space?
-- @param allowed If false, the image will be clipped, else it will be resized
--                to fit into the available space.
function set_resize(box, allowed)
    box.resize_forbidden = not allowed
    box:emit_signal("widget::updated")
end

-- Returns a new imagebox
local function new()
    local ret = base.make_widget()

    for k, v in pairs(_M) do
        if type(v) == "function" then
            ret[k] = v
        end
    end

    return ret
end

setmetatable(_M, { __call = function (_, ...) return new(...) end })

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
