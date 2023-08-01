local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi

local helperString = require("helpers.string")
local helperUI = require("helpers.ui")
local base = require("themes.spring.widgets.base")

local overmind = require("signals").overmind

local widget = wibox.widget({
	{
		{
			base.svg_template(beautiful.svg.rocket, beautiful.colors.light, "w_icon"),
			layout = wibox.layout.fixed.horizontal,
			spacing = dpi(10),
		},
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
	visible = true,
})

local process_widget_list = wibox.widget({
	layout = wibox.layout.fixed.vertical,
})

local popup = awful.popup({
	preferred_anchors = "middle",
	ontop = true,
	visible = false,
	shape = gears.shape.rounded_rect,
	border_width = beautiful.border_width,
	border_color = beautiful.colors.sky,
	-- hide_on_right_click = true,
	offset = { y = 5 },
	widget = {
		spacing = dpi(5),
		widget = wibox.container.background,
		{
			margins = dpi(8),
			layout = wibox.container.margin,
			process_widget_list,
		},
	},
})

local function build_process_widget(new_process)
	local widget = wibox.widget({
		{
			{
				{
					helperUI.force_size(base.svg_template(beautiful.svg.spinner, beautiful.fg_normal, "w_icon_status")),
					margins = dpi(8),
					layout = wibox.container.margin,
				},
				{
					{
						{
							markup = new_process.name,
							font = beautiful.fonts.system,
							widget = wibox.widget.textbox,
							valign = "center",
							halign = "center",
							id = "w_name",
						},
						widget = wibox.container.margin,
						margins = dpi(8),
					},
					forced_width = dpi(100),
					layout = wibox.layout.fixed.horizontal,
				},
				{
					id = "w_controls",
					forced_width = 90,
					valign = "center",
					halign = "center",
					layout = wibox.container.place,
				},
				spacing = dpi(8),
				layout = wibox.layout.align.horizontal,
			},
			margins = dpi(8),
			layout = wibox.container.margin,
		},
		bg = beautiful.bg_normal,
		widget = wibox.container.background,
	})
	widget.id = new_process.name

	function widget:update_info(updated_process, new_widget)
		if updated_process.running and (new_widget == true or not self.__running) then
			local w_btn_stop = wibox.widget(helperUI.force_size({
				image = beautiful.svg.stop,
				stylesheet = "svg { fill: " .. beautiful.fg_normal .. " }",
				valign = "center",
				halign = "center",
				widget = wibox.widget.imagebox,
			}))

			base.mouse_hover(w_btn_stop, beautiful.svg.accent_color, beautiful.colors.light)

			w_btn_stop:connect_signal("button::press", function()
				local w_icon_status = self:get_children_by_id("w_icon_status")[1]
				w_icon_status.image = beautiful.svg.spinner
				w_icon_status.stylesheet = "svg { fill: " .. beautiful.fg_normal .. " }"
				self:get_children_by_id("w_controls")[1]:setup(nil)
				overmind.stop_process(updated_process.name)
			end)

			local w_btn_log = wibox.widget(helperUI.force_size({
				image = beautiful.svg.file,
				stylesheet = "svg { fill: " .. beautiful.fg_normal .. " }",
				valign = "center",
				halign = "center",
				widget = wibox.widget.imagebox,
			}))

			base.mouse_hover(w_btn_log, beautiful.svg.accent_color, beautiful.colors.light)

			w_btn_log:connect_signal("button::press", function()
				overmind.log_process(updated_process.name)
			end)

			self:get_children_by_id("w_controls")[1]:setup({
				layout = wibox.layout.align.horizontal,
				{
					w_btn_log,
					margins = dpi(5),
					widget = wibox.container.margin,
				},
				{
					w_btn_stop,
					margins = dpi(5),
					widget = wibox.container.margin,
				},
			})
		elseif not updated_process.running and (new_widget == true or self.__running) then
			local w_btn_start = wibox.widget(helperUI.force_size({
				image = beautiful.svg.play,
				stylesheet = "svg { fill: " .. beautiful.fg_normal .. " }",
				valign = "center",
				halign = "center",
				widget = wibox.widget.imagebox,
				id = "w_btn_start",
			}))

			base.mouse_hover(w_btn_start, beautiful.svg.accent_color, beautiful.colors.light)

			w_btn_start:connect_signal("button::press", function()
				local w_icon_status = self:get_children_by_id("w_icon_status")[1]
				w_icon_status.image = beautiful.svg.spinner
				w_icon_status.stylesheet = "svg { fill: " .. beautiful.fg_normal .. " }"
				self:get_children_by_id("w_controls")[1]:setup(nil)
				overmind.start_process(updated_process.name)
			end)

			self:get_children_by_id("w_controls")[1]:setup({
				layout = wibox.layout.align.horizontal,
				{
					w_btn_start,
					margins = dpi(5),
					widget = wibox.container.margin,
				},
			})
		end

		local w_icon = self:get_children_by_id("w_icon_status")[1]
		if updated_process.status == "running" then
			w_icon.image = beautiful.svg.check
			w_icon.stylesheet = "svg { fill: " .. beautiful.colors.green .. " }"
		else
			w_icon.image = beautiful.svg.xmark
			w_icon.stylesheet = "svg { fill: " .. beautiful.colors.red .. " }"
		end

		self.__running = updated_process.running
	end

	return widget
end

local all_process = {}

local function find_widget(id)
	for _, value in ipairs(process_widget_list.children) do
		if value.id == id then
			return value
		end
	end
	return nil
end

awesome.connect_signal("signals::overmind::process", function(process)
	local existing_process_widget = find_widget(process.name)
	if not existing_process_widget then
		local process_widget = build_process_widget(process)
		process_widget_list:add(process_widget)
		process_widget:update_info(process, true)
	else
		existing_process_widget:update_info(process)
	end
end)

awesome.connect_signal("signals::overmind::all", function(status)
	local color = beautiful.colors.light
	if status == "running" then
		color = beautiful.colors.green
	elseif status == "incomplete" then
		color = beautiful.colors.orange
	elseif status == "stopped" then
		color = beautiful.colors.red
	end
	widget:get_children_by_id("w_icon")[1].stylesheet = "svg { fill: " .. color .. " }"
end)

widget:connect_signal("button::press", function(_, _, _, button)
	if popup.visible then
		popup.visible = not popup.visible
	else
		popup:move_next_to(mouse.current_widget_geometry)
	end
end)

return widget
