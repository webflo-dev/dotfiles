local naughty = require("naughty")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

local dpi = beautiful.xresources.apply_dpi

local helperUI = require("helpers.ui")

naughty.config.spacing = 10
naughty.config.padding = 10

naughty.config.defaults.margin = 20
naughty.config.defaults.border_width = 0
naughty.config.defaults.timeout = 5
naughty.config.defaults.margin = 10

naughty.config.presets.low.timeout = 2
naughty.config.presets.critical.timeout = 12

naughty.config.presets.normal.bg = beautiful.bg_normal
naughty.config.presets.normal.fg = beautiful.fg_normal

local function icon_widget(args)
	return {
		{
			image = args.icon,
			valign = "center",
			forced_width = args.size or dpi(28),
			forced_height = args.size or dpi(28),
			widget = wibox.widget.imagebox,
		},
		margins = dpi(8),
		widget = wibox.container.margin,
	}
end

local function title_widget(args)
	local has_app_name = args.app_name and args.app_name ~= ""

	return wibox.widget({
		{
			markup = "<b>" .. args.title .. "</b>" .. (has_app_name and " • " .. args.app_name or ""),
			font = helperUI.font(args.size or "11"),
			align = "left",
			valign = "center",
			widget = naughty.widget.title,
		},
		step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
		speed = 40,
		forced_width = args.forced_width,
		widget = wibox.container.scroll.horizontal,
	})
end

local function message_widget(notification)
	local message_body = wibox.widget({
		notification = notification,
		font = helperUI.font(),
		ellipsize = "none",
		widget = naughty.widget.message,
	})

	return message_body
end

local function actions_widget(notification)
	local actions = wibox.widget({
		notification = notification,
		base_layout = wibox.widget({
			spacing = dpi(4),
			layout = wibox.layout.flex.horizontal,
		}),
		widget_template = {
			{
				{
					id = "text_role",
					widget = wibox.widget.textbox,
				},
				layout = wibox.container.place,
			},
			id = "background_role",
			widget = wibox.container.background,
		},
		style = {
			underline_normal = false,
			underline_selected = true,
			bg_normal = beautiful.bg_normal,
			bg_selected = beautiful.bg_focus,
			shape_normal = helperUI.rounded_shape(beautiful.radius / 4),
		},
		forced_height = dpi(25),
		widget = naughty.list.actions,
	})

	helperUI.add_hover_cursor(actions, "hand2")

	return {
		actions,
		shape = helperUI.rounded_shape(beautiful.radius / 2),
		visible = notification.actions and #notification.actions > 0,
		widget = wibox.container.background,
	}
end

naughty.connect_signal("request::display", function(notification)
	require("gears.debug").dump(notification)
	require("gears.debug").dump({ icon = notification.icon })

	local template = {
		{
			icon_widget({
				icon = notification.icon,
				size = dpi(32),
			}),
			bg = beautiful.colors.black,
			widget = wibox.container.background,
		},
		{
			{
				{
					title_widget({
						title = notification.title,
						app_name = notification.app_name,
						size = 12,
						forced_width = dpi(188),
					}),
					{
						markup = os.date("%H:%M"),
						font = helperUI.font("11"),
						align = "right",
						widget = wibox.widget.textbox,
					},
					spacing = dpi(12),
					layout = wibox.layout.fixed.horizontal,
				},
				message_widget(notification),
				actions_widget(notification),
				spacing = dpi(8),
				layout = wibox.layout.fixed.vertical,
			},
			left = dpi(12),
			right = dpi(12),
			top = dpi(8),
			bottom = dpi(8),
			widget = wibox.container.margin,
		},
		layout = wibox.layout.fixed.horizontal,
		widget = wibox.container.background,
	}

	naughty.layout.box({
		notification = notification,
		type = "notification",
		border_color = beautiful.notification_border_color,
		border_width = dpi(2),
		maximum_width = dpi(320),
		widget_template = template,
		shape = helperUI.rounded_shape(),
	})
end)
