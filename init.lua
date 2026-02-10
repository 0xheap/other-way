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
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      vim.keymap.set('n', '<C-t>', ':Telescope colorscheme<CR>', { silent = true })
    end
  },
  "folke/tokyonight.nvim",
  "catppuccin/nvim",
  "rebelot/kanagawa.nvim",
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
          add_trailing = true,
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
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local colors = {
        blue   = '#80a0ff',
        cyan   = '#79dac8',
        black  = '#080808',
        white  = '#c6c6c6',
        red    = '#ff5189',
        violet = '#d183e8',
        grey   = '#303030',
      }

      local bubbles_theme = {
        normal = {
          a = { fg = colors.black, bg = colors.violet },
          b = { fg = colors.white, bg = colors.grey },
          c = { fg = colors.white },
        },
        insert = { a = { fg = colors.black, bg = colors.blue } },
        visual = { a = { fg = colors.black, bg = colors.cyan } },
        replace = { a = { fg = colors.black, bg = colors.red } },
        inactive = {
          a = { fg = colors.white, bg = colors.black },
          b = { fg = colors.white, bg = colors.black },
          c = { fg = colors.white },
        },
      }

      require('lualine').setup {
        options = {
          theme = bubbles_theme,
          component_separators = '',
          section_separators = { left = '', right = '' },
        },
        sections = {
          lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
          lualine_b = { 'filename', 'branch' },
          lualine_c = { '%=' },
          lualine_x = {},
          lualine_y = { { 'filetype', icons_enabled = false }, 'progress' },
          lualine_z = { { 'location', separator = { right = '' }, left_padding = 2 } },
        },
        inactive_sections = {
          lualine_a = { 'filename' },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = { 'location' },
        },
        extensions = { 'nvim-tree' },
      }
    end
  },
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({ default = true })
    end
  },
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        cmdline = {
          enabled = true,
          view = "cmdline_popup",
          format = {
            cmdline = { pattern = "^:", icon = ">", lang = "vim" },
            search_down = { kind = "search", pattern = "^/", icon = "", lang = "regex" },
            search_up = { kind = "search", pattern = "^%?", icon = "", lang = "regex" },
            filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
            lua = { pattern = "^:%s*lua%s+", icon = "☾", lang = "lua" },
            help = { pattern = "^:%s*he?l?p?%s+", icon = "?" },
          },
        },
        messages = {
          enabled = true,
          view = "notify",
        },
        popupmenu = {
          enabled = true,
          backend = "nui",
        },
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          bottom_search = false,
          command_palette = true,
          long_message_to_split = true,
        },
      })
    end
  },
  {
    "goolord/alpha-nvim",
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      
      dashboard.section.header.val = {
        "                                                     ",
        "                                                     ",
        "                                                     ",
        "          // Working close to the memory           ",
        "                                                     ",
        "                                                     ",
        "                                                     ",
      }
      
      dashboard.section.buttons.val = {}
      dashboard.section.footer.val = ""
      
      dashboard.config.opts.noautocmd = true
      dashboard.opts.layout[1].val = 8
      
      alpha.setup(dashboard.config)
    end
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup()
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.config.pyright = {
        cmd = { 'pyright-langserver', '--stdio' },
        filetypes = { 'python' },
        root_markers = { 'pyproject.toml', 'setup.py', '.git' },
      }
      
      vim.lsp.enable('pyright')
      
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { silent = true })
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { silent = true })
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.hover, { silent = true })
      
      -- Style hover popup with grey border
      vim.cmd([[highlight FloatBorder guifg=#808080 guibg=NONE]])
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, {
          border = "rounded",
          max_width = 80,
          max_height = 20,
        }
      )
    end
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        }),
        sources = {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
        },
      })
    end
  },
  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup({
        direction = 'float',
        float_opts = {
          border = 'curved',
        },
      })
      vim.keymap.set('n', '<C-\\>', ':ToggleTerm<CR>', { silent = true })
      vim.keymap.set('t', '<C-\\>', '<C-\\><C-n>:ToggleTerm<CR>', { silent = true })
    end
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup({
        scope = { enabled = true },
      })
    end
  }
})

-- Basic settings
vim.opt.number = true
vim.opt.termguicolors = true
