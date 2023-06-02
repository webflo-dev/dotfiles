local gears = require("gears")
local beautiful = require("beautiful")

local helpers = {}

function helpers.font(size, font_name, style)
	return string.format("%s %s %s", font_name or beautiful.fonts.main, style or "", size or beautiful.font_size)
end

function helpers.pango(text, color, weight, font_family)
	return string.format(
		"<span foreground='%s' weight='%s' font_family='%s'>%s</span>",
		color or beautiful.fg_normal,
		weight or "normal",
		font_family or beautiful.fonts.system,
		text
	)
end

function helpers.pango2(text, values)
	local markup = ""

	for key, value in pairs(values) do
		if value ~= nil then
			markup = string.format("%s %s='%s'", markup, key, value)
		end
	end

	return "<span " .. markup .. ">" .. text .. "</span>"
end

function helpers.rounded_shape(radius)
	return function(cr, w, h)
		gears.shape.rounded_rect(cr, w, h, radius or beautiful.radius)
	end
end

-- Add a hover cursor to a widget by changing the cursor on
-- mouse::enter and mouse::leave
-- You can find the names of the available cursors by opening any
-- cursor theme and looking in the "cursors folder"
-- For example: "hand1" is the cursor that appears when hovering over
-- links
function helpers.add_hover_cursor(w, hover_cursor)
	local original_cursor = "left_ptr"

	w:connect_signal("mouse::enter", function()
		local w = mouse.current_wibox
		if w then
			w.cursor = hover_cursor or "hand2"
		end
	end)

	w:connect_signal("mouse::leave", function()
		local w = mouse.current_wibox
		if w then
			w.cursor = original_cursor
		end
	end)
end

return helpers
