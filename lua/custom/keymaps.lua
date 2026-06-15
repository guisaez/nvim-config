-- [[ Keymaps ]]
-- See: `:help vim.keymap.set()`

-- [[ Basic ]]
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Delete without saving to register
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

-- Clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p')

-- LSP
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "[f]ormat buffer" })
vim.keymap.set("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "[d]iagnostic [q]uickfix" })
vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float, { desc = "[d]iagnostic [f]loat" })

-- Quickfix / loclist navigation (using ] [ convention)
vim.keymap.set("n", "]q", "<cmd>cnext<CR>zz", { desc = "Next [q]uickfix" })
vim.keymap.set("n", "[q", "<cmd>cprev<CR>zz", { desc = "Prev [q]uickfix" })
vim.keymap.set("n", "]l", "<cmd>lnext<CR>zz", { desc = "Next [l]oclist" })
vim.keymap.set("n", "[l", "<cmd>lprev<CR>zz", { desc = "Prev [l]oclist" })

-- Terminal
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { silent = true, desc = "Exit terminal" })

-- [[ Windows ]]
vim.keymap.set("n", "<leader>wh", "<C-w>h", { desc = "[w]indow left" })
vim.keymap.set("n", "<leader>wl", "<C-w>l", { desc = "[w]indow right" })
vim.keymap.set("n", "<leader>wj", "<C-w>j", { desc = "[w]indow down" })
vim.keymap.set("n", "<leader>wk", "<C-w>k", { desc = "[w]indow up" })

vim.keymap.set("n", "<leader>wH", "<C-w>H", { desc = "[w]indow → far left" })
vim.keymap.set("n", "<leader>wL", "<C-w>L", { desc = "[w]indow → far right" })
vim.keymap.set("n", "<leader>wJ", "<C-w>J", { desc = "[w]indow → bottom" })
vim.keymap.set("n", "<leader>wK", "<C-w>K", { desc = "[w]indow → top" })

vim.keymap.set("n", "<leader>wv", "<cmd>vnew<CR>", { desc = "[w]indow [v]split" })
vim.keymap.set("n", "<leader>ws", "<cmd>new<CR>", { desc = "[w]indow [s]plit" })
vim.keymap.set("n", "<leader>w=", "<C-w>=", { desc = "[w]indow equalize" })

vim.keymap.set("n", "<leader>wc", "<C-w>c", { desc = "[w]indow [c]lose" })
vim.keymap.set("n", "<leader>wo", "<C-w>o", { desc = "[w]indow close [o]thers" })

vim.keymap.set("n", "<leader>w+", "<C-w>+", { desc = "[w]indow height +" })
vim.keymap.set("n", "<leader>w-", "<C-w>-", { desc = "[w]indow height -" })
vim.keymap.set("n", "<leader>w>", "<C-w>>", { desc = "[w]indow width +" })
vim.keymap.set("n", "<leader>w<", "<C-w><", { desc = "[w]indow width -" })

-- [[ Tabs ]]
vim.keymap.set("n", "<leader>tn", "<cmd>tabnew<CR>", { desc = "[t]ab [n]ew" })
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>", { desc = "[t]ab [c]lose" })
vim.keymap.set("n", "<leader>to", "<cmd>tabonly<CR>", { desc = "[t]ab [o]nly" })
vim.keymap.set("n", "]t", "<cmd>tabnext<CR>", { desc = "Next tab" })
vim.keymap.set("n", "[t", "<cmd>tabprev<CR>", { desc = "Prev tab" })
vim.keymap.set("n", "<leader>tl", "<cmd>tablast<CR>", { desc = "[t]ab [l]ast" })
vim.keymap.set("n", "<leader>tf", "<cmd>tabfirst<CR>", { desc = "[t]ab [f]irst" })
