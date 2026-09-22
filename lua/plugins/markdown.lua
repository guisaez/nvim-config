return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = "markdown",
	opts = {
		enabled = true,
		-- Skip terminal-mode rendering over SSH; matches the SSH_TTY redraw-cost
		-- gating in lua/custom/options.lua (relativenumber, cursorline).
		render_modes = vim.env.SSH_TTY and { "n", "c" } or { "n", "c", "t" },
		debounce = 100,
		file_types = { "markdown" },
	},
}
