return {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v4.x',
    dependencies = {
        -- LSP Support
        'neovim/nvim-lspconfig',             -- Required
        'williamboman/mason.nvim',           -- Optional
        'williamboman/mason-lspconfig.nvim', -- Optional

        -- Autocompletion
        'hrsh7th/nvim-cmp',         -- Required
        'hrsh7th/cmp-nvim-lsp',     -- Required
        'hrsh7th/cmp-buffer',       -- Optional
        'hrsh7th/cmp-path',         -- Optional
        'saadparwaiz1/cmp_luasnip', -- Optional
        'hrsh7th/cmp-nvim-lua',     -- Optional

        -- Snippets
        'L3MON4D3/LuaSnip',             -- Required
        'rafamadriz/friendly-snippets', -- Optional
    },
    config = function()
	   -- Import necessary modules
        local lspconfig = require('lspconfig')
        local mason = require('mason')
        local mason_lspconfig = require('mason-lspconfig')
        local cmp = require('cmp')
        local luasnip = require('luasnip')

        -- Load friendly-snippets
        require('luasnip.loaders.from_vscode').lazy_load()

        -- Add emmet-style snippets to HTML and related filetypes
        luasnip.filetype_extend('html', {'html-es6-snippets'})
        luasnip.filetype_extend('typescriptreact', {'html-es6-snippets'})
        luasnip.filetype_extend('javascriptreact', {'html-es6-snippets'})

        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        capabilities.positionEncodings = { 'utf-8', 'utf-16' }
        capabilities.textDocument.completion.completionItem.snippetSupport = true

        local global_on_attach = function(client, bufnr)
            local opts = { buffer = bufnr, noremap = true, silent = true }

            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
            vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
            vim.keymap.set("n", "[d", function() vim.diagnostic.jump({count = 1, float = true}) end, opts) -- changed to jump() instead of goto_next()
            vim.keymap.set("n", "]d", function() vim.diagnostic.jump({count = -1, float = true}) end, opts) -- changed to jump() instead of goto_prev()
            vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
            vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
            vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
            vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)

        end

	   local lspconfig_defaults = lspconfig.util.default_config
        lspconfig_defaults.on_attach = global_on_attach
	   lspconfig_defaults.capabilities = capabilities

        --vim.lsp.set_log_level("debug")
        -- Mason setup
        mason.setup({})
        mason_lspconfig.setup({
            ensure_installed = {
                'gopls', 'ts_ls', 'eslint', 'lua_ls', 'rust_analyzer',
                'pyright', 'cssls', 'tailwindcss', 'html', 'emmet_ls', 'jsonls'
            },
            handlers = {
                function(server_name)
                    lspconfig[server_name].setup({})
                end,
                ["gopls"] = function()
                    lspconfig.gopls.setup({
                        cmd = { "gopls" },
                        filetypes = { "go", "gomod", "gowork", "gotmpl" },
                        settings = {
                            gopls = {
                                completeUnimported = true,
                                usePlaceholders = true,
                                analyses = {
                                    unusedparams = true,
                                },
                            },
                        },
                    })
                end,
                ["jsonls"] = function()
                    lspconfig.jsonls.setup({
                        cmd = { 'vscode-json-language-server', '--stdio' },
                        init_options = { provideFormatter = true },
                        filetypes = { 'json' },
                    })
                end,
                ["rust_analyzer"] = function()
                    lspconfig.rust_analyzer.setup({
                        settings = {
                            ['rust-analyzer'] = {
                                diagnostics = { enable = true; }
                            }
                        },
                        filetypes = { 'rust' },
                    })
                end,
                ["ts_ls"] = function()
                    lspconfig.ts_ls.setup({
                        cmd = { 'typescript-language-server', '--stdio' },
                        init_options = { hostInfo = 'neovim', },
                        filetypes = {
                            'javascript', 'javascriptreact', 'javascript.jsx',
                            'typescript', 'typescriptreact', 'typescript.tsx'
                        },
                    })
                end,
                ["lua_ls"] = function()
                    lspconfig.lua_ls.setup({
                        settings = {
                            Lua = {
                                runtime = { version = 'LuaJIT' },
                                diagnostics = {
                                    globals = { 'vim' }
                                }
                            }
                        }
                    })
                end,
                ["emmet_ls"] = function()
                    lspconfig.emmet_ls.setup({
                        init_options = {
                            html = {
                                options = {
                                    ["bem.enabled"] = true,
                                },
                            },
                        },
                    })
                end,
                ["html"] = function()
                    lspconfig.html.setup({
                        cmd = { 'vscode-html-language-server', '--stdio' },
                        filetypes = { 'html', 'templ' },
                        init_options = {
                            provideFormatter = true,
                            embeddedLanguages = { css = true, javascript = true },
                            configurationSection = { 'html', 'css', 'javascript' }
                        },
                    })
                end,
                -- Custom handler for pylsp
                ["pylsp"] = function()
                    vim.api.nvim_create_autocmd('FileType', {
                        pattern = 'python',
                        callback = function()
                            local venv = os.getenv('VIRTUAL_ENV')
                            local python_path = venv and venv .. '/bin/python3' or vim.fn.exepath('python3')
                            print("Using Python:", python_path)
                            lspconfig.pylsp.setup({
                                cmd = { python_path, '-m', 'pylsp' },
                                settings = {
                                    pylsp = {
                                        plugins = {
                                            --configurationSources = {'flake8', 'pylint', 'venv'},
                                            pycodestyle = { enabled = false },
                                            autopep8 = {
                                                enabled = true
                                            },
                                            flake8 = {
                                                enabled = true,
                                                ignore = {'E302', 'E305'},
                                                maxLineLength = 100,
                                            },
                                            pylint = {
                                                enabled = true,
                                                args = {
                                                    '--disable=C0116',
                                                    '--disable=C0103',
                                                    '--disable=C0114',
                                                    '--disable=W0621',
                                                    '--disable=W0718',
                                                    '--disable=W3101',
                                                }
                                            },
                                            pylsp_mypy = {
                                                enabled = true,
                                                overrides = { '--python-executable', python_path },
                                            },
                                        },
                                    },
                                },
                            })
                        end,
                        once = true,
                    })
                end,
            },
        })

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body) -- Enable snippet expansion
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(),    -- Previous suggestion
                ['<C-n>'] = cmp.mapping.select_next_item(),    -- Next suggestion
                ['<C-y>'] = cmp.mapping.confirm({ select = true }), -- Confirm selection
                ['<C-Space>'] = cmp.mapping.complete(),        -- Trigger completion menu
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            sources = {
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'buffer' },
                { name = 'path' },
                { name = 'nvim_lua' }
            },
        })

        -- Diagnostic configuration
        vim.diagnostic.config({
            update_in_insert = false,
            --virtual_text = false,
            float = {
                focusable = false,
                style = 'minimal',
                border = 'rounded',
                source = 'always',
                header = '',
                prefix = '',
                width = 80,
                warp = true,
            },
        })

    end,
}