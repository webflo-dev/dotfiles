local Gio = require("lgi").Gio
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local capi = { screen = screen, mouse = mouse }
local dpi = beautiful.xresources.apply_dpi

local user_variables = require("user_variables")
local helperUI = require("helpers.ui")
local helperIcon = require("helpers.icon")
local base = require("themes.spring.widgets.base")

local app_launcher = { mt = {} }

local function string_levenshtein(str1, str2)
	local len1 = string.len(str1)
	local len2 = string.len(str2)
	local matrix = {}
	local cost = 0

	-- quick cut-offs to save time
	if len1 == 0 then
		return len2
	elseif len2 == 0 then
		return len1
	elseif str1 == str2 then
		return 0
	end

	-- initialise the base matrix values
	for i = 0, len1, 1 do
		matrix[i] = {}
		matrix[i][0] = i
	end
	for j = 0, len2, 1 do
		matrix[0][j] = j
	end

	-- actual Levenshtein algorithm
	for i = 1, len1, 1 do
		for j = 1, len2, 1 do
			if str1:byte(i) == str2:byte(j) then
				cost = 0
			else
				cost = 1
			end

			matrix[i][j] = math.min(matrix[i - 1][j] + 1, matrix[i][j - 1] + 1, matrix[i - 1][j - 1] + cost)
		end
	end

	-- return the last value - this is the Levenshtein distance
	return matrix[len1][len2]
end

local function generate_apps_list(self)
	self._private.all_entries = {}
	self._private.matched_entries = {}

	local app_info = Gio.AppInfo
	local apps = app_info.get_all()

	for _, app in ipairs(apps) do
		if app.should_show(app) then
			local name = app_info.get_name(app)
			local commandline = app_info.get_commandline(app)
			local executable = app_info.get_executable(app)
			local icon = helperIcon.get_gicon_path(app_info.get_icon(app))

			if icon == "" then
				icon = helperIcon.choose_icon({ "application-all", "application", "application-default-icon", "app" })
			end

			local desktop_app_info = Gio.DesktopAppInfo.new(app_info.get_id(app))
			local terminal = Gio.DesktopAppInfo.get_string(desktop_app_info, "Terminal") == "true" and true or false
			local generic_name = Gio.DesktopAppInfo.get_string(desktop_app_info, "GenericName") or nil

			table.insert(self._private.all_entries, {
				app = app,
				name = name,
				generic_name = generic_name,
				commandline = commandline,
				executable = executable,
				terminal = terminal,
				icon = icon,
				filename = Gio.DesktopAppInfo.get_filename(app):match("[^/]+$"),
			})
		end
	end
end

local function focus_app(self, index)
	local app = self._private.apps.children[index]
	if app == nil then
		return
	end

	app:get_children_by_id("background")[1].bg = beautiful.fg_normal
	app:get_children_by_id("background")[1].fg = beautiful.bg_normal

	if self._private.active_index ~= nil and self._private.active_index ~= index then
		local previous_app = self._private.apps.children[self._private.active_index]
		if previous_app ~= nil then
			previous_app:get_children_by_id("background")[1].bg = beautiful.bg_normal
			previous_app:get_children_by_id("background")[1].fg = beautiful.fg_normal
		end
	end

	self._private.active_index = index
end

local function create_app_widget(self, entry)
	local icon = {
		id = "icon",
		widget = wibox.widget.imagebox,
		halign = "center",
		align = "left",
		forced_width = dpi(30),
		forced_height = dpi(30),
		image = entry.icon,
	}

	local name = {
		id = "name",
		widget = wibox.widget.textbox,
		font = beautiful.fonts.system,
		text = entry.name,
		forced_height = dpi(30),
	}

	local app = wibox.widget({
		widget = wibox.container.background,
		id = "background",
		shape = helperUI.rounded_shape(),
		bg = beautiful.bg_normal,
		fg = beautiful.fg_normal,
		{
			widget = wibox.container.margin,
			margins = dpi(5),
			{
				layout = wibox.layout.fixed.horizontal,
				spacing = dpi(10),
				icon,
				name,
			},
		},
	})

	function app.spawn()
		-- if entry.commandline ~= nil then
		-- 	awful.spawn(entry.commandline)
		-- elseif entry.executable ~= nil then
		-- 	awful.spawn(entry.executable)
		-- end

		if entry.terminal == true then
			if self.terminal ~= nil then
				require("naughty").notification({
					text = "Terminal applications are not yet supported",
					title = "App launcher",
					timeout = 3,
				})
				-- local terminal_command = terminal_commands_lookup[self.terminal] or self.terminal
				-- awful.spawn(terminal_command .. " " .. entry.executable)
			else
				awful.spawn.easy_async("gtk4-launch " .. entry.filename, function(stdout, stderr)
					if stderr then
						awful.spawn(entry.executable)
					end
				end)
			end
		else
			awful.spawn("gtk-launch " .. entry.filename)
		end

		self:hide()
	end

	-- app:connect_signal("button::press", function(_self, lx, ly, button, mods, find_widgets_result)
	-- 	if button == 1 then
	-- 		-- if self._private.active_widget == _self or not self.select_before_spawn then
	-- 		-- 	_self.spawn()
	-- 		-- end
	-- 	end
	-- end)

	return app
end

local function reset(self)
	self._private.apps:reset()
	self._private.matched_entries = self._private.all_entries

	for index, entry in pairs(self._private.all_entries) do
		-- Only add the apps that are part of the first page
		if index <= 8 then
			self._private.apps:add(create_app_widget(self, entry))
		else
			break
		end
	end
	focus_app(self, 1)
