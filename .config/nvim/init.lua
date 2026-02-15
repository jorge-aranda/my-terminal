-- Install lazy.nvim automatically
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Configure plugins
require("lazy").setup({
  -- Theme
  {
    "folke/tokyonight.nvim",
    config = function()
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },
  
  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup()
      vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>')
    end,
  },
  
  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>')
      vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>')
    end,
  },
  
-- Autocompletion
{
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "L3MON4D3/LuaSnip",
  },
  config = function()
    local cmp = require('cmp')
    cmp.setup({
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
      }),
      sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
      },
      completion = {
        autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged }
      },
    })
  end,
},
  
-- Enhanced syntax highlighting
{
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
    if not status_ok then
      return
    end
    
    treesitter.setup({
      ensure_installed = { "lua", "python", "javascript", "typescript", "rust" },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
},

-- Git integration
{
  "lewis6991/gitsigns.nvim",
  config = function()
    require('gitsigns').setup({
      signs = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
      },
    })
    
    -- Keymaps for git
    vim.keymap.set('n', '<leader>gp', ':Gitsigns preview_hunk<CR>')     -- Preview changes
    vim.keymap.set('n', '<leader>gb', ':Gitsigns blame_line<CR>')       -- Git blame
    vim.keymap.set('n', '<leader>gn', ':Gitsigns next_hunk<CR>')        -- Next change
    vim.keymap.set('n', '<leader>gP', ':Gitsigns prev_hunk<CR>')        -- Previous change
  end,
},
})

-- YOUR BASIC CONFIGURATION GOES HERE (the one from above)

-- Basic configuration
vim.opt.number = true              -- Line numbers
vim.opt.relativenumber = true      -- Relative line numbers (useful for movements)
vim.opt.mouse = 'a'                -- Enable mouse
vim.opt.ignorecase = true          -- Ignore case when searching
vim.opt.smartcase = true           -- Don't ignore if search has uppercase
vim.opt.hlsearch = true            -- Highlight search results
vim.opt.wrap = false               -- Don't wrap long lines
vim.opt.breakindent = true         -- Preserve indentation in wrapped text
vim.opt.tabstop = 4                -- Spaces per tab
vim.opt.shiftwidth = 4             -- Spaces for indentation
vim.opt.expandtab = true           -- Use spaces instead of tabs
vim.opt.termguicolors = true       -- 24-bit colors
vim.opt.cursorline = true          -- Highlight current line
vim.opt.scrolloff = 8              -- Minimum lines above/below cursor
vim.opt.signcolumn = 'yes'         -- Always show sign column
vim.opt.clipboard = 'unnamedplus'  -- Use system clipboard

-- Leader key (use it for custom shortcuts)
vim.g.mapleader = ' '              -- Space as leader

-- Useful keymaps
vim.keymap.set('n', '<leader>w', ':w<CR>')        -- Space+w to save
vim.keymap.set('n', '<leader>q', ':q<CR>')        -- Space+q to quit
vim.keymap.set('n', '<C-d>', '<C-d>zz')           -- Center when scrolling down half page
vim.keymap.set('n', '<C-u>', '<C-u>zz')           -- Center when scrolling up half page
vim.keymap.set('v', '<leader>y', '"+y')           -- Copy to system clipboard
vim.keymap.set('n', '<leader>p', '"+p')           -- Paste from system clipboard

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})
