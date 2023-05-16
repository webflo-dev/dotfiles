local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local helperUI = require("helpers.ui")
local base = require("themes.spring.widgets.base")

local bling = require("modules.bling")

local time_image = base.svg(beautiful.svg.clock, beautiful.colors.yellow)

local time_text = wibox.widget({
	widget = wibox.widget.textclock,
	format = helperUI.pango2("%H:%M", { weight = "bold", font = beautiful.font_size }),
	align = "center",
	valign = "center",
})

local args = {
	terminal = "kitty",
	favorites = { "edge", "slack" },
	-- background = beautiful.bg_normal,
	border_width = beautiful.border_width,
	border_color = beautiful.colors.lime,
	shape = helperUI.rounded_shape(),
	prompt_height = beautiful.uselss_gap,
	prompt_margins = dpi(5),
	prompt_paddings = dpi(5),
	prompt_shape = helperUI.rounded_shape(),
	prompt_color = beautiful.colors.sky,
	prompt_border_color = beautiful.colors.blue,
	prompt_text_color = beautiful.colors.bg,
	prompt_cursor_color = beautiful.colors.bg,
	prompt_font = beautiful.fonts.system,
	prompt_text = "",

	apps_per_row = 8,
	apps_per_column = 1,
	apps_margin = { left = dpi(20), right = dpi(20) },
	apps_spacing = dpi(10),

	app_shape = helperUI.rounded_shape(),
	app_name_font = beautiful.fonts.system,
}
local app_launcher = bling.widget.app_launcher(args)

bling.widget.window_switcher.enable({
	type = "thumbnail", -- set to anything other than "thumbnail" to disable client previews

	-- keybindings (the examples provided are also the default if kept unset)
	hide_window_switcher_key = "Escape", -- The key on which to close the popup
	minimize_key = "n", -- The key on which to minimize the selected client
	unminimize_key = "N", -- The key on which to unminimize all clients
	kill_client_key = "q", -- The key on which to close the selected client
	cycle_key = "Tab", -- The key on which to cycle through all clients
	previous_key = "Left", -- The key on which to select the previous client
	next_key = "Right", -- The key on which to select the next client
	vim_previous_key = "h", -- Alternative key on which to select the previous client
	vim_next_key = "l", -- Alternative key on which to select the next client

	cycleClientsByIdx = awful.client.focus.byidx, -- The function to cycle the clients
	filterClients = awful.widget.tasklist.filter.currenttags, -- The function to filter the viewed clients
})

local buttons = awful.button({}, 1, function()
	app_launcher:toggle()
	-- awesome.emit_signal("bling::window_switcher::turn_on")
end)

local time = wibox.widget({
	time_image,
	time_text,
	layout = wibox.layout.fixed.horizontal,
	spacing = dpi(10),
	buttons = buttons,
})

return base.box(time)
