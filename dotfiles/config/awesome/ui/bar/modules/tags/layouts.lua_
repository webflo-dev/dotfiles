local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local ui = require("ui.utils")
local tpl = require("ui.templates")

local function create_template()
	local template = wibox.widget({
		{
			{
				{
					id = "icon_role",
					widget = wibox.widget.imagebox,
				},
				{
					id = "text_role",
					widget = wibox.widget.textbox,
				},
				spacing = dpi(16),
				layout = wibox.layout.fixed.horizontal,
			},
			margins = dpi(12),
			widget = wibox.container.margin,
		},
		id = "background_role",
		forced_width = dpi(200),
		forced_height = dpi(64),
		widget = wibox.container.background,
	})

	-- template:connect_signal("mouse:enter", function(self)
	-- 	self.bg = beautiful.colors.sky
	-- end)
	-- template:connect_signal("mouse::leave", function(self)
	-- 	self.bg = beautiful.colors.orange
	-- end)

	return template
end

local function create_widget(screen)
	local layout_box = awful.widget.layoutbox(screen)

	local widget = wibox.widget({
		{
			{
				widget = wibox.widget(tpl.wibar_module({
					{
						forced_height = dpi(24),
						forced_width = dpi(24),
						widget = layout_box,
					},
					widget = wibox.container.place,
				})),
				bg_focused = beautiful.colors.sky,
			},
			widget = wibox.container.margin,
		},
		bg = "#00000000",
		shape = ui.rounded_rect,
		widget = wibox.container.background,
	})
	widget.focused = false

	widget:connect_signal("mouse::enter", function()
		widget.bg = beautiful.colors.sky
	end)

	widget:connect_signal("mouse::leave", function()
		if not widget.focused then
			widget.bg = "#00000000"
		end
	end)

	widget:connect_signal("button::press", function()
		widget.bg = beautiful.bg_minimize
	end)

	local layout_list = awful.widget.layoutlist({
		base_layout = wibox.widget({
			spacing = dpi(4),
			forced_num_cols = 4,
			layout = wibox.layout.flex.vertical,
			-- layout = wibox.layout.grid.vertical,
		}),
		widget_template = create_template,
	})

	local popup = awful.popup(tpl.popup({
		widget = layout_list,
	}))

	popup:bind_to_widget(layout_box)
	return widget
end

return create_widget
