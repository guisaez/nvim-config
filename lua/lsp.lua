-- Erlang LSP selection.
-- Server configs live as declarative files in `lsp/` (auto-loaded by 0.12).
-- Pick one per environment via the $NVIM_ERLANG_LSP env var:
--   NVIM_ERLANG_LSP=elp       -> erlang-language-platform (elp server)
--   NVIM_ERLANG_LSP=erlangls  -> erlang_ls
--   unset / anything else     -> no Erlang LSP
local erlang_lsp = os.getenv("NVIM_ERLANG_LSP")

local servers = {
	elp = "elp",
	erlangls = "erlang_ls",
}

local server = servers[erlang_lsp]
if server then
	if vim.fn.executable(server) == 1 then
		vim.lsp.enable(erlang_lsp)
	else
		vim.notify(
			("NVIM_ERLANG_LSP=%s but `%s` not found on PATH"):format(erlang_lsp, server),
			vim.log.levels.WARN
		)
	end
end