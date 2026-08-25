-- Erlang LSP selection.
-- Uses vim.lsp.enable() (Neovim 0.11+).
-- Declarative configs are resolved from runtimepath `lsp/` directories —
-- lsp/elp.lua comes from nvim-lspconfig; lsp/erlang_ls.lua is local.
--
-- Pick one per environment via the $NVIM_ERLANG_LSP env var:
--   NVIM_ERLANG_LSP=elp        -> erlang-language-platform (elp server)
--   NVIM_ERLANG_LSP=erlang_ls  -> erlang_ls
--   NVIM_ERLANG_LSP=erlangls   -> same (alternate spelling, no underscore)
--   unset / anything else      -> no Erlang LSP
local erlang_lsp = os.getenv("NVIM_ERLANG_LSP")

local servers = {
	elp       = { config_name = "elp",       bin = "elp" },
	erlang_ls = { config_name = "erlang_ls", bin = "erlang_ls" },
	erlangls  = { config_name = "erlang_ls", bin = "erlang_ls" }, -- alias (no-underscore spelling)
}

local entry = servers[erlang_lsp]
if entry then
	if vim.fn.executable(entry.bin) == 1 then
		vim.lsp.enable(entry.config_name)
	else
		vim.notify(
			("NVIM_ERLANG_LSP=%s but `%s` not found on PATH"):format(erlang_lsp, entry.bin),
			vim.log.levels.WARN
		)
	end
end
