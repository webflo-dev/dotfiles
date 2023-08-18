local wibox = require("wibox")
local gtable = require("gears.table")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local tpl = require("ui.templates")

local daemon = require("daemons.screenshot")

local screenshot = {}

function screenshot:update_markup(markup)
	self:get_children_by_id("w_text")[1].markup = markup
end

local function new()
	local widget = wibox.widget(tpl.wibar_module({
		tpl.svg({
			image = beautiful.svg.camera,
			color = beautiful.colors.light,
			id = "w_icon",
		}),
		tpl.text({
			id = "w_text",
			font = beautiful.fonts.system,
			align = "right",
		}),
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(10),
	}, {
		visible = false,
	}))

	return gtable.crush(widget, screenshot, true)
end

local widget = new()

daemon:connect_signal("idle", function()
	widget.visible = false
end)

daemon:connect_signal("selecting_area", function()
	widget.visible = true
	widget:update_markup("taking screenshot...")
end)

return widget
