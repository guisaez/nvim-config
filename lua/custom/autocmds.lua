-- [[ Basic Autocommands ]]
-- See `:help lua-guide-autocommands`
--
-- Treesitter parser installation lives in lua/plugins/treesitter.lua (it must run
-- after nvim-treesitter loads). Here we just start treesitter for buffers whose
-- filetype has a parser available.
vim.api.nvim_create_autocmd("FileType", {
	callback = function(ev)
		local ft = vim.bo[ev.buf].filetype
		if vim.treesitter.language.get_lang(ft) then
			pcall(vim.treesitter.start, ev.buf)
		end
	end,
})

-- Highlight when yanking (copying) text
-- Try it with `yap` in normal mode
-- See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Trigger checktime to pickup external file changes (e.g. from Claude Code)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
	desc = "Reload files changed outisde Neovim",
	callback = function()
		vim.cmd("checktime")
	end,
})

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
	desc = "Reload files changed outside of Neovim",
	callback = function()
		if vim.fn.mode() ~= "c" then
			vim.cmd("checktime")
		end
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function()
		vim.lsp.buf.format({ async = false, timeout_ms = 3000 })
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	desc = "Remove trailing whitespace on save",
	callback = function()
		local view = vim.fn.winsaveview()
		vim.cmd([[%s/\s\+$//e]])
		vim.fn.winrestview(view)
	end,
})
