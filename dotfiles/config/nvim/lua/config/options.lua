-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- This file is automatically loaded by plugins.config

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.autoindent = true                                     --- Good auto indent
vim.opt.autowrite = true                                      -- Enable auto write
vim.opt.backup = false                                        --- automatically save a backup file
vim.opt.backspace = "indent,eol,start"                        --- Making sure backspace works
vim.opt.breakindent = true                                    --- maintain indent when wrapping indented lines
vim.opt.clipboard = "unnamed,unnamedplus"                     --- Copy-paste between vim and everything else
vim.opt.cmdheight = 1                                         --- Give more space for displaying messages
vim.opt.completeopt = "menu,menuone,noselect,longest,preview" --- Better autocompletion
vim.opt.conceallevel = 0                                      --- Show `` in markdown files
vim.opt.confirm = true                                        -- Confirm to save changes before exiting modified buffer
vim.opt.cursorline = true                                     -- Enable highlighting of the current line
vim.opt.dir = vim.fn.stdpath("data") .. "/swp"                -- swap file directory
vim.opt.emoji = false                                         --- Fix emoji display
vim.opt.encoding = "utf-8"                                    --- The encoding displayed
vim.opt.errorbells = false                                    --- Disables sound effect for errors
vim.opt.expandtab = true                                      -- Use spaces instead of tabs
-- vim.opt.fileencoding = "utf-8" --- The encoding written to file
vim.opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
-- vim.opt.fillchars = {
--   horiz = '━',
--   horizup = '┻',
--   horizdown = '┳',
--   vert = '┃',
--   vertleft = '┫',
--   vertright = '┣',
--   verthoriz = '╋',
-- }
vim.opt.foldcolumn = "0"
vim.opt.foldlevel = 99      --- Using ufo provider need a large value
vim.opt.foldlevelstart = 99 --- Expand all folds by default
vim.opt.foldnestmax = 0
vim.opt.formatoptions = "jcqlnt"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.hidden = true          -- Enable modified buffers in background
vim.opt.history = 500          -- Use the 'history' option to set the number of lines from command mode that are remembered.
vim.opt.hlsearch = true
vim.opt.ignorecase = true      --- Needed for smartcase
vim.opt.incsearch = true       --- Start searching before p:wqressing enter
vim.opt.inccommand = "nosplit" -- preview incremental substitute
vim.opt.laststatus = 2
-- vim.opt.laststatus = 3 --- Have a global statusline at the bottom instead of one for each window
-- vim.opt.laststatus = 0
-- vim.opt.lazyredraw = true --- Makes macros faster & prevent errors in complicated mappings
vim.opt.list = false --- Show some invisible characters (tabs...
vim.opt.listchars = "eol:¬,tab:>·,trail:~,extends:>,precedes:<"
-- vim.opt.listchars = "tab:>·,trail:~,extends:>,precedes:<"
vim.opt.matchpairs = { "(:)", "{:}", "[:]", "<:>" }
vim.opt.mouse = "a"           --- Enable mouse
vim.opt.number = true         --- Shows current line number
vim.opt.pumblend = 10         -- Popup blend
vim.opt.pumheight = 10        --- Max num of items in completion menu
vim.opt.redrawtime = 10000    --- Allow more time for loading syntax on large files
vim.opt.relativenumber = true --- Enables relative number
vim.opt.scrolloff = 8         --- Always keep space when scrolling to bottom/top edge
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
vim.opt.shiftround = true     -- Round indent
vim.opt.shiftwidth = 2        --- Change a number of space characeters inseted for indentation
vim.opt.showmode = false      --- Dont show mode since we have a statusline
vim.opt.showtabline = 1       --- show tabs if more than one (2 = always, 0 = hide)
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes:3"  --- Add extra sign column next to line number
vim.opt.smartcase = true      --- Uses case in search
vim.opt.smartindent = true    --- Makes indenting smart
vim.opt.smarttab = true       --- Makes tabbing smarter will realize you have 2 vs 4
vim.opt.softtabstop = 2       --- Insert 2 spaces for a tab
vim.opt.spell = false
vim.opt.spelllang = { "en" }
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true --- Put new windows right of current
-- vim.o.statuscolumn =
-- '%=%l%s%#FoldColumn#%{foldlevel(v:lnum) > foldlevel(v:lnum - 1) ? (foldclosed(v:lnum) == -1 ? " " : " ") : "  " }%*'
-- vim.opt.statuscolumn = "%=%{v:virtnum < 1 ? (v:relnum ? v:relnum : v:lnum < 10 ? v:lnum . '  ' : v:lnum) : ''}%=%s"
vim.opt.swapfile = false                               --- Swap not needed
vim.opt.tabstop = 2                                    --- Insert 2 spaces for a tab
vim.opt.termguicolors = true                           --- True color support
vim.opt.timeoutlen = 200                               --- Faster completion (cannot be lower than 200 because then commenting doesn't work)
vim.opt.ttimeoutlen = 0                                -- Time in milliseconds to wait for a key code sequence to complete
vim.opt.title = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir" -- set undo directory
vim.opt.undofile = true                                --- Sets undo to file
vim.opt.undolevels = 1000
vim.opt.updatetime = 200                               --- Faster completion
vim.opt.viminfo = "'1000"                              --- Increase the size of file history
vim.opt.wildignore = [[
 .git,.hg,.svn
 *.aux,*.out,*.toc
 *.o,*.obj,*.exe,*.dll,*.manifest,*.rbc,*.class
 *.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp
 *.avi,*.divx,*.mp4,*.webm,*.mov,*.m2ts,*.mkv,*.vob,*.mpg,*.mpeg
 *.mp3,*.oga,*.ogg,*.wav,*.flac
 *.eot,*.otf,*.ttf,*.woff
 *.doc,*.pdf,*.cbr,*.cbz
 *.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz,*.kgb
 *.swp,.lock,.DS_Store,._*
 */tmp/*,*.so,*.swp,*.zip,**/node_modules/**,**/target/**,**.terraform/**"
 ]]
vim.opt.wildignorecase = true -- When set case is ignored when completing file names and directories
vim.opt.wildmode =
"longest:full,full"           --- complete the longest common match and allow tabbing the results to fully complete them
vim.opt.winminwidth = 5       -- Minimum window width
vim.opt.wrap = false          --- Display long lines as just one line
vim.opt.writebackup = false   --- Not needed

vim.opt.backupdir:remove(".") --- keep backups out of the current directory
vim.opt.shortmess:append("WI")


if vim.fn.has("nvim-0.9.0") == 1 then
        vim.opt.splitkeep = "screen"
        vim.opt.shortmess:append({ C = true })
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

vim.g.minimal_italic_comments = true
vim.g.minimal_italic_keywords = false
vim.g.minimal_italic_booleans = false
vim.g.minimal_italic_functionls = false
vim.g.minimal_italic_variables = false
vim.g.minimal_transparent_background = false
