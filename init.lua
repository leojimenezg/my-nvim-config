-- [[ BASIC VIM OPTIONS ]]
--  NOTE: Must happen before any other configuration or plugin in order to properly function.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if a Nerd Font is installed and selected in the terminal.
vim.g.have_nerd_font = false

-- Show line number
vim.opt.number = true
-- Show relative line number
vim.opt.relativenumber = true
-- Show the cursor as a bar
vim.opt.guicursor = ""
-- Spaces representing a tab
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- Enable mouse in all modes
vim.opt.mouse = "a"

-- Show the mode in bar
vim.opt.showmode = true

-- Sync clipboard between OS and Neovim.
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
-- vim.opt.undofile = true

-- Case-insensitive searching
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Show signcolumn for files (useful for git signs)
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 500

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--vim.opt.list = true
--vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 20

-- Ask for confirmation in actions that could fail otherwise
vim.opt.confirm = true


-- [[ BASIC KEYMAPS ]]
-- Go back to the [F]ile [E]xplorer
vim.keymap.set('n', "<leader>fe", "<cmd>Ex<CR>")

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set('n', "<leader>dl", vim.diagnostic.setloclist, { desc = "Open [D]iagnostic quickfix [L]ist" })

-- Exit terminal mode in the builtin terminal
vim.keymap.set('t', "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Disable arrow keys in all modes
vim.keymap.set({ 'n', 'i', 'v' }, "<left>", "<cmd>echo 'Use h to move left!!'<CR>")
vim.keymap.set({ 'n', 'i', 'v' }, "<right>", "<cmd>echo 'Use l to move right!!'<CR>")
vim.keymap.set({ 'n', 'i', 'v' }, "<up>", "<cmd>echo 'Use k to move up!!'<CR>")
vim.keymap.set({ 'n', 'i', 'v' }, "<down>", "<cmd>echo 'Use j to move down!!'<CR>")

-- Change foucs between windows using hjkl
vim.keymap.set('n', "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set('n', "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set('n', "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set('n', "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })


-- [[ BASIC AUTOCOMMANDS ]]
-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})


-- [[ INSTALL LAZYVIM PLUGIN MANAGER ]]
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepository = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepository, lazypath }
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)


