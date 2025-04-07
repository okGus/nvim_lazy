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

	    local lspconfig_defaults = lspconfig.util.default_config
	    lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  		    'force',
  		    lspconfig_defaults.capabilities,
  		    require('cmp_nvim_lsp').default_capabilities()
	    )

        --vim.lsp.set_log_level("debug")
        -- Mason setup
        mason.setup({})
        mason_lspconfig.setup({
            ensure_installed = { 'ts_ls', 'eslint', 'lua_ls', 'rust_analyzer', 'pylsp', 'cssls', 'tailwindcss', 'clangd' },
            handlers = {
                function(server_name)
                    lspconfig[server_name].setup({})
                end,
                ["lua_ls"] = function()
                    lspconfig.lua_ls.setup({
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { 'vim' }
                                }
                            }
                        }
                    })
                end,
                -- Custom handler for pylsp
                ["pylsp"] = function()
                    lspconfig.pylsp.setup({
                        settings = {
                            pylsp = {
                                plugins = {
                                    pycodestyle = {
                                        ignore = {'W391', 'E302', 'E305', 'E265', 'W293' },
                                        maxLineLength = 100,
                                    },
                                },
                            },
                        },
                    })
                end,
            },
        })

        -- Set diagnostic signs
        --vim.fn.sign_define('DiagnosticSignError', { text = 'E', texthl = 'DiagnosticSignError' })
        --vim.fn.sign_define('DiagnosticSignWarn', { text = 'W', texthl = 'DiagnosticSignWarn' })
        --vim.fn.sign_define('DiagnosticSignInfo', { text = 'I', texthl = 'DiagnosticSignInfo' })
        --vim.fn.sign_define('DiagnosticSignHint', { text = 'H', texthl = 'DiagnosticSignHint' })

	    -- Completion setup
        --luasnip.config.setup({})

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
            }),
            sources = {
                { name = 'nvim_lsp' },
                { name = 'buffer' },
                { name = 'path' },
                { name = 'luasnip' },
            },
        })

        -- Diagnostic configuration
        vim.diagnostic.config({
            update_in_insert = true,
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

        -- LSP keymaps (on_attach)
        --local on_attach = function(client, bufnr)
        --    local opts = { buffer = bufnr, remap = false }
        --end
       -- Attach the on_attach function to all LSPs
        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(event)
                local opts = {buffer = event.buf}
                -- Keymaps for LSP functions
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
                vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
                vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
                vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
                vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
                vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
                vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
                vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
                --local client = vim.lsp.get_client_by_id(event.data.client_id)
                --on_attach(client, event.buf)
            end,
        })

    end,
}

-- TODO: fix this 
--lsp.configure('clangd', {
--    filetypes={ "c", "cpp", "objc", "objcpp", "cuda", "proto" },
--    root_dir=lspconfig.util.root_pattern(
--          '.clangd',
--          '.clang-tidy',
--          '.clang-format',
--          'compile_commands.json',
--          'compile_flags.txt',
--          'configure.ac',
--          '.git'
--          ),
--    single_file_support=true
--})


-- Add debug commands 

--vim.api.nvim_create_user_command("LLMDebug", function ()
--    -- Check LSP status
--   local clients = vim.lsp.get_active_clients()
--    print("Active LSP clients:")
--    for _, client in ipairs(clients) do
--        print(string.format("- %s (id: %d)", client.name, client.id))
--    end
--
--    -- Check Ollama connection
    --local curl = require("plenary.curl")
    --local response = curl.post("http://127.0.0.1:11434/api/generate", {
    --    body = vim.fn.json_encode({
    --        model = "qwen2.5-coder:7b",
    --        prompt = "test"
    --    }),
    --    headers = {
    --        content_type = "application/json",
    --    },
    --})
    --print("\nOllama test response:", vim.inspect(response))

    -- Check llm-ls executable 
 --   local llm_ls_path = vim.fn.stdpath("data") .. "/mason/bin/llm-ls"
 --   print("\nllm-ls path:", llm_ls_path)
 --   print("llm-ls executable:", vim.fn.executable(llm_ls_path) == 1)

    -- Print LSP logs location
 --   print("\nLSP logs location:", vim.lsp.get_log_path())
--end, {})

--vim.api.nvim_create_user_command("LLMStatus", function ()
--    local clients = vim.lsp.get_active_clients()
--    for _, client in ipairs(clients) do
--        -- changed to llm-ls from llm_ls
--        if client.name == "llm-ls" then
--            print("LLM LSP is active")
--            print("Server capabilities:", vim.inspect(client.server_capabilities))
--            return
--        end
--    end
--    print("LLM LSP is not active")
---end, {})

--vim.api.nvim_create_user_command("ReloadLLM", function()
    -- Stop the LSP client
--    local clients = vim.lsp.get_active_clients()
--    for _, client in ipairs(clients) do
        -- changed to llm-ls from llm_ls
--        if client.name == "llm-ls" then
---            vim.lsp.stop_client(client.id, true) -- Force stop
--        end
--    end

    -- Clear existing LSP state
--    vim.schedule(function()
        -- Restart the LSP
        -- changed to llm-ls from llm_ls
--        vim.cmd("LspStart llm-ls")

        -- Wait a bit before enabling suggestions
--        vim.defer_fn(function ()
--            vim.cmd("LLMToggleAutoSuggest")
--            vim.cmd("LLMToggleAutoSuggest") -- Ensure its on
--            print("LLM reloaded and suggestions enabled")
--        end, 1000) -- Wait 1 second
--    end)
--end, {})


