if vim.g.neovide then
	local alpha = function()
		return string.format("%x", math.floor(255 * (vim.g.transparency or 0.8)))
	end

	-- Display
	vim.o.guifont = "monospace"
	vim.g.neovide_transparency = 0.65
	-- vim.g.transparency = 0.8
	-- vim.g.neovide_background_color = "#0f1117" .. alpha()
	vim.g.neovide_floating_blur_amount_x = 2.0
	vim.g.neovide_floating_blur_amount_y = 2.0

	-- Functionality
	vim.g.neovide_refresh_rate = 144

	-- Cursor settings
	vim.g.neovide_cursor_animation_length = 0
	vim.g.neovide_cursor_antialiasing = true
	vim.g.neovide_cursor_animate_in_insert_mode = true
	vim.g.neovide_cursor_animate_command_line = true
end
