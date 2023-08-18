local wibox = require("wibox")
local gobject = require("gears.object")
local gtable = require("gears.table")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local tpl = require("ui.templates")
local ui = require("ui.utils")
local utils = require("utils.widget")

local daemon = require("daemons.overmind")

local SVG_DEFAULT_SIZE = dpi(24)

local function hover_effect_enter(widget)
	widget.stylesheet = ui.stylesheet_color(beautiful.accent_color)
	ui.mouse_hover_cursor(true)
end
local function hover_effect_leave(widget)
	widget.stylesheet = ui.stylesheet_color(beautiful.fg_normal)
	ui.mouse_hover_cursor(false)
end

local function toggle_button(widget, visible)
	if widget.visible ~= visible then
		widget.visible = visible
		if visible then
			widget:connect_signal("mouse::enter", hover_effect_enter)
			widget:connect_signal("mouse::leave", hover_effect_leave)
		else
			widget:disconnect_signal("mouse::enter", hover_effect_enter)
			widget:disconnect_signal("mouse::leave", hover_effect_leave)
		end
	end
end

local process = {}

function process:update_info(data)
	self._priv.data = gtable.crush(self._priv.data, data)

	local w_icon_start = self:get_children_by_id("w_icon_start")[1]
	local w_icon_log = self:get_children_by_id("w_icon_log")[1]
	local w_icon_stop = self:get_children_by_id("w_icon_stop")[1]
	local w_icon_status = self:get_children_by_id("w_icon_status")[1]

	if self._priv.data.running then
		toggle_button(w_icon_stop, true)
		toggle_button(w_icon_log, true)
		toggle_button(w_icon_start, false)
		w_icon_status.stylesheet = ui.stylesheet_color(beautiful.colors.green)
		w_icon_status.image = beautiful.svg.check
	else
		toggle_button(w_icon_stop, false)
		toggle_button(w_icon_log, false)
		toggle_button(w_icon_start, true)
		w_icon_status.stylesheet = ui.stylesheet_color(beautiful.colors.red)
		w_icon_status.image = beautiful.svg.xmark
	end
end

local function new(args)
	local widget = wibox.widget({
		{
			tpl.svg({
				image = beautiful.svg.spinner,
				color = beautiful.fg_normal,
				id = "w_icon_status",
				forced_width = SVG_DEFAULT_SIZE,
				forced_height = SVG_DEFAULT_SIZE,
			}),
			tpl.text({
				markup = args.name,
				font = beautiful.fonts.system,
				align = "left",
				forced_width = dpi(100),
			}),
			{
				tpl.svg({
					id = "w_icon_start",
					image = beautiful.svg.play,
					color = beautiful.fg_normal,
					forced_width = SVG_DEFAULT_SIZE,
					forced_height = SVG_DEFAULT_SIZE,
					visible = false,
				}),
				tpl.svg({
					id = "w_icon_log",
					image = beautiful.svg.file,
					color = beautiful.fg_normal,
					forced_width = SVG_DEFAULT_SIZE,
					forced_height = SVG_DEFAULT_SIZE,
					visible = false,
				}),
				tpl.svg({
					id = "w_icon_stop",
					image = beautiful.svg.stop,
					color = beautiful.fg_normal,
					forced_width = SVG_DEFAULT_SIZE,
					forced_height = SVG_DEFAULT_SIZE,
					visible = false,
				}),
				layout = wibox.layout.fixed.horizontal,
			},
			spacing = dpi(8),
			fill_space = true,
			layout = wibox.layout.align.horizontal,
		},
		margins = dpi(8),
		layout = wibox.container.margin,
		bg = beautiful.bg_normal,
		widget = wibox.container.background,
		-- forced_width = dpi(500),
	})
	widget.id = args.name

	local w_icon_start = widget:get_children_by_id("w_icon_start")[1]
	local w_icon_log = widget:get_children_by_id("w_icon_log")[1]
	local w_icon_stop = widget:get_children_by_id("w_icon_stop")[1]
	local w_icon_status = widget:get_children_by_id("w_icon_status")[1]

	toggle_button(w_icon_start, true)
	toggle_button(w_icon_log, false)
	toggle_button(w_icon_stop, false)

	w_icon_log:connect_signal("button::press", function()
		daemon:log_process(widget._priv.data.name)
		widget:emit_signal("request_popup_visibility", { visible = false })
	end)

	w_icon_stop:connect_signal("button::press", function()
		toggle_button(w_icon_start, false)
		toggle_button(w_icon_log, false)
		toggle_button(w_icon_stop, false)
		w_icon_status.image = beautiful.svg.spinner
		w_icon_status.stylesheet = ui.stylesheet_color(beautiful.fg_normal)

		daemon:stop_process(widget._priv.data.name)
	end)

	w_icon_start:connect_signal("button::press", function()
		toggle_button(w_icon_start, false)
		toggle_button(w_icon_log, false)
		toggle_button(w_icon_stop, false)
		w_icon_status.image = beautiful.svg.spinner
		w_icon_status.stylesheet = ui.stylesheet_color(beautiful.fg_normal)

		daemon:start_process(widget._priv.data.name)
	end)

	widget._priv = {
		data = args,
	}

	-- local ret = gobject({})
	-- gtable.crush(ret, process, true)
	-- gtable.crush(ret, widget, true)
	return gtable.crush(widget, process, true)
end

return utils.factory(new)
