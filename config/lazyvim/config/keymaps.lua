local map = vim.keymap.set

map({ "i", "n", "v" }, "<C-q>", "<cmd>wqa<cr>", { desc = "Escape and Clear hlsearch" })
map({ "n", "v" }, "<leader>y", "<cmd>w! ~/.share/.vbuf<cr>", { desc = "Escape and Clear hlsearch" })
map("n", "<leader>p", "<cmd>r ~/.share/.vbuf<cr>", { desc = "Escape and Clear hlsearch" })

map("n", "goa", "<cmd>GoAlternate<cr>", { desc = "GoAlternate" })
map("n", "goc", "<cmd>GoCallers<cr>", { desc = "GoCallers" })
map("n", "gof", "<cmd>GoFmt<cr>", { desc = "GoFmt" })
map("n", "goi", "<cmd>GoImports<cr>", { desc = "GoImports" })
map("n", "gor", "<cmd>GoRename<cr>", { desc = "GoRename" })
map("n", "gos", "<cmd>GoFillStruct<cr>", { desc = "GoFillStruct" })
map("n", "got", "<cmd>GoAddTags<cr>", { desc = "GoAddTags" })