end

local function search(self, text)
	-- Reset all the matched entries
	self._private.matched_entries = {}
	self._private.apps:reset()

	if text == "" then
		self._private.matched_entries = self._private.all_entries
	else
		for index, entry in pairs(self._private.all_entries) do
			text = text:gsub("%W", "")

			-- Check if there's a match by the app name or app command
			if
				string.find(entry.name:lower(), text:lower(), 1, true) ~= nil
				or self.search_commands and string.find(entry.commandline, text:lower(), 1, true) ~= nil
			then
				table.insert(self._private.matched_entries, {
					app = entry.app,
					name = entry.name,
					generic_name = entry.generic_name,
					commandline = entry.commandline,
					executable = entry.executable,
					terminal = entry.terminal,
					icon = entry.icon,
					filename = entry.filename,
				})
			end
		end

		-- Sort by string similarity
		table.sort(self._private.matched_entries, function(a, b)
			return string_levenshtein(text, a.name) < string_levenshtein(text, b.name)
		end)
	end

	for index, entry in pairs(self._private.matched_entries) do
		if index <= 8 then
			self._private.apps:add(create_app_widget(self, entry))
		end
	end

	if self._private.active_index ~= nil then
		focus_app(self, 1)
	end
end

--- Shows the app launcher
function app_launcher:show()
	local screen = awful.screen.focused()

	generate_apps_list(self)
	reset(self)

	screen.app_launcher = self._private.widget
	screen.app_launcher.screen = screen
	local textbox = self._private.prompt

	awful.prompt.run({
		textbox = textbox,
		-- history_path = gears.filesystem.get_cache_dir() .. "/history" or nil,
		font = beautiful.fonts.system,
		bg_cursor = beautiful.fg_normal,
		hooks = {
			{
				{},
				"Escape",
				function(text)
					self:hide()
				end,
			},
			{
				{},
				"Return",
				function(text)
					if self._private.active_index then
						local app = self._private.apps.children[self._private.active_index]
						if app ~= nil then
							app.spawn()
						end
						self:hide()
					end
				end,
			},
		},
		keypressed_callback = function(mod, key, command)
			if key == "Up" then
				if self._private.active_index > 1 then
					focus_app(self, self._private.active_index - 1)
				end
			end
			if key == "Down" then
				if self._private.active_index < 8 then
					focus_app(self, self._private.active_index + 1)
				end
			end
		end,
		changed_callback = function(text)
			if text == self._private.text then
				return
			end

			if self._private.search_timer ~= nil and self._private.search_timer.started then
				self._private.search_timer:stop()
			end

			self._private.search_timer = gears.timer({
				timeout = 0.05,
				autostart = true,
				single_shot = true,
				callback = function()
					search(self, text)
				end,
			})

			self._private.text = text
		end,
	})

	focus_app(self, 1)
	screen.app_launcher.visible = true
end

--- Hides the app launcher
function app_launcher:hide()
	local screen = awful.screen.focused()

	if screen.app_launcher == nil or screen.app_launcher.visible == false then
		return
	end

	reset(self)
	screen.app_launcher.visible = false
	screen.app_launcher = nil
end

--- Toggles the app launcher
function app_launcher:toggle()
	local screen = awful.screen.focused()

	if screen.app_launcher and screen.app_launcher.visible then
		self:hide()
	else
		self:show()
	end
end

-- Returns a new app launcher
local function new(args)
	args = args or {}

	local ret = gears.object({})
	ret._private = {}

	gears.table.crush(ret, app_launcher)
	gears.table.crush(ret, args)

	ret._private_active_index = nil

	ret._private.apps = wibox.widget({
		layout = wibox.layout.fixed.vertical,
		spacing = dpi(10),
		forced_width = dpi(800),
		forced_height = dpi(400),
	})

	ret._private.prompt = wibox.widget.textbox()

	ret._private.widget = awful.popup({
		type = "dock",
		visible = false,
		ontop = true,
		placement = awful.placement.centered,
		border_width = beautiful.border_width,
		border_color = beautiful.colors.lime,
		shape = helperUI.rounded_shape(),
		bg = beautiful.bg,
		widget = {
			layout = wibox.layout.fixed.vertical,
			{
				{
					base.svg(beautiful.svg.search, beautiful.fg_normal),
					{
						text = "Search...",
						align = "left",
						valign = "center",
						font = beautiful.fonts.system,
						widget = ret._private.prompt,
					},
					widget = wibox.container.margin,
					layout = wibox.layout.fixed.horizontal,
					forced_height = dpi(30),
					forced_width = dpi(30),
					spacing = dpi(10),
				},
				layout = wibox.container.margin,
				margins = dpi(10),
			},
			{
				widget = wibox.container.margin,
				margins = dpi(20),
				ret._private.apps,
			},
		},
	})

	generate_apps_list(ret)
	reset(ret)

	-- awful.mouse.append_client_mousebinding(awful.button({}, 1, function(c)
	-- 	ret:hide()
	-- end))
	--
	-- awful.mouse.append_global_mousebinding(awful.button({}, 1, function(c)
	-- 	ret:hide()
	-- end))
	--
	-- awful.mouse.append_client_mousebinding(awful.button({}, 3, function(c)
	-- 	ret:hide()
	-- end))
	--
	-- awful.mouse.append_global_mousebinding(awful.button({}, 3, function(c)
	-- 	ret:hide()
	-- end))

	return ret
end

function app_launcher.mt:__call(...)
	return new(...)
end

return setmetatable(app_launcher, app_launcher.mt)
