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
      title = "Recent Projects",
      padding = 1,
    },
  }

  local dirs = recent_project_dirs(8)

  for i, dir in ipairs(dirs) do
    local name = vim.fn.fnamemodify(dir, ":t")

    local branch_result =
      vim.fn.systemlist("git -C " .. vim.fn.shellescape(dir) .. " rev-parse --abbrev-ref HEAD 2>/dev/null")
    local branch = (branch_result and branch_result[1] and branch_result[1] ~= "") and branch_result[1] or nil

    local display = branch and (name .. "  [" .. branch .. "]") or name

    items[#items + 1] = {
      icon = " ",
      title = display,
      key = tostring(i),
      action = function()
        vim.fn.chdir(dir)
        Snacks.explorer.open({ cwd = dir })
      end,
    }
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
