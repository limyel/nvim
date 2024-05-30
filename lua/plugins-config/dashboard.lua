local status, db = pcall(require, "dashboard")
if not status then
  vim.notify("没有找到 dashboard")
  return
end

db.setup({
  theme = "doom",
  shortcut_type = "number",
  config = {
    week_header = {
      enable = true,
    },
    center = {
      {
        icon = "  ",
        desc = "Projects                            ",
        action = "Telescope projects",
      },
      {
        icon = "  ",
        desc = "Recently files                      ",
        action = "Telescope oldfiles",
      },
      {
        icon = "  ",
        desc = "Edit Projects                       ",
        action = "edit ~/.local/share/nvim/project_nvim/project_history",
      },
      {
        icon = "  ",
        desc = "Edit init.lua                       ",
        action = "edit ~/.config/nvim/init.lua",
      },
    }
  },
})

