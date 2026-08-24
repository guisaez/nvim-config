-- Auto-loaded by Neovim 0.12 (`:help lsp-config`).
-- Enabled conditionally from lua/lsp.lua based on $NVIM_ERLANG_LSP.
return {
	cmd = { "erlang_ls" },
	filetypes = { "erlang" },
	root_markers = { "rebar.config", "erlang_ls.config", ".git" },
}