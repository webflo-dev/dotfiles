local gshape = require("gears.shape")
local beautiful = require("beautiful")

local M = {}

function M.rounded_rect(cr, w, h)
	return gshape.rounded_rect(cr, w, h, beautiful.radius)
end

function M.stylesheet_color(color)
	return "svg { fill: " .. color .. "; }"
end

function M.pango(text, values)
	local markup = ""

	if values ~= nil then
		for key, value in pairs(values) do
			if value ~= nil then
				markup = string.format("%s %s='%s'", markup, key, value)
			end
		end
	end

	return "<span " .. markup .. ">" .. text .. "</span>"
end

function M.mouse_hover_cursor(is_hover)
	local w = mouse.current_wibox
	if w then
		w.cursor = (is_hover and "hand2") or "left_ptr"
	end
end

function M.slider(widget, args)
	if widget._priv == nil then
		widget._priv = {}
	end

	widget._priv.slider_state = "idle"

	widget:connect_signal("button::press", function(self)
		self._priv.slider_state = "busy"
		if args.on_press ~= nil then
			args.on_press()
		end
	end)

	widget:connect_signal("button::release", function(self)
		if args.on_release ~= nil then
			args.on_release(self.value)
			self._priv.slider_state = "idle"
		end
	end)

	function widget:is_busy()
		return self._priv.slider_state == "busy"
	end
end

return M
