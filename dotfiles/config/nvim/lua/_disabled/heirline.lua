local utils = require("utils")

local os_sep = package.config:sub(1, 1)

vim.api.nvim_create_autocmd("User", {
	pattern = "HeirlineInitWinbar",
	callback = function(args)
		local buf = args.buf
		local buftype = vim.tbl_contains({ "prompt", "nofile", "help", "quickfix" }, vim.bo[buf].buftype)
		local filetype = vim.tbl_contains({ "gitcommit", "fugitive" }, vim.bo[buf].filetype)
		if buftype or filetype then
			vim.opt_local.winbar = nil
		end
	end,
})

return {
	{
		"rebelot/heirline.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		event = { "VimEnter" },
		config = function()
			local heirline = require("heirline.utils")
			local conditions = require("heirline.conditions")
			local devicons = require("nvim-web-devicons")
			local icons = require("icons")
			local colors = require("tokyonight.colors").setup()

			local Align, Space, Null, ReadOnly
			do
				Null = { provider = "" }

				Align = { provider = "%=" }

				Space = setmetatable({ provider = " " }, {
					__call = function(_, n)
						return { provider = string.rep(" ", n) }
					end,
				})

				ReadOnly = {
					condition = function()
						return not vim.bo.modifiable or vim.bo.readonly
					end,
					provider = icons.common.lock,
					hl = { fg = colors.red },
				}
			end

			local Mode
			do
				local NormalModeIndicator = {
					condition = function(self)
						return self.mode == "NORMAL"
					end,
					{
						Space,
						{
							fallthrough = false,
							ReadOnly,
							{
								provider = icons.common.circle,
								hl = function(self)
									local color = self.colors["NORMAL"]
									if vim.bo.modified then
										return { fg = colors.orange }
									else
										return { fg = color.fg }
									end
								end,
							},
						},
						Space,
					},
				}

				local ActiveModeIndicator = {
					condition = function(self)
						return self.mode ~= "NORMAL"
					end,
					hl = { fg = colors.bg_statusline },
					heirline.surround({ "", "" }, function(self)
						return self.colors[self.mode].bg
					end, {
						hl = function(self)
							return { bg = self.colors[self.mode].bg }
						end,
						{
							fallthrough = false,
							ReadOnly,
							{ provider = icons.common.circle },
						},
						Space,
						{
							provider = function(self)
								return self.mode
							end,
						},
					}),
				}

				Mode = {
					init = function(self)
						self.mode = self.names[vim.fn.mode(1)]
					end,
					condition = function()
						return vim.bo.buftype == ""
					end,
					static = {
						names = {
							n = "NORMAL",
							no = "O-P",
							nov = "O-P",
							noV = "O-P",
							["no\22"] = "O-P",
							niI = "NORMAL",
							niR = "NORMAL",
							niV = "NORMAL",
							nt = "NORMAL",
							v = "VISUAL",
							vs = "VISUAL",
							V = "VISUAL LINES",
							Vs = "VISUAL LINES",
							["\22"] = "VISUAL BLOCK", -- CTRL-V
							["\22s"] = "VISUAL BLOCK", -- CTRL-Vs
							s = "SELECT",
							S = "SELECT",
							["\19"] = "BLOCK", -- CTRL-S
							i = "INSERT",
							ic = "INSERT",
							ix = "INSERT",
							R = "REPLACE",
							Rc = "REPLACE",
							Rx = "REPLACE",
							Rv = "V-REPLACE",
							Rvc = "V-REPLACE",
							Rvx = "V-REPLACE",
							c = "COMMAND",
							cv = "COMMAND",
							r = "ENTER",
							rm = "MORE",
							["r?"] = "CONFIRM",
							["!"] = "SHELL",
							t = "TERMINAL",
							["null"] = "NONE",
						},
						colors = {
							NORMAL = { fg = colors.blue },
							INSERT = { fg = colors.black, bg = colors.green },
							VISUAL = { fg = colors.black, bg = colors.cyan },
							["VISUAL LINES"] = { fg = colors.black, bg = colors.cyan },
							["VISUAL BLOCK"] = { fg = colors.black, bg = colors.cyan },
							COMMAND = { fg = colors.black, bg = colors.yellow },
							SELECT = { fg = colors.black, bg = colors.purple },
							BLOCK = { fg = colors.black, bg = colors.purple },
							REPLACE = { fg = colors.black, bg = colors.orange },
							["V-REPLACE"] = { fg = colors.black, bg = colors.orange },
							SHELL = { fg = colors.black, bg = colors.red },
							TERMINAL = { fg = colors.black, bg = colors.red },
						},
					},
					{
						fallthrough = false,
						ActiveModeIndicator,
						NormalModeIndicator,
					},
				}
			end

			local FileNameBlock, CurrentPath, FileName
			do
				local FileIcon = {
					condition = function()
						return not ReadOnly.condition()
					end,
					init = function(self)
						local filename = self.filename
						local extension = vim.fn.fnamemodify(filename, ":e")
						self.icon, self.icon_color = devicons.get_icon_color(filename, extension, { default = true })
					end,
					provider = function(self)
						if self.icon then
							return self.icon .. " "
						end
					end,
					hl = function(self)
						return { fg = self.icon_color }
					end,
				}

				CurrentPath = {
					condition = function(self)
						if vim.bo.buftype == "" then
							return self.current_path
						end
					end,
					hl = { fg = heirline.get_highlight("Directory").fg },
					flexible = 60,
					{
						provider = function(self)
							return self.current_path
						end,
					},
					{
						provider = function(self)
							return vim.fn.pathshorten(self.current_path, 2)
						end,
					},
					-- { provider = "" },
				}

				FileName = {
					provider = function(self)
						return self.filename
					end,
					hl = function()
						return {
							fg = heirline.get_highlight("Statusline").fg,
							bold = true,
						}
					end,
				}

				FileNameBlock = {
					init = function(self)
						local pwd = vim.fn.getcwd(0) -- Present working directory.
						local current_path = vim.api.nvim_buf_get_name(0)
						local filename

						if current_path == "" then
							pwd = vim.fn.fnamemodify(pwd, ":~")
							current_path = nil
							filename = " [No Name]"
						elseif current_path:find(pwd, 1, true) then
							filename = vim.fn.fnamemodify(current_path, ":t")
							current_path = vim.fn.fnamemodify(current_path, ":~:.:h")
							pwd = vim.fn.fnamemodify(pwd, ":~") .. os_sep
							if current_path == "." then
								current_path = nil
							else
								current_path = current_path .. os_sep
							end
						else
							pwd = nil
							filename = vim.fn.fnamemodify(current_path, ":t")
							current_path = vim.fn.fnamemodify(current_path, ":~:.:h") .. os_sep
						end

						self.pwd = pwd
						self.current_path = current_path -- The opened file path relevant to pwd.
						self.filename = filename
					end,
					{
						FileIcon,
						CurrentPath,
						FileName,
					},
					-- This means that the statusline is cut here when there"s not enough space.
					{ provider = "%<" },
				}
			end

			local SearchResults = {
				condition = function(self)
					local search_count = vim.fn.searchcount({ recompute = 1, maxcount = -1, timeout = 500 })
					local active = false
					if vim.v.hlsearch and vim.v.hlsearch == 1 and search_count.total and search_count.total > 0 then
						active = true
					end
					if not active then
						return
					end
					self.count = search_count
					return true
				end,
				hl = { fg = colors.bg_statusline },
				{
					heirline.surround({ "", "" }, colors.cyan, {
						provider = function(self)
							return string.format("%s %d/%d", icons.common.search, self.count.current, self.count.total)
						end,
						hl = { bg = colors.cyan },
					}),
					Space,
				},
			}

			local Codeium = {
				condition = function()
					return utils.has_plugin("codeium.vim")
				end,
				init = function(self)
					self.status = vim.fn["codeium#GetStatusString"]()
				end,
				heirline.surround({ "", "" }, colors.fg_gutter, {
					provider = function(self)
						return " " .. self.status
					end,
					hl = function(self)
						local hl = {
							fg = heirline.get_highlight("Statusline").fg,
							bg = colors.fg_gutter,
						}
						if self.status == " ON" then
							hl.fg = colors.green
						elseif self.status == " * " then
							hl.fg = colors.orange
						end
						return hl
					end,
				}),
				Space,
			}

			local Diagnostics = {
				condition = conditions.has_diagnostics,
				init = function(self)
					self.error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text
					self.warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text
					self.info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text
					self.hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text

					self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
					self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
					self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
					self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
				end,
				{
					provider = function(self)
						-- 0 is just another output, we can decide to print it or not!
						if self.errors > 0 then
							return table.concat({ self.error_icon, self.errors, " " })
						end
					end,
					hl = { fg = heirline.get_highlight("DiagnosticSignError").fg },
				},
				{
					provider = function(self)
						if self.warnings > 0 then
							return table.concat({ self.warn_icon, self.warnings, " " })
						end
					end,
					hl = { fg = heirline.get_highlight("DiagnosticSignWarn").fg },
				},
				{
					provider = function(self)
						if self.info > 0 then
							return table.concat({ self.info_icon, self.info, " " })
						end
					end,
					hl = { fg = heirline.get_highlight("DiagnosticSignInfo").fg },
				},
				{
					provider = function(self)
						if self.hints > 0 then
							return table.concat({ self.hint_icon, self.hints, " " })
						end
					end,
					hl = { fg = heirline.get_highlight("DiagnosticSignHint").fg },
				},
				Space(2),
			}

			local Git
			do
				local GitBranch = {
					condition = function(self)
						return self.is_git_repo
					end,
					hl = { fg = colors.purple, bold = true },
					provider = function(self)
						return string.format("%s %s", icons.git.branch, self.git_status.head)
					end,
				}

				local GitChanges = {
					condition = function(self)
						if self.is_git_repo then
							local has_changes = self.git_status.added ~= 0
								or self.git_status.removed ~= 0
								or self.git_status.changed ~= 0
							return has_changes
						end
					end,
					provider = string.format(" %s ", icons.common.asterisk),
					hl = { fg = colors.blue, bold = true },
				}

				Git = {
					init = function(self)
						self.is_git_repo = conditions.is_git_repo()
						self.git_status = vim.b.gitsigns_status_dict
					end,
					{ GitBranch, GitChanges },
				}
			end

			local Lsp
			do
				local LspIndicator = {
					hl = { fg = heirline.get_highlight("Statusline").fg },
					{
						{ provider = icons.common.circle_small },
						Space,
					},
				}

				local LspServer = {
					{
						{
							provider = function(self)
								local names = self.lsp_names
								if #names == 1 then
									names = names[1]
								else
									names = table.concat(names, "")
								end
								return names
							end,
						},
						Space,
					},
					hl = { fg = heirline.get_highlight("Statusline").fg },
				}

				Lsp = {
					condition = conditions.lsp_attached,
					init = function(self)
						local names = {}
						for _, server in pairs(vim.lsp.buf_get_clients(0)) do
							local lsp_alias = self.lsp_aliases[server.name] or server.name
							table.insert(names, lsp_alias)
						end
						table.sort(names)
						self.lsp_names = names
					end,
					hl = function(self)
						return LspServer.hl
					end,
					static = {
						lsp_aliases = {
							bashls = "shell",
							cssls = "css",
							eslint = "eslint",
							graphql = "gql",
							html = "html",
							jsonls = "json",
							lua_ls = "lua",
							tsserver = "tsx",
							prismals = "prisma",
							cssmodules_ls = "css",
							awk_ls = "awk",
							yamlls = "yaml",
							gopls = "go",
							rust_analyzer = "rust",
						},
					},
					flexible = 10,
					LspServer,
					-- Space(2),
					LspIndicator,
				}
			end

			local FileProperties = {
				condition = function(self)
					self.filetype = vim.bo.filetype

					local encoding = (vim.bo.fileencoding ~= "" and vim.bo.fileencoding) or vim.o.encoding
					self.encoding = (encoding ~= "utf-8") and encoding or nil

					local fileformat = vim.bo.fileformat
					if fileformat == "dos" then
						fileformat = "CRLF"
					elseif fileformat == "mac" then
						fileformat = "CR"
					else -- 'unix'
						fileformat = nil
					end

					self.fileformat = fileformat
					return self.fileformat or self.encoding
				end,
				heirline.surround({ "", "" }, nil, {
					provider = function(self)
						local sep = (self.fileformat and self.encoding) and " " or ""
						return table.concat({ " ", self.fileformat or "", sep, self.encoding or "", " " })
					end,
					hl = {
						fg = heirline.get_highlight("Statusline").bg,
						bg = heirline.get_highlight("Statusline").fg,
					},
				}),
				Space,
			}

			local ScrollPercentage = {
				condition = function()
					return conditions.width_percent_below(4, 0.035)
				end,
				-- %P  : percentage through file of displayed window
				provider = " %3(%P%) ",
				hl = heirline.get_highlight("Statusline"),
			}

			local Ruler = {
				heirline.surround({ "", "" }, nil, {
					-- :help 'statusline'
					-- ------------------
					-- %-2 : make item takes at least 2 cells and be left justified
					-- %l  : current line number
					-- %L  : number of lines in the buffer
					-- %c  : column number
					-- %V  : virtual column number as -{num}.  Not displayed if equal to '%c'.
					-- provider = '%9(%l:%L%) | %-3(%c%V%) ',
					provider = "%3(%l%):%-3(%c%)▎%L",
					-- provider = '%3(%l%):%-3(%c%)%L',
					-- provider = '%3(%l%):%-3(%c%)▎%L▎%3(%P%)',
					-- provider = '%3(%l%):%L|%-3(%c%)',
					hl = {
						fg = heirline.get_highlight("Statusline").bg,
						bg = heirline.get_highlight("Statusline").fg,
						-- bold = true,
					},
				}),
				Space,
			}

			local Buffers = heirline.make_buflist({
				provider = function(self)
					return string.format("(#%d, %s, %s)", self.bufnr, self.is_active, self.is_visible)
				end,
			})

			local CurrentSession = {
				condition = function()
					return utils.has_plugin("nvim-sessions") and require("nvim-sessions").current_session_name() ~= nil
				end,
				heirline.surround({ "", "" }, colors.fg_gutter, {
					provider = function()
						return "📌 " .. require("nvim-sessions").current_session_name()
					end,
					hl = {
						fg = heirline.get_highlight("Statusline").fg,
						-- fg = colors.blue,
						bg = colors.fg_gutter,
					},
				}),
				Space,
			}

			local TerminalName = {
				-- we could add a condition to check that buftype == 'terminal'
				-- or we could do that later (see #conditional-statuslines below)
				condition = function()
					return vim.bo.buftype == "terminal"
				end,
				provider = function()
					local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
					return string.format("%s %s", icons.common.terminal, tname)
				end,
				hl = { fg = colors.blue, bold = true },
			}

			local HelpFileName = {
				condition = function()
					return vim.bo.filetype == "help"
				end,
				provider = function()
					local filename = vim.api.nvim_buf_get_name(0)
					return vim.fn.fnamemodify(filename, ":t")
				end,
				hl = { fg = colors.blue },
			}

			local DefaultStatusline = {
				hl = heirline.get_highlight("Statusline"),
				{
					Mode,
					Space,
					SearchResults,
					CurrentSession,
					FileNameBlock,
					Space,
					Codeium,
					Space(4),
					Align,
					Diagnostics,
					Git,
					Space,
					Lsp,
					Ruler,
					FileProperties,
				},
			}

			local FileType = {
				provider = function()
					return string.upper(vim.bo.filetype)
				end,
				hl = { fg = heirline.get_highlight("Type").fg, bold = true },
			}

			local SpecialStatusline = {
				condition = function()
					return conditions.buffer_matches({
						buftype = { "nofile", "prompt", "help", "quickfix" },
						filetype = { "^git.*", "fugitive" },
					})
				end,
				FileType,
				Space,
				HelpFileName,
				Align,
			}

			local TerminalStatusline = {
				condition = function()
					return conditions.buffer_matches({ buftype = { "terminal" } })
				end,
				hl = { bg = colors.red },
				-- Quickly add a condition to the ViMode to only show it when buffer is active!
				{ condition = conditions.is_active, Mode, Space },
				FileType,
				Space,
				TerminalName,
				Align,
			}

			local StatusLines = {
				fallthrough = false,
				SpecialStatusline,
				TerminalStatusline,
				DefaultStatusline,
			}

			local WinBars = {
				fallthrough = false,
				{
					-- Hide the winbar for special buffers
					condition = function()
						return conditions.buffer_matches({
							buftype = { "nofile", "prompt", "help", "quickfix" },
							filetype = { "^git.*", "fugitive" },
						})
					end,
					init = function()
						vim.opt_local.winbar = nil
					end,
				},
				{
					-- A special winbar for terminals
					condition = function()
						return conditions.buffer_matches({ buftype = { "terminal" } })
					end,
					heirline.surround({ "", "" }, colors.red, {
						FileType,
						Space,
						TerminalName,
					}),
				},
				{
					-- An inactive winbar for regular files
					condition = function()
						return not conditions.is_active()
					end,
					heirline.surround(
						{ "", "" },
						colors.blue,
						{ hl = { fg = heirline.get_highlight("Statusline").fg, force = true }, FileNameBlock }
					),
				},
				-- A winbar for regular files
				heirline.surround({ "", "" }, colors.blue, { FileNameBlock }),
			}

			--------------------------------------------------------------------------------

			require("heirline").setup({
				statusline = StatusLines,
				-- winbar = WinBars,
				-- tabline = ...,
				-- statuscolumn = ...
			})
		end,
	},
}
