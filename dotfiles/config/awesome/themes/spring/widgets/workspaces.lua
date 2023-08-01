local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local helperUI = require("helpers.ui")
local base = require("themes.spring.widgets.base")

local workspaces = function(s)
	local function update(item, tag, index)
		local svg = item:get_children_by_id("icon_role")[1]
		local color = beautiful.colors.gray
		if tag.selected then
			color = beautiful.colors.yellow
		elseif #tag:clients() > 0 then
			color = beautiful.colors.sky
		end

		svg:set_image(beautiful.svg.circle(index))
		svg:set_stylesheet("svg { fill: " .. color .. " }")
	end

	return awful.widget.taglist({
		screen = s,
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
		widget_template = gears.table.crush({
			create_callback = update,
			update_callback = update,
		}, base.svg_template(beautiful.svg.circle(1), beautiful.colors.gray, "icon_role"), true),
	})
end

return function(screen)
	return base.box(workspaces(screen))
end
