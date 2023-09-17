local wibox = require("wibox")
local gobject = require("gears.object")
local gtable = require("gears.table")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local tpl = require("ui.templates")
local ui = require("ui.utils")
local utils = require("utils.widget")

local daemon = require("daemons.playerctl")

local controls = {
	play_pause = {
		image = beautiful.svg.play,
		on_click = function(player_instance)
			return function()
				daemon:play_pause(player_instance)
			end
		end,
	},
	forward = {
		image = beautiful.svg.forward,
		on_click = function(player_instance)
			return function()
				daemon:next(player_instance)
			end
		end,
	},
	backward = {
		image = beautiful.svg.backward,
		on_click = function(player_instance)
			return function()
				daemon:previous(player_instance)
			end
		end,
	},
}

local function actions(id)
	local M = {}

	function M:set_pause()
		self:get_children_by_id(id)[1].image = beautiful.svg.pause
	end

	function M:set_play()
		self:get_children_by_id(id)[1].image = beautiful.svg.play
	end

	return M
end

local function new(args)
	args.image = controls[args.type].image
	args.forced_width = args.size
	args.forced_height = args.size
	local widget = wibox.widget(tpl.svg(args))
	widget.id = args.id

	widget:connect_signal("mouse::enter", function(self)
		ui.mouse_hover_cursor(true)
		self:get_children_by_id(args.id)[1].stylesheet = ui.stylesheet_color(beautiful.accent_color)
	end)

	widget:connect_signal("mouse::leave", function(self)
		ui.mouse_hover_cursor(false)
		self:get_children_by_id(args.id)[1].stylesheet = ui.stylesheet_color(beautiful.fg_normal)
	end)

	widget:connect_signal("button::press", controls[args.type].on_click(args.player_instance))

	local btn_actions = actions(args.id)

	return gtable.crush(widget, btn_actions, true)
end

return utils.factory(new)
