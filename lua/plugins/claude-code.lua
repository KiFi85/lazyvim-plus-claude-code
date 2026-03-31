return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = function()
    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "*claude*",
      callback = function()
        vim.wo.winhighlight = "Normal:ClaudeNormal"
        vim.wo.winbar = ""
        vim.wo.statusline = ""
      end,
    })

    require("claudecode").setup({
      terminal = {
        split_side = "right",
        split_width_percentage = 0.30,
        provider = "snacks",
        auto_close = true,
        snacks_win_opts = {
          border = "none",
          position = "right",
        },
      },
    })

    vim.keymap.set({ "n", "t", "i" }, "<C-,>", "<C-\\><C-n><cmd>ClaudeCode<CR>", { desc = "Toggle Claude Code" })
    vim.keymap.set(
      { "n", "t", "i" },
      "<C-'>",
      "<C-\\><C-n><cmd>lua Snacks.terminal.toggle()<CR>",
      { desc = "Toggle bash terminal" }
    )
  end,
}
