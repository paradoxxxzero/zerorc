---------------------------------------------------------------------------
-- @author Julien Danjou &lt;julien@danjou.info&gt;
-- @copyright 2008-2009 Julien Danjou
-- @release v3.4-440-g38d4602
---------------------------------------------------------------------------

local setmetatable = setmetatable
local type = type
local button = require("awful.button")
local imagebox = require("wibox.widget.imagebox")
local capi = { mouse = mouse,
               oocairo = oocairo }

module("awful.widget.button")

--- Create a button widget. When clicked, the image is deplaced to make it like
-- a real button.
-- @param args Widget arguments. "image" is the image to display.
-- @return A textbox widget configured as a button.
function new(args)
    if not args or not args.image then return end
    local img_release
    if type(args.image) == "string" then
        img_release = capi.oocairo.image_surface_create_from_png(args.image)
    elseif type(args.image) == "userdata" and args.image.type and args.image:type() == "cairo_surface_t" then
        img_release = args.image
    end
    local img_press = capi.oocairo.image_surface_create("argb32", img_release:get_width(), img_release:get_height())
    local cr = capi.oocairo.context_create(img_press)
    cr:set_source(img_release, 2, 2)
    cr:paint()

    local w = imagebox()
    w:set_image(img_release)
    w:buttons(button({}, 1, function () w:set_image(img_press) end, function () w:set_image(img_release) end))
    return w
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