-- [[ INSTALL AND CONFIGURE PLUGINS ]]
require("lazy").setup({
  -- Detect tabstop and shiftwidth automatically
  "tpope/vim-sleuth",

  -- Adds git related signs to the gutter, as well as utilities for managing changes
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- Autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true
  },

  -- Fuzzy Finder
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable "make" == 1
        end,
      },
      "nvim-telescope/telescope-ui-select.nvim",
      {
        "nvim-tree/nvim-web-devicons",
        enabled = vim.g.have_nerd_font
      },
    },
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      })
      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")

      local builtin = require("telescope.builtin")
      vim.keymap.set('n', "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
      vim.keymap.set('n', "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
      vim.keymap.set('n', "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
      vim.keymap.set('n', "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
      vim.keymap.set('n', "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
      vim.keymap.set('n', "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
      vim.keymap.set('n', "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
      vim.keymap.set('n', "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
      vim.keymap.set('n', "<leader>s.", builtin.oldfiles, { desc = "[S]earch Recent Files ('.' for repeat)" })
      vim.keymap.set('n', "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

      vim.keymap.set('n', "<leader>/", function()
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = "[/] Fuzzily search in current buffer" })
      vim.keymap.set('n', "<leader>s/", function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        }
      end, { desc = "[S]earch [/] in Open Files" })
      vim.keymap.set('n', "<leader>sn", function()
        builtin.find_files { cwd = vim.fn.stdpath "config" }
      end, { desc = "[S]earch [N]eovim files" })
    end,
  },

  -- LSP Plugins
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  -- Main LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      -- Useful status updates for LSP.
      { "j-hui/fidget.nvim", opts = {} },
      -- Allows extra capabilities provided by blink.cmp
      "saghen/blink.cmp",
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Rename the variable under the cursor.
          map("grn", vim.lsp.buf.rename, "[G]oto [R]e[n]ame")

          -- Execute a code action.
          map("gea", vim.lsp.buf.code_action, "[G]oto [E]xecute Code [A]ction", { 'n', 'x' })

          -- Find references for the word under the cursor.
          map("gfr", require("telescope.builtin").lsp_references, "[G]oto [F]ind [R]eferences")

          -- Jump to the implementation of the word under the cursor.
          map("gwi", require("telescope.builtin").lsp_implementations, "[G]oto [W]ord [I]mplementation")

          -- Jump to the definition of the word under the cursor.
          map("gD", require("telescope.builtin").lsp_definitions, "[G]oto [W]ord [D]efinition")

          -- Jump to the declaration of the word under the cursor.
          map("gwd", vim.lsp.buf.declaration, "[G]oto [W]ord [D]eclaration")

          -- Fuzzy find all the symbols in the current document.
          map("gds", require("telescope.builtin").lsp_document_symbols, "[G]oto [D]ocument [S]ymbols")

          -- Fuzzy find all the symbols in the current workspace.
          map("gps", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[G]oto [P]roject [S]ymbols")

          -- Jump to the type of the word under the cursor.
          map("gwt", require("telescope.builtin").lsp_type_definitions, "[G]oto [W]ord [T]ype")

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has "nvim-0.11" == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = "lsp-highlight", buffer = event2.buf }
              end,
            })
          end
        end,
      })

      -- Diagnostic Config
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = "ER",
            [vim.diagnostic.severity.WARN] = "WA",
            [vim.diagnostic.severity.INFO] = "IN",
            [vim.diagnostic.severity.HINT] = "HT",
          },
        } or {},
        virtual_text = {
          source = "if_many",
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      -- Enable the following language servers
      local servers = {
        clangd = {},
        gopls = {},
        pylsp = {},
        rust_analyzer = {},
        jdtls = {},
        intelephense = {},
        ts_ls = {},
        html = {},
        cssls = {},
        vimls = {},
        marksman = {},
        bashls = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              diagnostics = {
                globals = { 'vim' },
              },
            },
          },
        },
      }

      -- Get capabilities from blink.cmp
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      -- Ensure the servers and tools above are installed
      require("mason-lspconfig").setup {
        ensure_installed = vim.tbl_keys(servers),
        handlers = {
          -- Default handler for all servers
          function(server_name)
            local server_config = servers[server_name] or {}
            server_config.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server_config.capabilities or {})
            require("lspconfig")[server_name].setup(server_config)
          end,
        },
      }
    end,
  },

  -- Autocompletion
  {
    "saghen/blink.cmp",
    event = "VimEnter",
    version = "1.*",
    dependencies = {
      -- Snippet Engine
      {
        "L3MON4D3/LuaSnip",
        version = "2.*",
        build = (function()
          if vim.fn.has "win32" == 1 or vim.fn.executable "make" == 0 then
            return
          end
          return "make install_jsregexp"
        end)(),
        dependencies = {},
        opts = {},
      },
      "folke/lazydev.nvim",
    },
    --- @module "blink.cmp"
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        -- 'default' (recommended) for mappings similar to built-in completions
        -- <c-y> to accept ([y]es) the completion.
        -- All presets have the following mappings:
        -- <tab>/<s-tab>: move to right/left of your snippet expansion
        -- <c-space>: Open menu or open docs if already open
        -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
        -- <c-e>: Hide menu
        -- <c-k>: Toggle signature help
        preset = "default",
      },

      appearance = {
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },

      completion = {
        -- By default, you may press `<c-space>` to show the documentation.
        documentation = { auto_show = false, auto_show_delay_ms = 500 },
      },

      sources = {
        default = { "lsp", "path", "snippets", "lazydev" },
        providers = {
          lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
        },
      },

      snippets = { preset = "luasnip" },

      fuzzy = { implementation = "lua" },

      -- Shows a signature help window while you type arguments for a function
      signature = { enabled = true },
    },
  },

  --[[
  -- No Clown Fiesta colorscheme
  {
    "aktersnurra/no-clown-fiesta.nvim",
    priority = 1000,
    config = function ()
      require("no-clown-fiesta").setup {
        styles = {},
      }
      require("no-clown-fiesta").load()
    end,
    lazy = false,
  },
  ]]

  -- {
  --   "zenbones-theme/zenbones.nvim",
  --   dependencies = "rktjmp/lush.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme('zenbones')
  --     -- Eliminar todas las cursivas
  --     vim.cmd([[
  --     highlight Comment gui=NONE cterm=NONE
  --     highlight @comment gui=NONE cterm=NONE
  --     highlight @keyword gui=NONE cterm=NONE
  --     highlight @function gui=NONE cterm=NONE
  --     highlight @variable gui=NONE cterm=NONE
  --     highlight @parameter gui=NONE cterm=NONE
  --     highlight @type gui=NONE cterm=NONE
  --     highlight @string gui=NONE cterm=NONE
  --     highlight Keyword gui=NONE cterm=NONE
  --     highlight Function gui=NONE cterm=NONE
  --     highlight String gui=NONE cterm=NONE
  --     highlight Type gui=NONE cterm=NONE
  --     highlight @constant.macro gui=NONE cterm=NONE
  --     highlight Macro gui=NONE cterm=NONE
  --     highlight @boolean gui=NONE cterm=NONE
  --     highlight Boolean gui=NONE cterm=NONE
  --     highlight @constant.builtin gui=NONE cterm=NONE
  --     ]])
  --   end
  -- },

  --Gruber-darker theme
  {
    "blazkowolf/gruber-darker.nvim",
    config = function()
      require("gruber-darker").setup({
        bold = false,
        italic = {
          comments = true,
          strings = false,
          operators = false,
          folds = false,
        },
        underline = false,
        undercurl = true,
        invert = {
          signs = false,
          tabline = false,
          visual = false,
        },
      })

      vim.cmd.colorscheme("gruber-darker")

      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "gruber-darker",
        callback = function()
          vim.api.nvim_set_hl(0, "Normal", { fg = "#ffffff", bg = "#1e1e1e" })
          vim.api.nvim_set_hl(0, "Character", { fg = "#4caf50" })
          vim.api.nvim_set_hl(0, "@comment", { fg = "#7c8b94", italic = true })
          vim.api.nvim_set_hl(0, "@spell", { fg = "#7c8b94", italic = true })
          vim.api.nvim_set_hl(0, "@keyword", { fg = "#ffeb3b" })
          vim.api.nvim_set_hl(0, "@string", { fg = "#4caf50" })
          vim.api.nvim_set_hl(0, "@number", { fg = "#ff9800" })
          vim.api.nvim_set_hl(0, "@function", { fg = "#ffffff" })
          vim.api.nvim_set_hl(0, "@type.c", { fg = "#ffffff" })
          vim.api.nvim_set_hl(0, "@type.definition.c", { fg = "#ffffff" })
          vim.api.nvim_set_hl(0, "@property.c", { fg = "#ffffff" })
          vim.api.nvim_set_hl(0, "@variable.c", { fg = "#ffffff" })
          vim.api.nvim_set_hl(0, "@constant.c", { fg = "#ffffff" })
          vim.api.nvim_set_hl(0, "@constant.macro.c", { fg = "#ffffff" })
          vim.api.nvim_set_hl(0, "@punctuation.bracket.c", { fg = "#ffffff" })
          vim.api.nvim_set_hl(0, "GruberDarkerYellow", { fg = "#c5c8c6" })
          vim.api.nvim_set_hl(0, "GruberDarkerQuartz", { fg = "#c5c8c6" })
        end,
      })
    end,
  },

  -- Highlight todo, notes, etc in comments
  {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false }
  },

  -- Highlight, edit, and navigate code
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs", -- Sets main module to use for opts
    -- [[ CONFIGURE TREESITTER ]]
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "diff",
        "go",
        "html",
        "java",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "php",
        "python",
        "query",
        "rust",
        "typescript",
        "vim",
        "vimdoc",
        "javascript",
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "ruby" },
      },
      indent = { enable = true, disable = { "ruby" } },
    },
  },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

vim.cmd.colorscheme("gruber-darker")

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
