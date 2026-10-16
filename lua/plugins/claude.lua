local active_profile = os.getenv("NVIM_CLAUDE_PROFILE") or "default"

return {
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim", "hebercosfer/floating-claude.nvim" },
	opts = function()
		return {
			log_level = "error",
			git_repo_cwd = true,
			focus_after_send = false,
			terminal = {
				split_side = "right",
				split_width_percentage = 0.38,
				provider = "snacks",
			},
			diff_opts = {
				auto_close_on_accept = true,
				vertical_split = true,
				open_in_current_tab = true,
				auto_resize_terminal = true,
			},
		}
	end,
	keys = {
		{ "<leader>a", nil, desc = "AI Claude Code" },
		{ "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
		{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
		{ "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume session" },
		{ "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue last" },
		{ "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model" },
		{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add buffer to context" },
		{ "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection" },
		{
			"<leader>as",
			"<cmd>ClaudeCodeTreeAdd<cr>",
			desc = "Add file from tree",
			ft = { "NvimTree", "neo-tree", "oil", "minifiles" },
		},
		{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
		{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
		{ "<leader>aS", "<cmd>ClaudeCodeStatus<cr>", desc = "Connection status" },
		{ "<leader>ax", "<cmd>ClaudeCodeStop<cr>", desc = "Stop server" },
		{ "<leader>aX", "<cmd>ClaudeCodeStart<cr>", desc = "Start server" },
		{ "<leader>aw", "<cmd>ClaudeWork<cr>", desc = "Switch to work profile" },
		{ "<leader>ap", "<cmd>ClaudePersonal<cr>", desc = "Switch to personal profile" },
		{ "<leader>aD", "<cmd>ClaudeDefault<cr>", desc = "Switch to default profile" },
		{ "<leader>al", ":ClaudeCodeAdd % ", desc = "Add buffer w/ line range" },
		{ "<leader>at", "<cmd>ClaudeToggleProvider<cr>", desc = "Toggle snacks/none (tmux) provider" },
		{
			"<C-,>",
			function()
				require("floating-claude").toggle_mini()
			end,
			mode = { "n", "x" },
			desc = "[A]I toggle floating Claude",
		},
	},
	config = function(_, opts)
		local function sync_claude_env(profile)
			if profile == "default" then
				vim.env.CLAUDE_CONFIG_DIR = nil
			else
				vim.env.CLAUDE_CONFIG_DIR = vim.fn.expand("~/.claude/" .. profile)
				vim.fn.mkdir(vim.env.CLAUDE_CONFIG_DIR, "p")
			end
		end

		sync_claude_env(active_profile)

		require("claudecode").setup(opts)

		local function kill_claude_terminal()
			local killed = false
			for _, buf in ipairs(vim.api.nvim_list_bufs()) do
				if not vim.api.nvim_buf_is_valid(buf) then
					goto continue
				end
				local ok, buftype = pcall(function()
					return vim.bo[buf].buftype
				end)
				if ok and buftype == "terminal" and vim.api.nvim_buf_get_name(buf):match("claude") then
					local job_id = vim.b[buf].terminal_job_id
					if job_id then
						pcall(vim.fn.jobstop, job_id)
					end
					pcall(vim.api.nvim_buf_delete, buf, { force = true })
					killed = true
				end
				::continue::
			end
			return killed
		end

		local function switch_profile(new_profile)
			if active_profile == new_profile then
				vim.cmd("ClaudeCode")
				return
			end
			active_profile = new_profile
			sync_claude_env(active_profile)
			vim.notify("Claude: switched to " .. new_profile)
			local was_running = kill_claude_terminal()
			if was_running then
				local orig_notify = vim.notify
				vim.notify = function(msg, ...)
					if type(msg) == "string" and (msg:match("exited with code %-1") or msg:match("ECONNRESET")) then
						return
					end
					return orig_notify(msg, ...)
				end
				vim.defer_fn(function()
					vim.notify = orig_notify
					vim.cmd("ClaudeCode")
				end, 500)
			end
		end

		vim.api.nvim_create_user_command("ClaudeToggleProvider", function()
			local terminal = require("claudecode.terminal")
			local new_provider = terminal.defaults.provider == "none" and "snacks" or "none"
			terminal.defaults.provider = new_provider
			vim.notify("Claude: terminal provider -> " .. new_provider)
		end, {})
		vim.api.nvim_create_user_command("ClaudeWork", function()
			switch_profile("work")
		end, {})
		vim.api.nvim_create_user_command("ClaudePersonal", function()
			switch_profile("personal")
		end, {})
		vim.api.nvim_create_user_command("ClaudeDefault", function()
			switch_profile("default")
		end, {})
	end,
}
