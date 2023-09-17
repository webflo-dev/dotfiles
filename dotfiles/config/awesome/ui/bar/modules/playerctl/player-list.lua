local wibox = require("wibox")
local gtable = require("gears.table")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local utils = require("utils.widget")

local api = {}
function api:get_player(player_instance)
	return utils.find_by_id(self.children, player_instance)
end

function api:add_player(widget)
	self:insert(1, widget)
end

function api:remove_player(player_instance)
	local index = utils.index_of(self.children, player_instance)
	if index ~= nil then
		self:remove(index)
	end
end

local function new()
	local widget = wibox.widget({
		spacing = dpi(15),
		layout = wibox.layout.flex.vertical,
	})

	return gtable.crush(widget, api, true)
end

return new()
