local lgi = require("lgi")
local Gtk = lgi.require("Gtk", "3.0")

local name_lookup = {
	["edge"] = "microsoft edge",
}

local gtk_theme = Gtk.IconTheme.get_default()
local icon_size = 48

local M = {}

function M.get_gicon_path(gicon)
	if gicon == nil then
		return ""
	end

	local icon_info = gtk_theme:lookup_by_gicon(gicon, icon_size, 0)
	if icon_info then
		local icon_path = icon_info:get_filename()
		if icon_path then
			return icon_path
		end
	end

	return ""
end

function M.choose_icon(icons_names)
	local icon_info = gtk_theme:choose_icon(icons_names, icon_size, 0)
	if icon_info then
		local icon_path = icon_info:get_filename()
		if icon_path then
			return icon_path
		end
	end

	return ""
end

function M.get_icon_path(icon_name)
	local icon_info = gtk_theme:lookup_icon(name_lookup[icon_name] or icon_name, icon_size, 0)
	if icon_info then
		local icon_path = icon_info:get_filename()
		if icon_path then
			return icon_path
		end
	end

	return ""
end

function M.search_apps_icon(icon_name)
	local apps = lgi.Gio.AppInfo.get_all()

	if icon_name ~= nil then
		for _, app in ipairs(apps) do
			local name = app:get_name():lower()
			if name and name:find(icon_name, 1, true) then
				return M.get_gicon_path(app:get_icon())
			end
		end
	end
end

return M
