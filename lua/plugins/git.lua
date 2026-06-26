return {
	{
		"tpope/vim-fugitive",
		keys = {
			{ "<leader>gs", "<cmd>Git<CR>", desc = "[g]it [s]tatus" },
		},
	},
	{
		"sindrets/diffview.nvim",
		keys = {
			{ "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "[g]it [d]iff" },
			{ "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "[g]it file [h]istory" },
			{ "<leader>gH", "<cmd>DiffviewFileHistory<CR>", desc = "[g]it repo [H]istory" },
			{ "<leader>gq", "<cmd>DiffviewClose<CR>", desc = "[g]it diff [q]uit" },
		},
	},
}
