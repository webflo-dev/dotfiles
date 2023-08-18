local wibox = require("wibox")
local gobject = require("gears.object")
local gtable = require("gears.table")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local ui = require("ui.utils")
local tpl = require("ui.templates")

local daemon = require("daemons.screenrecord")

local screenrecord = {}

function screenrecord:update_markup(markup)
	self:get_children_by_id("w_text")[1].markup = markup
end

function screenrecord:enable_stop(enable)
	self:get_children_by_id("w_stop")[1].visible = enable
end

function screenrecord:is_recording()
	return self:get_children_by_id("w_stop")[1].visible
end

local function new()
	local widget = wibox.widget(tpl.wibar_module({
		tpl.svg({
			image = beautiful.svg.video,
			color = beautiful.colors.light,
		}),
		tpl.svg({
			image = beautiful.svg.stop,
			color = beautiful.bg_urgent,
			id = "w_stop",
			visible = false,
		}),
		tpl.text({
			align = "right",
			id = "w_text",
			font = beautiful.fonts.system,
		}),
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(10),
	}, {
		visible = false,
	}))

	widget:connect_signal("button::press", function(self)
		if self:is_recording() == true then
			daemon:toggle_recording()
		end
	end)

	return gtable.crush(widget, screenrecord, true)
end

local widget = new()

daemon:connect_signal("idle", function()
	widget.visible = false
	widget:enable_stop(false)
end)

daemon:connect_signal("selecting_area", function()
	widget.visible = true
	widget:update_markup("selecting area...")
end)

daemon:connect_signal("tick", function(_, _, duration)
	widget:update_markup(
		string.format(
			"%s %s",
			ui.pango("recording...", { foreground = beautiful.bg_urgent, style = "italic" }),
			duration
		)
	)
end)

daemon:connect_signal("recording", function()
	widget.visible = true
	widget:enable_stop(true)
end)

return widget
