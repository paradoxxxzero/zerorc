---------------------------------------------------------------------------
-- @author Julien Danjou &lt;julien@danjou.info&gt;
-- @copyright 2008-2009 Julien Danjou
-- @release v3.4-440-g38d4602
---------------------------------------------------------------------------

-- Grab environment we need
local math = math
local type = type
local ipairs = ipairs
local pairs = pairs
local setmetatable = setmetatable
local capi = { button = button }
local util = require("awful.util")
local imagebox = require("wibox.widget.imagebox")
local textbox = require("wibox.widget.textbox")

local common = {}

-- Recursively processes a template, replacing the tables representing the icon and
-- the title with the widgets ib and tb
local function replace_in_template(t, ib, tb)
    for i, v in ipairs(t) do
        if type(t[i]) == "table" then
            if v.item == "icon" then
                t[i] = ib
            elseif v.item == "title" then
                t[i] = tb
            else
                replace_in_template(v, ib, tb)
            end
        end
    end
end

function common.list_update(w, buttons, label, data, objects)
    -- Hack: if it has been registered as a widget in a wibox,
    -- it's w.len since __len meta does not work on table until Lua 5.2.
    -- Otherwise it's standard #w.
    local len = (w.len or #w)

    -- Remove excessive widgets
    if len > #objects then
        for i = #objects, len do
            w[i] = nil
        end
    end

    -- update the widgets, creating them if needed
    w:reset()
    for i, o in ipairs(objects) do
        local ib = wibox.widget.imagebox()
        local tb = wibox.widget.textbox()
        local bgb = wibox.widget.background()
        local m = wibox.layout.margin(tb, 4, 4)
        local l = wibox.layout.fixed.horizontal()

        -- All of this is added in a fixed widget
        l:fill_space(true)
        l:add(ib)
        l:add(m)

        -- And all of this gets a background
        bgb:set_widget(l)
        w:add(bgb)

        if buttons then
            -- Use a local variable so that the garbage collector doesn't strike
            -- between now and the :buttons() call.
            local btns = data[o]
            if not btns then
                btns = {}
                data[o] = btns
                for kb, b in ipairs(buttons) do
                    -- Create a proxy button object: it will receive the real
                    -- press and release events, and will propagate them the the
                    -- button object the user provided, but with the object as
                    -- argument.
                    local btn = capi.button { modifiers = b.modifiers, button = b.button }
                    btn:connect_signal("press", function () b:emit_signal("press", o) end)
                    btn:connect_signal("release", function () b:emit_signal("release", o) end)
                    btns[#btns + 1] = btn
                end
            end
            bgb:buttons(btns)
        end

        local text, bg, bg_image, icon = label(o)
        tb:set_markup(text)
        bgb:set_bg(bg)
        bgb:set_bgimage(bg_image)
        ib:set_image(icon)
   end
end

return common

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
