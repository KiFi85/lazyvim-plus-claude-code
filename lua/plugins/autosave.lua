-- ~/.config/nvim/lua/plugins/autosave.lua
return {
  {
    "okuuva/auto-save.nvim",
    cmd = "ASToggle",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      enabled = true,
      debounce_delay = 200,
      execution_message = {
        enabled = false,
      },
    },
    keys = {
      { "<leader>ua", "<cmd>ASToggle<cr>", desc = "Toggle Auto Save" },
    },
  },
}
