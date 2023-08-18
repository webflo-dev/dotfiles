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

	for key, value in pairs(values) do
		if value ~= nil then
			markup = string.format("%s %s='%s'", markup, key, value)
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

return M
