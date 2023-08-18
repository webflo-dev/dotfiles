local wibox = require("wibox")
local beautiful = require("beautiful")
local gtable = require("gears.table")
local dpi = beautiful.xresources.apply_dpi

local ui = require("ui.utils")

local M = {}

function M.wibar_module(children, extra_props)
	local template = {
		{
			children,
			widget = wibox.container.margin,
			margins = {
				left = dpi(10),
				right = dpi(10),
			},
		},
		widget = wibox.container.background,
		shape = ui.rounded_rect,
		bg = beautiful.bg_normal,
		border_color = beautiful.bg_focus,
		border_width = dpi(2),
	}
	if extra_props ~= nil then
		return gtable.crush(template, extra_props)
	end
	return template
end

function M.separator()
	return {
		widget = wibox.widget.textbox,
		text = " ",
		align = "center",
		valign = "center",
	}
end

function M.popup(args)
	local template = {
		preferred_anchors = "middle",
		ontop = true,
		visible = false,
		shape = ui.rounded_rect,
		border_width = beautiful.border_width,
		border_color = beautiful.colors.sky,
		bg = beautiful.bg_opaque,
		hide_on_right_click = true,
		offset = { y = 5 },
	}
	return gtable.crush(template, args)
end

function M.svg(args)
	args.enable_margin = (args.enable_margin == false and false) or true
	args.id = args.id or "svg"

	local template = {
		image = args.image,
		stylesheet = ui.stylesheet_color(args.color),
		valign = "center",
		halign = "center",
		widget = wibox.widget.imagebox,
		id = args.id,
	}

	local child = gtable.crush(template, args, true)

	if args.enable_margin == true then
		return {
			child,
			margins = dpi(5),
			widget = wibox.container.margin,
		}
	end

	return child
end

function M.text(args)
	local template = {
		widget = wibox.widget.textbox,
		markup = "---",
		align = "center",
		valign = "center",
		font = beautiful.fonts.monospace,
	}

	return gtable.crush(template, args)
end

return M
