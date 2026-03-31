return {
  {
    "navarasu/onedark.nvim",
    priority = 1000,
    opts = {
      style = "darker",
    },
    config = function(_, opts)
      require("onedark").setup(opts)
      require("onedark").load()

      vim.schedule(function()
        vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#98c379", bold = true })
        vim.opt.fillchars = { vert = "│" }
        vim.api.nvim_set_hl(0, "ClaudeNormal", { bg = "#181a1f" })
        vim.api.nvim_set_hl(0, "TermNormal", { bg = "#181a1f" })
      end)
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
}
