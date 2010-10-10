---------------------------------------------------------------------------
-- @author Julien Danjou &lt;julien@danjou.info&gt;
-- @copyright 2009 Julien Danjou
-- @release v3.4-440-g38d4602
---------------------------------------------------------------------------

local setmetatable = setmetatable

local completion = require("awful.completion")
local util = require("awful.util")
local prompt = require("awful.prompt")
local widget_base = require("wibox.widget.base")
local textbox = require("wibox.widget.textbox")
local type = type

module("awful.widget.prompt")

--- Run method for promptbox.
-- @param promptbox The promptbox to run.
local function run(promptbox)
    return prompt.run({ prompt = promptbox.prompt },
                      promptbox.widget,
                      function (...)
                          local result = util.spawn(...)
                          if type(result) == "string" then
                              promptbox.widget.text = result
                          end
                      end,
                      completion.shell,
                      util.getdir("cache") .. "/history")
end

--- Create a prompt widget which will launch a command.
-- @param args Arguments table. "prompt" is the prompt to use.
-- @return A launcher widget.
function new(args)
    local args = args or {}
    local widget = textbox()
    local promptbox = widget_base.make_widget(widget)

    promptbox.widget = widget
    promptbox.widget:set_ellipsize("start")
    promptbox.run = run
    promptbox.prompt = args.prompt or "Run: "
    return promptbox
end

setmetatable(_M, { __call = function (_, ...) return new(...) end })

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
