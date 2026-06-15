-- Auto-loaded by Neovim 0.12 (`:help lsp-config`).
-- Enabled conditionally from lua/lsp.lua based on $NVIM_ERLANG_LSP.
return {
	cmd = { "elp", "server" },
	filetypes = { "erlang" },
	root_markers = { "rebar.config", "erlang.mk", ".git" },
	settings = {
		elp = {
			diagnostics = {
				typesOnHover = { enable = true },
				disabled = { "W0030", "W0031", "W0032" },
			},
			signatureHelp = { enable = true },
		},
	},
}