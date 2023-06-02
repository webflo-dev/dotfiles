return {

	-- { 'Exafunction/codeium.vim' },
	-- { "github/copilot.vim" }
	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		build = ":Copilot auth",
		opts = {
			panel = {
				enabled = true,
				auto_refresh = true,
				keymap = {
					jump_prev = "[[",
					jump_next = "]]",
					accept = "<CR>",
					refresh = "gr",
					open = "<C-CR>",
				},
				layout = {
					position = "right", -- | top | left | right
					ratio = 0.4,
				},
			},
			suggestion = {
				enabled = true,
				auto_trigger = true,
				debounce = 75,
				keymap = {
					accept = "<M-l>",
					accept_word = false,
					accept_line = false,
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
			},
			filetypes = {
				javascript = true,
				typescript = true,
				css = true,
				yaml = false,
				markdown = false,
				help = false,
				gitcommit = false,
				gitrebase = false,
				terraform = false,
				sh = function()
					if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
						-- disable for .env files
						return false
					end
					return true
				end,
				-- ["*"] = false, -- disable for all other filetypes and ignore default `filetypes`
			},
		},
	},

	{
		"Bryley/neoai.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		cmd = {
			"NeoAI",
			"NeoAIOpen",
			"NeoAIClose",
			"NeoAIToggle",
			"NeoAIContext",
			"NeoAIContextOpen",
			"NeoAIContextClose",
			"NeoAIInject",
			"NeoAIInjectCode",
			"NeoAIInjectContext",
			"NeoAIInjectContextCode",
		},
		-- keys = {
		--   { "<leader>as", desc = "summarize text" },
		--   { "<leader>ag", desc = "generate git message" },
		-- },
		opts = function()
			return {
				ui = {
					output_popup_text = "NeoAI",
					input_popup_text = "Prompt",
					width = 30, -- As percentage eg. 30%
					output_popup_height = 80, -- As percentage eg. 80%
				},
				model = "gpt-3.5-turbo",
				register_output = {
					["g"] = function(output)
						return output
					end,
					["c"] = require("neoai.utils").extract_code_snippets,
				},
				inject = {
					cutoff_width = 75,
				},
				prompts = {
					context_prompt = function(context)
						return "Hi ChatGPT, I'd like to provide some context for future "
							.. "messages. Here is the code/text that I want to refer "
							.. "to in our upcoming conversations:\n\n"
							.. context
					end,
				},
				open_api_key_env = "OPENAI_API_KEY",
				shortcuts = {
					{
						key = "<leader>as",
						use_context = true,
						prompt = [[
                Please rewrite the text to make it more readable, clear,
                concise, and fix any grammatical, punctuation, or spelling
                errors
            ]],
						modes = { "v" },
						strip_function = nil,
					},
					{
						key = "<leader>ag",
						use_context = false,
						prompt = function()
							return [[
                    Using the following git diff generate a consise and
                    clear git commit message, with a short title summary
                    that is 75 characters or less:
                ]] .. vim.fn.system("git diff --cached")
						end,
						modes = { "n" },
						strip_function = nil,
					},
				},
			}
		end,
	},
}
