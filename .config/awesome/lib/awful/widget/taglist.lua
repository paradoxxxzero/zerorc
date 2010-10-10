---------------------------------------------------------------------------
-- @author Julien Danjou &lt;julien@danjou.info&gt;
-- @copyright 2008-2009 Julien Danjou
-- @release v3.4-440-g38d4602
---------------------------------------------------------------------------

-- Grab environment we need
local capi = { screen = screen,
               oocairo = oocairo,
               client = client }
local type = type
local setmetatable = setmetatable
local pairs = pairs
local ipairs = ipairs
local table = table
local common = require("awful.widget.common")
local util = require("awful.util")
local tag = require("awful.tag")
local beautiful = require("beautiful")
local fixed = require("wibox.layout.fixed")

--- Taglist widget module for awful
module("awful.widget.taglist")

filter = {}

function taglist_label(t, args)
    if not args then args = {} end
    local theme = beautiful.get()
    local fg_focus = args.fg_focus or theme.taglist_fg_focus or theme.fg_focus
    local bg_focus = args.bg_focus or theme.taglist_bg_focus or theme.bg_focus
    local fg_urgent = args.fg_urgent or theme.taglist_fg_urgent or theme.fg_urgent
    local bg_urgent = args.bg_urgent or theme.taglist_bg_urgent or theme.bg_urgent
    local taglist_squares_sel = args.squares_sel or theme.taglist_squares_sel
    local taglist_squares_unsel = args.squares_unsel or theme.taglist_squares_unsel
    local taglist_squares_resize = theme.taglist_squares_resize or args.squares_resize or "true"
    local font = args.font or theme.taglist_font or theme.font or ""
    local text = "<span font_desc='"..font.."'>"
    local sel = capi.client.focus
    local bg_color = nil
    local fg_color = nil
    local bg_image
    local icon
    local bg_resize = false
    local is_selected = false
    if t.selected then
        bg_color = bg_focus
        fg_color = fg_focus
    end
    if sel then
        if taglist_squares_sel then
            -- Check that the selected clients is tagged with 't'.
            local seltags = sel:tags()
            for _, v in ipairs(seltags) do
                if v == t then
                    bg_image = capi.oocairo.image_surface_create_from_png(taglist_squares_sel)
                    bg_resize = taglist_squares_resize == "true"
                    is_selected = true
                    break
                end
            end
        end
    end
    if not is_selected then
        local cls = t:clients()
        if #cls > 0 and taglist_squares_unsel then
            bg_image = capi.oocairo.image_surface_create_from_png(taglist_squares_unsel)
            bg_resize = taglist_squares_resize == "true"
        end
        for k, c in pairs(cls) do
            if c.urgent then
                if bg_urgent then bg_color = bg_urgent end
                if fg_urgent then fg_color = fg_urgent end
                break
            end
        end
    end
    if not tag.getproperty(t, "icon_only") then
        if fg_color then
            text = text .. "<span color='"..util.color_strip_alpha(fg_color).."'>" ..
                (util.escape(t.name) or "") .. "</span>"
        else
            text = text .. (util.escape(t.name) or "")
        end
    end
    text = text .. "</span>"
    if tag.geticon(t) and type(tag.geticon(t)) == "image" then
        icon = tag.geticon(t)
    elseif tag.geticon(t) then
        icon = capi.oocairo.image_surface_create_from_png(tag.geticon(t))
    end

    return text, bg_color, bg_image, icon
end

local function taglist_update(s, w, buttons, filter, data, style)
    local tags = {}
    for k, t in ipairs(capi.screen[s]:tags()) do
        if not tag.getproperty(t, "hide") and filter(t) then
            table.insert(tags, t)
        end
    end

    local function label(c) return taglist_label(c, style) end

    common.list_update(w, buttons, label, data, tags)
end

--- Get the tag object the given widget appears on.
-- @param widget The widget the look for.
-- @return The tag object.
function gettag(widget)
    return common.tagwidgets[widget]
end

--- Create a new taglist widget.
-- @param screen The screen to draw taglist for.
-- @param filter Filter function to define what clients will be listed.
-- @param buttons A table with buttons binding to set.
-- @param style The style overrides default theme.
-- bg_focus The background color for focused client.
-- fg_focus The foreground color for focused client.
-- bg_urgent The background color for urgent clients.
-- fg_urgent The foreground color for urgent clients.
-- squares_sel Optional: a user provided image for selected squares.
-- squares_unsel Optional: a user provided image for unselected squares.
-- squares_resize Optional: true or false to resize squares.
-- font The font.
function new(screen, filter, buttons, style)
    local w = fixed.horizontal()

    local data = setmetatable({}, { __mode = 'vk' })
    local u = function (s)
        if s == screen then
            taglist_update(s, w, buttons, filter, data, style)
        end
    end
    local uc = function (c) return u(c.screen) end
    capi.client.connect_signal("focus", uc)
    capi.client.connect_signal("unfocus", uc)
    tag.attached_connect_signal(screen, "property::selected", uc)
    tag.attached_connect_signal(screen, "property::icon", uc)
    tag.attached_connect_signal(screen, "property::hide", uc)
    tag.attached_connect_signal(screen, "property::name", uc)
    capi.screen[screen]:connect_signal("tag::attach", function(screen, tag)
            u(screen.index)
        end)
    capi.screen[screen]:connect_signal("tag::detach", function(screen, tag)
            u(screen.index)
        end)
    capi.client.connect_signal("property::urgent", uc)
    capi.client.connect_signal("property::screen", function(c)
        -- If client change screen, refresh it anyway since we don't from
        -- which screen it was coming :-)
        u(screen)
    end)
    capi.client.connect_signal("tagged", uc)
    capi.client.connect_signal("untagged", uc)
    capi.client.connect_signal("unmanage", uc)
    u(screen)
    return w
end

--- Filtering function to include all nonempty tags on the screen.
-- @param t The tag.
-- @param screen The screen we are drawing on.
-- @return true if t is not empty, else false
function filter.noempty(t, args)
    if #t:clients() > 0 or t.selected then
        return true
    end

    return false
end

--- Filtering function to include all tags on the screen.
-- @param t The tag.
-- @param screen The screen we are drawing on.
-- @return true
function filter.all(t, args)
    return true
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
