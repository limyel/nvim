local status, nvim_tree = pcall(require, "nvim-tree")
if not status then
  vim.notify("没有找到 nvim-tree")
  return
end

-- 列表操作快捷键
local list_keys = require('keybindings').nvimTreeList
nvim_tree.setup({
  sort_by = "case_sensitive",
  -- 是否显示 git 状态
  git = {
    enable = true,
  },
  -- 过滤文件
  filters = {
    dotfiles = false, -- 是否隐藏 dotfile
    -- custom = { "node_modules" }, -- 隐藏 node_modules 目录
  },
  view = {
    -- 文件浏览器展示位置，左侧：left, 右侧：right
    side = "left",
    -- 行号是否显示
    number = false,
    relativenumber = false,
    signcolumn = "yes", -- 显示图标
    width = 40,
  },
  actions = {
    open_file = {
      -- 首次打开大小适配
      resize_window = true,
      -- 打开文件时关闭
      quit_on_open = false,
    },
  },
  renderer = {
    group_empty = true,
  },
  system_open = {
    cmd = 'open', -- mac 设置为 open，Windows 设置为 wsl-open
  },
  on_attach = function(bufnr)
    local api = require('nvim-tree.api')
    local opts = { noremap = true, silent = true, buffer = bufnr }

    -- 打开文件或文件夹
    vim.keymap.set('n', '<CR>', api.node.open.edit, opts)
    vim.keymap.set('n', 'o', api.node.open.edit, opts)
    vim.keymap.set('n', '<2-LeftMouse>', api.node.open.edit, opts)
    -- 分屏打开文件
    vim.keymap.set('n', 'v', api.node.open.vertical, opts)
    vim.keymap.set('n', 'h', api.node.open.horizontal, opts)
    -- 显示隐藏文件
    vim.keymap.set('n', 'i', api.tree.toggle_hidden_filter, opts) -- 对应 filters 中的 custom (node_modules)
    -- vim.keymap.set('n', '.', api.tree.toggle_dotfiles, opts) -- Hide (dotfiles)
    -- 文件操作
    vim.keymap.set('n', '<F5>', api.tree.reload, opts)
    vim.keymap.set('n', 'a', api.fs.create, opts)
    vim.keymap.set('n', 'd', api.fs.remove, opts)
    vim.keymap.set('n', 'r', api.fs.rename, opts)
    vim.keymap.set('n', 'x', api.fs.cut, opts)
    vim.keymap.set('n', 'c', api.fs.copy.node, opts)
    vim.keymap.set('n', 'p', api.fs.paste, opts)
    vim.keymap.set('n', 's', api.node.run.system, opts)
  end,
})

-- 自动关闭
vim.cmd([[
  autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif
]])
