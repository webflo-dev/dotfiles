local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local utils = require("utils.widget")
local ui = require("ui.utils")
local tpl = require("ui.templates")

local function update(item, tag, index)
	local svg = item:get_children_by_id("icon_role")[1]
	local color = beautiful.colors.gray
	if tag.selected then
		color = beautiful.colors.yellow
	elseif #tag:clients() > 0 then
		color = beautiful.colors.sky
	end

	svg.image = beautiful.svg["circle_" .. index]
	svg.stylesheet = ui.stylesheet_color(color)
end

local function new(screen)
	return tpl.wibar_module(awful.widget.taglist({
		screen = screen,
		filter = awful.widget.taglist.filter.all,
		buttons = gears.table.join(
			awful.button({}, 1, function(t)
				t:view_only()
			end),
			awful.button({ "Shift" }, 1, function(t)
				if t.selected then
					t.select = false
				else
					t.selected = true
				end
			end)
		),
		layout = {
			spacing = dpi(4),
			layout = wibox.layout.fixed.horizontal,
		},
		style = {
			spacing = dpi(10),
		},
		widget_template = gears.table.crush(
			{
				create_callback = update,
				update_callback = update,
			},
			tpl.svg({
				image = beautiful.svg.circle_1,
				color = beautiful.colors.gray,
				id = "icon_role",
			}),
			true
		),
	}))
end

return utils.factory(new)
