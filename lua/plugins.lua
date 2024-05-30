local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { "nvim-tree/nvim-tree.lua", name = "nvim-tree", dependencies = "nvim-tree/nvim-web-devicons" },
    { "projekt0n/github-nvim-theme", name = "github-theme", priority = 1000 },
    -- 引入 vim-bbye，关闭 tab 不会搞乱布局
    { 'akinsho/bufferline.nvim', version = "*", dependencies = { 'nvim-tree/nvim-web-devicons', 'moll/vim-bbye' } },
    { 'nvim-lualine/lualine.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },
    { 'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },
    { 'nvimdev/dashboard-nvim', event = 'VimEnter', dependencies = { 'nvim-tree/nvim-web-devicons' } },
    { 'ahmedkhalf/project.nvim', name = "project" },
})
