-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup plugins
require("lazy").setup({
  {
    "Shatur/neovim-ayu",
    config = function()
      require('ayu').setup({
        mirage = false,
        terminal = true,
      })
      vim.cmd('colorscheme ayu-dark')
    end
  },
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup({
        renderer = {
          icons = {
            show = {
              file = false,
              folder = false,
              folder_arrow = true,
              git = false,
            },
          },
          indent_markers = {
            enable = false,
          },
        },
        view = {
          side = "left",
          width = 30,
          signcolumn = "no",
        },
      })
      vim.opt.fillchars:append({ vert = ' ' })
      vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { silent = true })
    end
  }
})

-- Basic settings
vim.opt.number = true
vim.opt.termguicolors = true
