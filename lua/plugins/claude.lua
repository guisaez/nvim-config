local active_profile = os.getenv("NVIM_CLAUDE_PROFILE") or "default"

return {
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim" },
	opts = {
		log_level = "error",
		terminal = {
			split_side = "left",
			split_width_percentage = 0.3,
			auto_close = true,
		},
		focus_after_send = true,
		diff_opts = {
			layout = "horizontal",
			open_in_new_tab = true,
			keep_terminal_focus = false,
			hide_terminal_in_new_tab = false,
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
	keys = {
		{ "<leader>a", nil, desc = "[A]I/Claude" },
		{ "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "[A]I toggle Claude" },
		{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "[A]I focus Claude" },
		{ "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "[A]I resume session" },
		{ "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "[A]I continue session" },
		{ "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "[A]I select model" },
		{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "[A]I add current buffer" },
		{ "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "[A]I send selection" },
		{
			"<leader>as",
			"<cmd>ClaudeCodeTreeAdd<cr>",
			desc = "[A]I add file from tree",
			ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
		},
		{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "[A]I accept diff" },
		{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "[A]I deny diff" },
		{ "<leader>aw", "<cmd>ClaudeWork<cr>", desc = "[A]I switch to work" },
		{ "<leader>ap", "<cmd>ClaudePersonal<cr>", desc = "[A]I switch to personal" },
		{ "<leader>ax", "<cmd>ClaudeDefault<cr>", desc = "[A]I switch to default" },
		{ "<C-n>", "<C-\\><C-n>", mode = "t", desc = "Exit terminal mode" },
	},
}
