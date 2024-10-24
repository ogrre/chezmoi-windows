-- Config neovim
vim.g.mapleader = " "
vim.opt.termguicolors = true
vim.opt.encoding = "UTF-8"
vim.opt.number = true
vim.wo.scrolloff = 20
local km = vim.keymap

-- Lazy 
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
    -- Theme
    { "bluz71/vim-moonfly-colors",        name = "moonfly",   lazy = false, priority = 1000 },
    -- LSP
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'VonHeikemen/lsp-zero.nvim',        branch = 'v3.x' },
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/nvim-cmp' },
    { 'L3MON4D3/LuaSnip' },
    -- Treesitter
    { "nvim-treesitter/nvim-treesitter",  build = ":TSUpdate" },
    -- Telescope
    { "nvim-telescope/telescope.nvim",    tag = '0.1.5',      dependencies = { 'nvim-lua/plenary.nvim' } },
    -- Noice (command in middle of screen)
    {"folke/noice.nvim",
    event = "VeryLazy",
    opts = {
        -- add any options here
    },
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    }
    },
    -- Fern
    {"lambdalisue/fern.vim",
    dependencies = {
        "lambdalisue/fern-git-status.vim",
        "lambdalisue/fern-hijack.vim",
        'lambdalisue/nerdfont.vim',
        "lambdalisue/fern-renderer-nerdfont.vim",
        "yuki-yano/fern-preview.vim",
    }
    },
    -- nvim-cmp
    {'hrsh7th/nvim-cmp',
    requires = {
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-path' },
        { 'hrsh7th/cmp-nvim-lua' },
    }
    },
    -- Comment nvim
    {'numToStr/Comment.nvim',
            opts = {
            -- add any options here
        },
            lazy = false,
    },
    {"NeogitOrg/neogit",
      dependencies = {
            "nvim-lua/plenary.nvim",         -- required
            "sindrets/diffview.nvim",        -- optional - Diff integration
            -- Only one of these is needed, not both.
            "ibhagwan/fzf-lua",              -- optional
      },
      config = true
    },
    {"github/copilot.vim"},
    -- Cheatsheet.nvim
    {
        'sudormrfbin/cheatsheet.nvim',
        requires = {
            {'nvim-telescope/telescope.nvim'},
            {'nvim-lua/popup.nvim'},
            {'nvim-lua/plenary.nvim'},
        }
    },
    -- Grug-far.nvim
    {
        'MagicDuck/grug-far.nvim',
        config = function()
            require('grug-far').setup()
        end
    },
    -- Which-key
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
    },
        keys = {
            {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
        desc = "Buffer Local Keymaps (which-key)",
            },
        },
    }
})

-- LSP
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
    lsp_zero.default_keymaps({ buffer = bufnr })
end)

-- Mason
require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        'lua_ls',
        'rust_analyzer',
    },
    handlers = {
        lsp_zero.default_setup,
    },
})

-- Treesitter configuration
require('nvim-treesitter.configs').setup({
    ensure_installed = {
        "html",
        "css",
        "json",
        "javascript",
        "lua",
        "php",
        "dockerfile",
        "yaml",
    },
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
    },
    autotag = {
        enable = true,
    },
})

-- Autocompletion LSP
local cmp = require('cmp')

cmp.setup({
    sources = {
        {name = 'nvim_lsp'},
        {name = 'buffer'},
        {name = 'path'},
        {name = 'luasnip'},
        {name = 'treesitter'},
    },
    mapping = {
        ['<C-y>'] = cmp.mapping.confirm({select = false}),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<Up>'] = cmp.mapping.select_prev_item({behavior = 'select'}),
        ['<Down>'] = cmp.mapping.select_next_item({behavior = 'select'}),
        ['<C-p>'] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_prev_item({behavior = 'insert'})
            else
                cmp.complete()
            end
        end),
        ['<C-n>'] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_next_item({behavior = 'insert'})
            else
                cmp.complete()
            end
        end),
    },
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
})

-- Noice
require("noice").setup({
    lsp = {
        override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
    },
    presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
    },
})

-- Neogit
require('neogit').setup()

-- Comment 
require('Comment').setup()

-- Fern
vim.g['fern#renderer'] = 'nerdfont'

-- Fern -- Preview -- disable 'modifiable'
vim.g.preview_nvim_disable_sync = 1

-- Theme
vim.cmd [[colorscheme moonfly]]

-- MAPPING
-- Fern
km.set("n", "<leader>ee", ":Fern . -drawer -width=60 -toggle<CR>", { silent = true, noremap = true })
km.set("n", "<leader>es", ":Fern . -reveal=% -drawer -width=60 -toggle<CR>", { silent = true, noremap = true })

-- Comment.nvim mappings
km.set("n", "<leader>cc", "gcc", { noremap = false })
km.set("v", "<leader>c", "gc", { noremap = false })

-- Auto Indentation settings
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.cindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smarttab = true

-- Fern -- Preview -- enable 'modifiable' temporarily
vim.cmd [[
  augroup FernPreview
    autocmd!
    autocmd FileType fern-preview setlocal modifiable
  augroup END
]]

-- Ensure Fern Preview works
vim.cmd [[
    autocmd FileType fern setlocal nobuflisted
]]

-- Cheatsheet.nvim configuration
require('cheatsheet').setup({
    bundled_cheatsheets = true,
    bundled_plugin_cheatsheets = true,
    include_only_installed_plugins = true,
    telescope_mappings = {
        ['<CR>'] = require('cheatsheet.telescope.actions').select_or_fill_commandline,
        ['<A-CR>'] = require('cheatsheet.telescope.actions').select_or_execute,
        ['<C-Y>'] = require('cheatsheet.telescope.actions').copy_cheat_value,
        ['<C-E>'] = require('cheatsheet.telescope.actions').edit_user_cheatsheet,
    }
})

-- Grug-far.nvim configuration
require('grug-far').setup()

-- Mappings
km.set('n', '<leader>?', ':Cheatsheet<CR>', { silent = true, noremap = true })
km.set('n', '<leader>gs', ':Neogit<CR>', { silent = true, noremap = true })
km.set('n', '<leader>gr', ':GrugFar<CR>', { silent = true, noremap = true })

-- Telescope
km.set('n', '<leader>s', ':Telescope find_files<CR>', { silent = true, noremap = true })
