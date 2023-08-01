local wibox = require("wibox")
local gtable = require("gears.table")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local helperUI = require("helpers.ui")

local M = {}

function M.mouse_hover(widget, hover_color, leave_color)
	widget:connect_signal("mouse::enter", function()
		local w = mouse.current_wibox
		if w then
			w.cursor = "hand2"
		end

		widget.stylesheet = "svg { fill: " .. (hover_color or beautiful.accent_color) .. " }"
	end)

	widget:connect_signal("mouse::leave", function()
		local w = mouse.current_wibox
		if w then
			w.cursor = "left_ptr"
		end
		widget.stylesheet = "svg { fill: " .. (leave_color or beautiful.fg_normal) .. " }"
	end)

	return widget
end

function M.clickable_widget(widget, hover_color, leave_color, on_click)
	widget:connect_signal("mouse::enter", function()
		local w = mouse.current_wibox
		if w then
			w.cursor = "hand2"
		end

		widget.stylesheet = "svg { fill: " .. (hover_color or beautiful.accent_color) .. " }"
	end)

	widget:connect_signal("mouse::leave", function()
		local w = mouse.current_wibox
		if w then
			w.cursor = "left_ptr"
		end
		widget.stylesheet = "svg { fill: " .. (leave_color or beautiful.accent_color) .. " }"
	end)

	if on_click ~= nil then
		widget:connect_signal("button::press", on_click)
	end

	return widget
end

function M.box(child)
	local widget = wibox.widget({
		{
			child,
			widget = wibox.container.margin,
			margins = {
				left = dpi(10),
				right = dpi(10),
			},
		},
		widget = wibox.container.background,
		shape = helperUI.rounded_shape(),
		bg = beautiful.bg_normal,
		border_color = beautiful.bg_focus,
		border_width = dpi(2),
	})

	return widget
end

function M.svg_template(image, color, id)
	return {
		{
			image = image,
			stylesheet = "svg { fill: " .. color .. " }",
			valign = "center",
			halign = "center",
			widget = wibox.widget.imagebox,
			id = id or "svg",
		},
		margins = dpi(5),
		widget = wibox.container.margin,
	}
end

function M.svg(image, color, id)
	local widget = wibox.widget(M.svg_template(image or nil, color or beautiful.accent_color, id or nil))

	function widget:change(new_image, new_color)
		self:change_image(new_image)
		self:change_fill(new_color)
	end

	function widget:change_fill(new_color)
		self:get_children_by_id(id or "svg")[1]:set_stylesheet("svg { fill: " .. new_color .. " }")
	end

	function widget:change_image(new_image)
		self:get_children_by_id(id or "svg")[1]:set_image(new_image)
	end

	return widget
end

function M.clickable_container(args)
	local container = wibox.widget({
		{
			args.widget,
			margins = args.margins or 0,
			widget = wibox.container.margin,
		},
		bg = args.bg or "#00000000",
		shape = args.shape or helperUI.rounded_shape(),
		widget = wibox.container.background,
	})
	container.focused = false

	helperUI.add_hover_cursor(container, "hand2")

	-- Hover bg change
	container:connect_signal("mouse::enter", function()
		container.bg = args.bg_focused or beautiful.bg_focus
	end)

	container:connect_signal("mouse::leave", function()
		if not container.focused then
			container.bg = args.bg or "#00000000"
		end
	end)

	container:connect_signal("button::press", function()
		container.bg = beautiful.bg_minimize
	end)

	if args.action then
		container:buttons(gtable.join(awful.button({}, 1, nil, args.action)))
	end

	return container
end

return M
