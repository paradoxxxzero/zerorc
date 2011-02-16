-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Widget and layout library
require("wibox")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
require("inotify")
require("revelation")
require("vicious")
require("rodentbane")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/zero/.config/awesome/themes/zero/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "emacs"
hostname = awful.util.pread("hostname"):gsub("\n", "")
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
   {
--   awful.layout.suit.floating,
   awful.layout.suit.tile,
   awful.layout.suit.tile.left,
   awful.layout.suit.tile.bottom,
   awful.layout.suit.tile.top,
   awful.layout.suit.fair,
   awful.layout.suit.fair.horizontal,
   awful.layout.suit.spiral,
   awful.layout.suit.spiral.dwindle,
   awful.layout.suit.max,
   awful.layout.suit.max.fullscreen,
   awful.layout.suit.magnifier
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
   -- Each screen has its own tag table.
   tags[s] = awful.tag({ "१", "२", "३", "४", "५", "६", "७", "८", "९" }, s, layouts[1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
				 }
		       })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })
-- }}}

-- {{{ Wibox
local function pastel(val)
   local rvalue, gvalue, bvalue
   if val > 50 then
      rvalue = 50 + (val * 45 / 100)
      gvalue = 45 + (val * 19 / 100)
      bvalue = 65 - (val *  3 / 100)
   else
      rvalue = 48 + (val *  2 / 100)
      gvalue = 74 - (val * 29 / 100)
      bvalue = 51 + (val * 14 / 100)
   end
   return string.format("#%x%x%x", rvalue, gvalue, bvalue)
end

separator = wibox.widget.textbox()
separator:set_markup('<span color="#666699"> ∿ </span>')

netW = wibox.widget.textbox()
local interface = "eth1"
if hostname == "arkozea" then
   interface = "eth0"
end
if hostname == "ark" then
   interface = "wlan0"
end

vicious.register(netW, vicious.widgets.net, '<span color="#CC9393"> ${' .. interface .. ' down_kb}⇂</span> <span color="#7F9F7F">↿${' .. interface .. ' up_kb}</span>', 3)

memW = wibox.widget.textbox()
vicious.cache(vicious.widgets.mem)
vicious.register(memW, vicious.widgets.mem, 
		 function (widget, args)
		    grey = 55 + args[1] * 2
		    grey2 = 55 + args[5] * 2
		    return string.format('<span color="#%x%x%x"> %d٪ </span><span color="#%x%x%x"> %d٪ </span>', grey, grey, grey, args[1], grey2, grey2, grey2, args[5])
		 end
		 , 13)

membar = awful.widget.progressbar()
membar:set_width(8)
membar:set_height(10)
membar:set_vertical(true)
membar:set_background_color("#222222")
membar:set_border_color(nil)
membar:set_color("#888888")
vicious.register(membar, vicious.widgets.mem, 
		 function (widget, args)
		    widget:set_color(pastel(args[1]))
		    return args[1] 
		 end
		 , 1)
swapbar = awful.widget.progressbar()
swapbar:set_width(8)
swapbar:set_height(10)
swapbar:set_vertical(true)
swapbar:set_background_color("#222222")
swapbar:set_border_color(nil)
swapbar:set_color("#888888")
vicious.register(swapbar, vicious.widgets.mem, 
		 function (widget, args)
		    widget:set_color(pastel(args[5]))
		    return args[5]
		 end
		 , 1)

cpuW = wibox.widget.textbox()
vicious.cache(vicious.widgets.cpu)
vicious.register(cpuW, vicious.widgets.cpu,
		 function (widget, args)
		    grey = 55 + args[1] * 2
			if hostname == "arkozea" then
		    		return string.format('<span color="#%x%x%x"> %d٪ %d٪ %d٪ %d٪ </span>', grey, grey, grey, args[2], args[3], args[4], args[5])
			else
		    		return string.format('<span color="#%x%x%x"> %d٪ %d٪ </span>', grey, grey, grey, args[2], args[3])
			end
		 end
		 , 1)

cpubar1 = awful.widget.progressbar()
cpubar1:set_width(8)
cpubar1:set_height(10)
cpubar1:set_vertical(true)
cpubar1:set_background_color("#222222")
cpubar1:set_border_color(nil)
cpubar1:set_color("#000000")
vicious.register(cpubar1, vicious.widgets.cpu, 
		 function (widget, args)
		    widget:set_color(pastel(args[2]))
		    return args[2]
		 end
		 , 3)

cpubar2 = awful.widget.progressbar()
cpubar2:set_width(8)
cpubar2:set_height(10)
cpubar2:set_vertical(true)
cpubar2:set_background_color("#222222")
cpubar2:set_border_color(nil)
cpubar2:set_color("#999999")
vicious.register(cpubar2, vicious.widgets.cpu, 
		 function (widget, args)
		    widget:set_color(pastel(args[3]))
		    return args[3]
		 end
		 , 3)

if hostname == "arkozea" then
   cpubar3 = awful.widget.progressbar()
   cpubar3:set_width(8)
   cpubar3:set_height(10)
   cpubar3:set_vertical(true)
   cpubar3:set_background_color("#222222")
   cpubar3:set_border_color(nil)
   cpubar3:set_color("#000000")
   vicious.register(cpubar3, vicious.widgets.cpu, 
		    function (widget, args)
		       widget:set_color(pastel(args[4]))
		       return args[4]
		    end
		    , 3)
   
   cpubar4 = awful.widget.progressbar()
   cpubar4:set_width(8)
   cpubar4:set_height(10)
   cpubar4:set_vertical(true)
   cpubar4:set_background_color("#222222")
   cpubar4:set_border_color(nil)
   cpubar4:set_color("#999999")
   vicious.register(cpubar2, vicious.widgets.cpu, 
		    function (widget, args)
		       widget:set_color(pastel(args[5]))
		       return args[5]
		    end
		    , 3)
end

temp1W = wibox.widget.textbox()
vicious.register(temp1W, vicious.widgets.thermal, 
		 function (widget, args)
		    grey = 55 + args[1] * 2
		    return string.format('<span color="#%x%x%x"> %d°</span>', grey, grey, grey, args[1])
		 end
		 , 13, { "coretemp.0", "core"})
temp2W = wibox.widget.textbox()
vicious.register(temp2W, vicious.widgets.thermal, 
		 function (widget, args)
		    grey = 55 + args[1] * 2
		    return string.format('<span color="#%x%x%x"> %d°</span>', grey, grey, grey, args[1])
		 end
		 , 11, { "coretemp.1", "core"})
pkgW = wibox.widget.textbox()
vicious.register(pkgW, vicious.widgets.pkg, "$1", 3601, "Arch")

   batW = wibox.widget.textbox()
   vicious.cache(vicious.widgets.bat)
   vicious.register(batW, vicious.widgets.bat,
		    function (widget, args)
		       grey = 200 - args[2] * 2
		       return string.format('<span color="#%x%x%x"> %s٪ </span>', grey, grey, grey, args[2])
		    end
		    , 1, "BAT0")

   batbar = awful.widget.progressbar()
   batbar:set_width(8)
   batbar:set_height(10)
   batbar:set_vertical(true)
   batbar:set_background_color("#222222")
   batbar:set_border_color(nil)
   batbar:set_color("#000000")
   vicious.register(batbar, vicious.widgets.bat, 
		    function (widget, args)
		       widget:set_color(pastel(args[2]))
		       return args[2]
		    end
		    , 3, "BAT0")


-- Create a textclock widget

mytextclock = wibox.widget.textbox()
vicious.register(mytextclock, vicious.widgets.date, "%d╱%m %H⚡%M⚡%S", 1)


-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
   awful.button({ }, 1, awful.tag.viewonly),
   awful.button({ modkey }, 1, awful.client.movetotag),
   awful.button({ }, 3, awful.tag.viewtoggle),
   awful.button({ modkey }, 3, awful.client.toggletag),
   awful.button({ }, 4, awful.tag.viewnext),
   awful.button({ }, 5, awful.tag.viewprev)
)
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
   awful.button({ }, 1, function (c)
			   if not c:isvisible() then
			      awful.tag.viewonly(c:tags()[1])
			   end
			   client.focus = c
			   c:raise()
			end),
   awful.button({ }, 3, function ()
			   if instance then
			      instance:hide()
			      instance = nil
			   else
			      instance = awful.menu.clients({ width=250 })
			   end
			end),
   awful.button({ }, 4, function ()
			   awful.client.focus.byidx(1)
			   if client.focus then client.focus:raise() end
			end),
   awful.button({ }, 5, function ()
			   awful.client.focus.byidx(-1)
			   if client.focus then client.focus:raise() end
			end))

for s = 1, screen.count() do
   -- Create a promptbox for each screen
   mypromptbox[s] = awful.widget.prompt()
   -- Create an imagebox widget which will contains an icon indicating which layout we're using.
   -- We need one layoutbox per screen.
   mylayoutbox[s] = awful.widget.layoutbox(s)
   mylayoutbox[s]:buttons(awful.util.table.join(
			     awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
			     awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
			     awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
			     awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
   -- Create a taglist widget
   mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

   -- Create a tasklist widget
   mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

   -- Create the wibox
   mywibox[s] = awful.wibox({ position = "top", screen = s })

   -- Widgets that are aligned to the left
   local left_layout = wibox.layout.fixed.horizontal()
   left_layout:add(mylauncher)
   left_layout:add(mytaglist[s])
   left_layout:add(mypromptbox[s])
   if s == 1 then left_layout:add(wibox.widget.systray()) end

   -- Widgets that are aligned to the right
   local right_layout = wibox.layout.fixed.horizontal()
   right_layout:add(netW)
   right_layout:add(separator)
   right_layout:add(memW)
   right_layout:add(membar)
   right_layout:add(swapbar)
   right_layout:add(separator)
   right_layout:add(cpuW)
   right_layout:add(cpubar1)
   right_layout:add(cpubar2)
   if hostname == "arkozea" then
      right_layout:add(cpubar3)
      right_layout:add(cpubar4)
   end
   right_layout:add(separator)
   right_layout:add(mytextclock)
   right_layout:add(separator)
   right_layout:add(temp1W)
   right_layout:add(temp2W)
   right_layout:add(separator)
   right_layout:add(pkgW)
   right_layout:add(separator)
   if hostname == "ark" then
      right_layout:add(batW)
      right_layout:add(batbar)
      right_layout:add(separator)
   end
   right_layout:add(mylayoutbox[s])

   -- Now bring it all together (with the tasklist in the middle)
   local layout = wibox.layout.align.horizontal()
   layout:set_left(left_layout)
   layout:set_middle(mytasklist[s])
   layout:set_right(right_layout)

   mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
		awful.button({ }, 3, function () mymainmenu:toggle() end),
		awful.button({ }, 4, awful.tag.viewnext),
		awful.button({ }, 5, awful.tag.viewprev),
		awful.button({ }, 8, function () awful.layout.inc(layouts,  1) end),
		awful.button({ }, 9, function (c) c:kill() end)
	  ))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
   awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
   awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
   awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
   awful.key({ modkey, "Shift"   }, "b", function () awful.util.spawn("setxkbmap fr oss") end),
   awful.key({ modkey, "Shift"   }, "a", function ()awful.util.spawn("setxkbmap fr bepo") end),
   awful.key({ modkey,           }, "<",
	     function ()
		rodentbane.start()
	     end),
   awful.key({ modkey,           }, "k",
	     function ()
		awful.client.focus.byidx(-1)
		if client.focus then client.focus:raise() end
	     end),
     awful.key({ modkey,         }, "b",
         function ()
             local allclients = client.get(mouse.screen)
             for _,c in ipairs(allclients) do
                 if c.minimized and c:tags()[mouse.screen] == 
awful.tag.selected(mouse.screen) then
                     c.minimized = false
                     client.focus = c
                     c:raise()
                     return
                 end
             end
         end),
   awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),
   awful.key({ modkey,           }, "0", function () awful.util.spawn("xscreensaver-command -lock") end),

   -- Layout manipulation
   awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
   awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
   awful.key({ modkey,           }, "agrave", function () awful.screen.focus_relative( 1) end),
   awful.key({ modkey, "Shift"   }, "agrave", function () awful.screen.focus_relative(-1) end),
   awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
   awful.key({ modkey,           }, "Tab",
	     function ()
		awful.client.focus.history.previous()
		if client.focus then
		   client.focus:raise()
		end
	     end),

   -- Standard program
   awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
   awful.key({ modkey, "Control" }, "r", awesome.restart),
   awful.key({ modkey, "Shift"   }, "q", awesome.quit),

   awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
   awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
   awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
   awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
   awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
   awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
   awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
   awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

   -- Prompt
   awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),
   awful.key({ modkey },            "x",     function ()
						awful.util.spawn("dmenu_run -i -b -fa 'monofur:pixelsize=16:antialias=true' -p 'Run command:' -nb '" .. 
								 beautiful.bg_normal .. "' -nf '" .. beautiful.fg_normal .. 
								 "' -sb '" .. beautiful.bg_focus .. 
								 "' -sf '" .. beautiful.fg_focus .. "'") 
					     end),
   awful.key({ modkey }, "c",
	     function ()
		awful.prompt.run({ prompt = "Run Lua code: " },
				 mypromptbox[mouse.screen].widget,
				 awful.util.eval, nil,
				 awful.util.getdir("cache") .. "/history_eval")
	     end),
   awful.key({ modkey }, "e",  revelation.revelation)

)

