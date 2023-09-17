local gtable = require("gears.table")
local beautiful = require("beautiful")

local ui = require("ui.utils")

local daemon = require("daemons.playerctl")

local controls = {
	play = {
		image = beautiful.svg.play,
	},
	pause = {
		image = beautiful.svg.pause,
	},
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

local api = {}
function api:toggle_play_pause(playback_status)
	if playback_status == "PLAYING" then
		self.image = controls.pause.image
	else
		self.image = controls.play.image
	end
end

local function apply(_widget, args)
	_widget.image = controls[args.type].image
	_widget:connect_signal("mouse::enter", function()
		ui.mouse_hover_cursor(true)
		_widget.stylesheet = ui.stylesheet_color(beautiful.accent_color)
	end)

	_widget:connect_signal("mouse::leave", function()
		ui.mouse_hover_cursor(false)
		_widget.stylesheet = ui.stylesheet_color(beautiful.fg_normal)
	end)

	_widget:connect_signal("button::press", controls[args.type].on_click(args.player_instance))

	return gtable.crush(_widget, api, true)
end

return function(widget, args)
	if args.backward then
		local _widget = widget:get_children_by_id(args.backward)[1]
		apply(_widget, { id = args.backward, type = "backward", player_instance = args.player_instance })
	end

	if args.play_pause then
		local _widget = widget:get_children_by_id(args.play_pause)[1]
		apply(_widget, { id = args.play_pause, type = "play_pause", player_instance = args.player_instance })
	end

	if args.forward then
		local _widget = widget:get_children_by_id(args.forward)[1]
		apply(_widget, { id = args.forward, type = "forward", player_instance = args.player_instance })
	end
end
