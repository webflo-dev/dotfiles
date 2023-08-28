local gfilesystem = require("gears.filesystem")

local utils = require("utils.daemon")

local function new()
	local script_system = gfilesystem.get_configuration_dir() .. "scripts/system.sh"
	return utils.automatic_watcher(script_system)
end

return new()