clientkeys = awful.util.table.join(
   awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
   awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
   awful.key({ modkey,           }, "i",      function (c) c:kill()                         end),
   awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
   awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
   awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
   awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
   awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
   awful.key({ modkey,           }, "m",
	     function (c)
		c.maximized_horizontal = not c.maximized_horizontal
		c.maximized_vertical   = not c.maximized_vertical
	     end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
   globalkeys = awful.util.table.join(globalkeys,
				      awful.key({ modkey }, "#" .. i + 9,
						function ()
						   local screen = mouse.screen
						   if tags[screen][i] then
						      awful.tag.viewonly(tags[screen][i])
						   end
						end),
				      awful.key({ modkey, "Control" }, "#" .. i + 9,
						function ()
						   local screen = mouse.screen
						   if tags[screen][i] then
						      awful.tag.viewtoggle(tags[screen][i])
						   end
						end),
				      awful.key({ modkey, "Shift" }, "#" .. i + 9,
						function ()
						   if client.focus and tags[client.focus.screen][i] then
						      awful.client.movetotag(tags[client.focus.screen][i])
						   end
						end),
				      awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
						function ()
						   if client.focus and tags[client.focus.screen][i] then
						      awful.client.toggletag(tags[client.focus.screen][i])
						   end
						end))
end

clientbuttons = awful.util.table.join(
   awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
   awful.button({ modkey }, 1, awful.mouse.client.move),
   awful.button({ modkey }, 3, awful.mouse.client.resize),
   awful.button({ }, 8, function () awful.layout.inc(layouts,  1) end),
   awful.button({ }, 9, function (c) c:kill() end))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
   -- All clients will match this rule.
   { rule = { },
     properties = { border_width = beautiful.border_width,
		    border_color = beautiful.border_normal,
		    focus = true,
		    keys = clientkeys,
		    buttons = clientbuttons } },
   { rule = { class = "MPlayer" },
     properties = { floating = true } },
   { rule = { class = "pinentry" },
     properties = { floating = true } },
   { rule = { class = "gimp" },
     properties = { floating = true } },
   -- Set Firefox to always map on tags number 2 of screen 1.
   -- { rule = { class = "Firefox" },
   --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
				   -- Enable sloppy focus
				   c:connect_signal("mouse::enter", function(c)
								       if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
								       and awful.client.focus.filter(c) then
								       client.focus = c
								    end
								 end)

				   if not startup then
				      -- Set the windows at the slave,
				      -- i.e. put it at the end of others instead of setting it master.
				      -- awful.client.setslave(c)

				      -- Put windows in a smart way, only if they does not set an initial position.
				      if not c.size_hints.user_position and not c.size_hints.program_position then
					 awful.placement.no_overlap(c)
					 awful.placement.no_offscreen(c)
				      end
				   end
				end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}


--- {{{ Naughty Notify Log

local logs = {
   logs    = { file = "/home/zero/.logs" },
   messages  = { file = "/var/log/messages.log" },
   syslog    = { file = "/var/log/syslog.log",
		 ignore = { "Changing fan level" },
	      },
}
local logs_quiet = nil
local logs_interval = 1

function log_watch()
  local events, nread, errno, errstr = inot:nbread()
  if events then
    for i, event in ipairs(events) do
      for logname, log in pairs(logs) do
        if event.wd == log.wd then log_changed(logname) end
      end
    end
  end
end

function log_changed(logname)
  local log = logs[logname]

  -- read log file
  local f = io.open(log.file)
  local l = f:read("*a")
  f:close()

  -- first read just set length
  if not log.len then
    log.len = #l

  -- if updated
  else
    local diff = l:sub(log.len +1, #l-1)

    -- check if ignored
    local ignored = false
    for i, phr in ipairs(log.ignore or {}) do
    if diff:find(phr) then ignored = true; break end
    end

    -- display log updates
    if not (ignored or logs_quiet) then
      naughty.notify{
        title = '<span color="white">' .. logname .. "</span>: " .. log.file,
        text = awful.util.escape(diff),
        hover_timeout = 0.2, timeout = 5,
      }
    end

    -- set last length
    log.len = #l
  end
end

local errno, errstr
inot, errno, errstr = inotify.init(true)
for logname, log in pairs(logs) do
  log_changed(logname)
  log.wd, errno, errstr = inot:add_watch(log.file, { "IN_MODIFY" })
end

mytimer = timer({ timeout = logs_interval })
mytimer:connect_signal("timeout", log_watch)
mytimer:start()


--- }}}
