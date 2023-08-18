local wibox = require("wibox")
local gtable = require("gears.table")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local ui = require("ui.utils")
local tpl = require("ui.templates")
local utils = require("utils.widget")

local LEVEL = {
	normal = "normal",
	warning = "warning",
	critical = "critical",
}

local ICON_COLORS = {
	[LEVEL.normal] = beautiful.colors.lime,
	[LEVEL.warning] = beautiful.colors.orange,
	[LEVEL.critical] = beautiful.colors.red,
}

local TEXT_COLORS = {
	[LEVEL.normal] = beautiful.fg_normal,
	[LEVEL.warning] = beautiful.colors.orange,
	[LEVEL.critical] = beautiful.colors.red,
}

local base = {}
function base:update(value)
	local level = LEVEL.normal
	if value >= 70 and value < 90 then
		level = LEVEL.warning
	elseif value >= 90 then
		level = LEVEL.critical
	end

	self:get_children_by_id("w_text")[1].markup = ui.pango(value .. "%", { foreground = TEXT_COLORS[level] })
	self:get_children_by_id("w_icon")[1].stylesheet = ui.stylesheet_color(ICON_COLORS[level])
end

local function new(args)
	local widget = wibox.widget({
		tpl.svg({
			image = args.image,
			color = beautiful.accent_color,
			id = "w_icon",
		}),
		tpl.text({
			align = "right",
			forced_width = dpi(30),
			id = "w_text",
		}),
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(5),
	})

	return gtable.crush(widget, base, true)
end

return utils.factory(new)
