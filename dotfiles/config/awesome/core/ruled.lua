local awful = require("awful")
local ruled = require("ruled")
local gears = require("gears")
local helperClient = require("helpers.client")
local helperUI = require("helpers.ui")

--- Get screen geometry
local screen_width = awful.screen.focused().geometry.width
local screen_height = awful.screen.focused().geometry.height

local function floating_properties(extra_properties)
	local properties = {
		floating = true,
		raise = true,
		focus = true,
		honor_workarea = true,
		honor_padding = true,
		placement = awful.placement.centered,
	}

	if extra_properties == nil then
		return properties
	end

	return gears.table.crush(properties, extra_properties)
end

ruled.client.connect_signal("request::rules", function()
	--- Global
	ruled.client.append_rule({
		id = "global",
		rule = {},
		properties = {
			raise = true,
			size_hints_honor = true,
			honor_workarea = true,
			honor_padding = true,
			-- screen = awful.screen.preferred,
			screen = awful.screen.focused,
			focus = awful.client.focus.filter,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	})

	ruled.client.append_rule({
		id = "tasklist_order",
		rule = {},
		properties = {},
		callback = awful.client.setslave,
	})

	ruled.client.append_rule({
		id = "floating_terminal",
		rule = {
			class = "floating_terminal",
		},
		properties = floating_properties({
			width = 1280,
			height = 720,
		}),
	})

	--- Float
	local float_classes = { "Nvidia-settings", "Nm-connection-editor", "feh", "imv" }
	for _, class in ipairs(float_classes) do
		ruled.client.append_rule({
			id = "float__class__" .. class,
			rule = {
				class = class,
			},
			properties = floating_properties(),
		})
	end

	ruled.client.append_rule({
		id = "float__type",
		rule = {
			type = "dialog",
		},
		properties = floating_properties(),
	})

	ruled.client.append_rule({
		id = "picture-in-picture",
		rule = {
			name = "Picture in picture",
		},
		properties = floating_properties({
			placement = awful.placement.bottom_right + awful.placement.no_offscreen,
			width = 1280,
			height = 720,
		}),
	})
end)
