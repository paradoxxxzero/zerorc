---------------------------
-- Default awesome theme --
---------------------------

theme = {}

theme.font          = "monofur 11"

theme.bg_normal     = "#222222"
theme.bg_focus      = "#333333"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"

theme.fg_normal     = "#999999"
theme.fg_focus      = "#dddddd"
theme.fg_urgent     = "#ffaaaa"
theme.fg_minimize   = "#bbbbbb"

theme.border_width  = "1"
theme.border_normal = "#000000"
theme.border_focus  = "#535d6c"
theme.border_marked = "#91231c"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

theme.taglist_fg_focus  = "#ffffff"

-- Display the taglist squares
theme.taglist_squares_sel   = awful.util.getdir("config") .. "/themes/zero/taglist/squarefw.png"
theme.taglist_squares_unsel = awful.util.getdir("config") .. "/themes/zero/taglist/squarew.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = awful.util.getdir("config") .. "/themes/zero/submenu.png"
theme.menu_height = "15"
theme.menu_width  = "100"

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = awful.util.getdir("config") .. "/themes/zero/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = awful.util.getdir("config") .. "/themes/zero/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = awful.util.getdir("config") .. "/themes/zero/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = awful.util.getdir("config") .. "/themes/zero/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = awful.util.getdir("config") .. "/themes/zero/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = awful.util.getdir("config") .. "/themes/zero/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = awful.util.getdir("config") .. "/themes/zero/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = awful.util.getdir("config") .. "/themes/zero/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = awful.util.getdir("config") .. "/themes/zero/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = awful.util.getdir("config") .. "/themes/zero/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = awful.util.getdir("config") .. "/themes/zero/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = awful.util.getdir("config") .. "/themes/zero/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = awful.util.getdir("config") .. "/themes/zero/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = awful.util.getdir("config") .. "/themes/zero/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = awful.util.getdir("config") .. "/themes/zero/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = awful.util.getdir("config") .. "/themes/zero/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = awful.util.getdir("config") .. "/themes/zero/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = awful.util.getdir("config") .. "/themes/zero/titlebar/maximized_focus_active.png"

-- You can use your own command to set your wallpaper
theme.wallpaper_cmd = { "awsetbg " .. awful.util.getdir("config") .. "/themes/zero/background.png" }

-- You can use your own layout icons like this:
theme.layout_fairh = awful.util.getdir("config") .. "/themes/zero/layouts/fairhw.png"
theme.layout_fairv = awful.util.getdir("config") .. "/themes/zero/layouts/fairvw.png"
theme.layout_floating  = awful.util.getdir("config") .. "/themes/zero/layouts/floatingw.png"
theme.layout_magnifier = awful.util.getdir("config") .. "/themes/zero/layouts/magnifierw.png"
theme.layout_max = awful.util.getdir("config") .. "/themes/zero/layouts/maxw.png"
theme.layout_fullscreen = awful.util.getdir("config") .. "/themes/zero/layouts/fullscreenw.png"
theme.layout_tilebottom = awful.util.getdir("config") .. "/themes/zero/layouts/tilebottomw.png"
theme.layout_tileleft   = awful.util.getdir("config") .. "/themes/zero/layouts/tileleftw.png"
theme.layout_tile = awful.util.getdir("config") .. "/themes/zero/layouts/tilew.png"
theme.layout_tiletop = awful.util.getdir("config") .. "/themes/zero/layouts/tiletopw.png"
theme.layout_spiral  = awful.util.getdir("config") .. "/themes/zero/layouts/spiralw.png"
theme.layout_dwindle = awful.util.getdir("config") .. "/themes/zero/layouts/dwindlew.png"

theme.awesome_icon =  awful.util.getdir("config") .. "/icons/awesome32.png"

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
