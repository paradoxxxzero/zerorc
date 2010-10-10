---------------------------------------------------------------------------
-- @author Julien Danjou &lt;julien@danjou.info&gt;
-- @copyright 2009 Julien Danjou
-- @release v3.4-440-g38d4602
---------------------------------------------------------------------------

local setmetatable = setmetatable
local ipairs = ipairs
local button = require("awful.button")
local layout = require("awful.layout")
local tag = require("awful.tag")
local beautiful = require("beautiful")
local imagebox = require("wibox.widget.imagebox")
local capi = { oocairo = oocairo }

--- Layoutbox widget.
module("awful.widget.layoutbox")

local function update(w, screen)
    local layout = layout.getname(layout.get(screen))
    w:set_image(layout and beautiful["layout_" .. layout])
end

--- Create a layoutbox widget. It draws a picture with the current layout
-- symbol of the current tag.
-- @param screen The screen number that the layout will be represented for.
-- @return An imagebox widget configured as a layoutbox.
function new(screen)
    local screen = screen or 1
    local w = imagebox()
    update(w, screen)

    local function update_on_tag_selection(tag)
        return update(w, tag.screen)
    end

    tag.attached_connect_signal(screen, "property::selected", update_on_tag_selection)
    tag.attached_connect_signal(screen, "property::layout", update_on_tag_selection)

    return w
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
