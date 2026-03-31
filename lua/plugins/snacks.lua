vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "SnacksDashboardProjectTitle", { fg = "#98c379", bold = true })
    vim.api.nvim_set_hl(0, "SnacksDashboardProjectItem", { fg = "#98c379" })
    vim.api.nvim_set_hl(0, "SnacksDashboardProjectBranch", { fg = "#c678dd" })
  end,
})
vim.api.nvim_set_hl(0, "SnacksDashboardProjectTitle", { fg = "#98c379", bold = true })
vim.api.nvim_set_hl(0, "SnacksDashboardProjectItem", { fg = "#98c379" })
vim.api.nvim_set_hl(0, "SnacksDashboardProjectBranch", { fg = "#c678dd" })

local function recent_project_dirs(limit)
  local dirs = {}
  local seen = {}

  for _, file in ipairs(vim.v.oldfiles or {}) do
    if type(file) == "string" and file ~= "" then
      local root = Snacks.git.get_root(file)
      if root and vim.fn.isdirectory(root) == 1 and not seen[root] then
        seen[root] = true
        table.insert(dirs, root)
        if #dirs >= limit then
          break
        end
      end
    end
  end

  return dirs
end

local function project_section()
  local items = {
    {
      text = { "RECENT PROJECTS", hl = "SnacksDashboardProjectTitle" },
      padding = 1,
    },
  }

  local dirs = recent_project_dirs(8)
  local max_width = 50

  for i, dir in ipairs(dirs) do
    local name = vim.fn.fnamemodify(dir, ":t")

    local branch_result =
      vim.fn.systemlist("git -C " .. vim.fn.shellescape(dir) .. " rev-parse --abbrev-ref HEAD 2>/dev/null")
    local branch = (branch_result and branch_result[1] and branch_result[1] ~= "") and branch_result[1] or nil

    local branch_str = branch and ("  [" .. branch .. "]") or ""
    local text_len = 3 + #name + #branch_str
    local pad = string.rep(" ", math.max(1, max_width - text_len))

    items[#items + 1] = {
      text = {
        { "   " .. name, hl = "SnacksDashboardProjectItem" },
        { branch_str, hl = "SnacksDashboardProjectBranch" },
        { pad .. tostring(i), hl = "SnacksDashboardKey" },
      },
      key = tostring(i),
      action = function()
        vim.fn.chdir(dir)
        Snacks.explorer.open({ cwd = dir })
      end,
    }
    items[#items + 1] = { padding = 1 }
  end

  items[#items + 1] = {
    padding = 2,
  }

  return items
end

return {
  "folke/snacks.nvim",
  opts = {
    explorer = {
      enabled = true,
      replace_netrw = true,
    },
    picker = {
      enabled = true,
      sources = {
        explorer = {
          hidden = true,
          ignored = true,
        },
      },
    },
    dashboard = {
      sections = {
        { section = "header" },
        { padding = 2 },
        project_section,
        { section = "startup" },
      },
    },
    terminal = {
      win = {
        position = "bottom",
        height = 0.3,
        border = "none",
        wo = {
          winhighlight = "Normal:TermNormal",
          winbar = "",
          statusline = "",
        },
      },
    },
  },
}
