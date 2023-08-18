local awful = require("awful")
local wibox = require("wibox")
local gtable = require("gears.table")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local ui = require("ui.utils")
local tpl = require("ui.templates")
local utils = require("utils.widget")

local colors = {
	connected = beautiful.colors.yellow,
	connecting = beautiful.colors.orange,
	disconnected = beautiful.colors.red,
	unmanaged = beautiful.colors.gray,
}

local device = {}

function device:update_info(updated_priv)
	self._priv.data = gtable.crush(self._priv.data, updated_priv)

	self:get_children_by_id("w_icon")[1].stylesheet =
		ui.stylesheet_color(colors[self._priv.data.state] or beautiful.colors.gray)

	self._priv.tooltip.text = string.format(
		"Device: %s\nType: %s\nState: %s\nConnection: %s",
		self._priv.data.device,
		self._priv.data.type,
		self._priv.data.state,
		self._priv.data.connection
	)
end

local function new(data)
	local widget = wibox.widget({
		tpl.svg({
			image = beautiful.svg.ethernet.connected,
			color = ui.stylesheet_color(colors[data.state]),
			id = "w_icon",
		}),
		layout = wibox.layout.fixed.horizontal,
	})
	widget.id = data.device

	widget._priv = {}

	widget._priv.data = data
	widget._priv.tooltip = awful.tooltip({
		objects = { widget },
		mode = "outside",
		margins = dpi(10),
	})

	return gtable.crush(widget, device, true)

	-- return widget
end

return utils.factory(new)
