local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local helperUI = require("helpers.ui")
local base = require("themes.spring.widgets.base")

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

	local widget = base.clickable_container({
		widget = base.box({
			{
				forced_height = dpi(24),
				forced_width = dpi(24),
				widget = layout_box,
			},
			widget = wibox.container.place,
		}),
		bg_focused = beautiful.colors.sky,
	})

	local layout_list = awful.widget.layoutlist({
		base_layout = wibox.widget({
			spacing = dpi(4),
			forced_num_cols = 4,
			layout = wibox.layout.flex.vertical,
			-- layout = wibox.layout.grid.vertical,
		}),
		widget_template = create_template,
	})

	local popup = awful.popup({
		widget = wibox.widget({
			layout_list,
			margins = dpi(12),
			widget = wibox.container.margin,
		}),
		shape = gears.shape.infobubble,
		border_width = dpi(2),
		border_color = beautiful.colors.lime,
		preferred_anchors = "middle",
		ontop = true,
		visible = false,
		hide_on_right_click = true,
	})

	popup:bind_to_widget(layout_box)
	return widget
end

return create_widget
