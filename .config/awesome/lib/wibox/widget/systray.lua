---------------------------------------------------------------------------
-- @author Uli Schlachter
-- @copyright 2010 Uli Schlachter
-- @release v3.4-440-g38d4602
---------------------------------------------------------------------------

local wbase = require("wibox.widget.base")
local lbase = require("wibox.layout.base")
local capi = { awesome = awesome }
local setmetatable = setmetatable
local error = error

module("wibox.widget.systray")

local created_systray = false
local horizontal = true
local base_size = nil

function draw(box, wibox, cr, width, height)
    local x, y, width, height = lbase.rect_to_device_geometry(cr, 0, 0, width, height)
    local num_entries = capi.awesome.systray()

    local in_dir, ortho, base
    if horizontal then
        in_dir, ortho = width, height
    else
        ortho, in_dir = width, height
    end
    if ortho * num_entries <= in_dir then
        base = ortho
    else
        base = in_dir / num_entries
    end
    capi.awesome.systray(wibox.drawin, x, y, base, horizontal)
end

function fit(box, width, height)
    local num_entries = capi.awesome.systray()
    local base = base_size
    if base == nil then
        if width < height then
            base = width
        else
            base = height
        end
    end
    if horizontal then
        return base * num_entries, base
    end
    return base, base * num_entries
end

local function new()
    local ret = wbase.make_widget()

    if created_systray then
        error("More than one systray created!")
    end
    created_systray = true

    ret.fit = fit
    ret.draw = draw
    ret.set_base_size = function(_, size) base_size = size end
    ret.set_horizontal = function(_, horiz) horizontal = horiz end

    capi.awesome.connect_signal("systray::update", function()
        ret:emit_signal("widget::updated")
    end)

    return ret
end

setmetatable(_M, { __call = function (_, ...) return new(...) end })

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
