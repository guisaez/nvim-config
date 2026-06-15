-- Treesitter parser management.
--
-- Parsers are grouped into profiles and selected via the NVIM_PROFILES env var
-- (comma-separated profile names, or "all"). Installation runs from this plugin's
-- `config` so nvim-treesitter (main branch) is actually loaded — the previous
-- approach called the non-existent `vim.treesitter.install` from an autocmd that
-- ran before plugins loaded. The FileType start hook lives in custom/autocmds.lua.

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

local function active_parsers()
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
	return active
end

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup()

			local installed = {}
			for _, p in ipairs(require("nvim-treesitter.config").get_installed("parsers")) do
				installed[p] = true
			end

			local missing = {}
			for _, parser in ipairs(active_parsers()) do
				if not installed[parser] then
					missing[#missing + 1] = parser
				end
			end

			if #missing > 0 then
				require("nvim-treesitter").install(missing)
			end
		end,
	},
}
