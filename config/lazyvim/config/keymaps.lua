local map = vim.keymap.set

map({ "i", "n", "v" }, "<C-q>", "<cmd>wqa<cr>", { desc = "Save & Exit" })
map("n", "<leader>y", "<cmd>.w! ~/.share/.vbuf<cr>", { desc = "Copy to share" })
map("v", "<leader>y", "<cmd>'<,'>w! ~/.share/.vbuf<cr>", { desc = "Copy selected to share" })
map("n", "<leader>p", "<cmd>r ~/.share/.vbuf<cr>", { desc = "Paste from share" })

map("n", "goa", "<cmd>GoAlternate<cr>", { desc = "GoAlternate" })
map("n", "goc", "<cmd>GoCallers<cr>", { desc = "GoCallers" })
map("n", "god", "<cmd>GoDef<cr>", { desc = "GoDef" })
map("n", "gof", "<cmd>GoFmt<cr>", { desc = "GoFmt" })
map("n", "goi", "<cmd>GoImports<cr>", { desc = "GoImports" })
map("n", "gor", "<cmd>GoRename<cr>", { desc = "GoRename" })
map("n", "gos", "<cmd>GoFillStruct<cr>", { desc = "GoFillStruct" })
map("n", "got", "<cmd>GoAddTags<cr>", { desc = "GoAddTags" })

map("n", "gb", "<cmd>Git blame<cr>", { desc = "Git blame current file" })
map("n", "gq", "<cmd>q<cr>", { desc = "Close this" })
