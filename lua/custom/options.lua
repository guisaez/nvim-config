-- Make linenumbers default
vim.o.number = true

vim.o.relativenumber = not vim.env.SSH_TTY

vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.smartindent = true

-- Disable highligh search. Disable persistent highlighting
vim.o.hlsearch = true

-- Enable incremental search. It will jump to the first match as you are typing
vim.o.incsearch = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

if vim.env.SSH_TTY then
	vim.g.clipboard = "osc52"
else
	vim.g.clipboard = {
		name = "macOS",
		copy = { ["+"] = "pbcopy", ["*"] = "pbcopy" },
		paste = { ["+"] = "pbpaste", ["*"] = "pbpaste" },
	}
end
-- Don't auto-sync all registers to system clipboard.
-- Use <leader>y / <leader>p for intentional clipboard ops.

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS |C or one or more capital letter in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.signcolumn = "yes"

vim.o.updatetime = 1000

vim.o.timeoutlen = 300

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.o.inccommand = "split"

vim.o.cursorline = not vim.env.SSH_TTY

vim.o.scrolloff = 10

-- Automatically reload files changed outside of Neovim
vim.o.autoread = true

-- if performing an operation that would fail due to unsaved chanages in the buffer (like: `:q`),
-- instead rasise a fialog asking if you wish to save the current files(s)
-- See `:help 'confirm'`
vim.o.confirm = true
