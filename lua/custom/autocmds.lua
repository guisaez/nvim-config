-- [[ Basic Autocommands ]]
-- See `:help lua-guide-autocommands`
--
local profiles = {
	core = {
		"bash",
		"lua",
		"luadoc",
		"vim",
		"vimdoc",
		"markdown",
		"markdown_inline",
		"diff",
		"query",
	},
	web = {
		"html",
		"css",
		"javascript",
		"typescript",
		"tsx",
	},
	beam = {
		"erlang",
		"elixir",
		"heex",
	},
	systems = {
		"c",
		"rust",
		"zig",
		"cpp",
	},
	infra = {
		"dockerfile",
		"yaml",
		"toml",
		"json",
	},
}

local env = os.getenv("NVIM_PROFILES") or "core"

local active = {}
if env == "all" then
	for _, group in pairs(profiles) do
		vim.list_extend(active, group)
	end
else
	for name in env:gmatch("[^,]+") do
		if profiles[name] then
			vim.list_extend(active, profiles[name])
		end
	end
end

for _, parser in ipairs(active) do
	if not pcall(vim.treesitter.language.inspect, parser) then
		local ok, err = pcall(vim.treesitter.install, parser)
		if not ok then
			vim.notify("treesitter: failed to install " .. parser .. ": " .. err, vim.log.levels.WARN)
		end
	end
end

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
