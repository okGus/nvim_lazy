-- Starcoder2:7b seems better than others
-- Time to test codellama:7b

return {
    'huggingface/llm.nvim',
    dependencies = {},
    config = function()
        -- Define configurations for different models
        local models = {}

        -- configuration for qwen2.5-coder:7b
        models["qwen2.5-coder:7b"] = {
            model = "qwen2.5-coder:7b",
            tokens_to_clear = { "<|endoftext|>" },
            fim = {
                enabled = true,
                prefix = "<|fim_prefix|>",
                middle = "<|fim_middle|>",
                suffix = "<|fim_suffix|>",
            },
            lsp = {
                bin_path = vim.api.nvim_call_function("stdpath", { "data" }) .. "/mason/bin/llm-ls",
                version = "0.5.2",
                enabled = true,
            },
            tokenizer = {
                path = "~/Downloads/tokenizers/qwen2_5_coder-tokenizer.json"
            },
            context_window = 32768,
        }

        -- configuration for codellama:7b
        models["codellama:7b"] = {
            model = "codellama:7b",
            tokens_to_clear = { "<EOF>" },
            fim = {
                enabled = true,
                prefix = "<PRE>",
                middle = "<MID>",
                suffix = "<SUF>",
            },
            lsp = {
                bin_path = vim.api.nvim_call_function("stdpath", { "data" }) .. "/mason/bin/llm-ls",
                version = "0.5.2",
                enabled = true,
            },
            tokenizer = nil,
            context_window = 16384,
        }

        -- configuration for starcoder2:7b
        models["starcoder2:3b"] = {
            model = "starcoder2:3b",
            tokens_to_clear = { "<|end_of_text|>" },
            fim = {
                enabled = true,
                prefix = "<fim_prefix>",
                middle = "<fim_middle>",
                suffix = "<fim_suffix>",
            },
            lsp = {
                bin_path = vim.api.nvim_call_function("stdpath", { "data" }) .. "/mason/bin/llm-ls",
                version = "0.5.2",
                enabled = true,
            },
            tokenizer = nil,
            context_window = 16384,
        }

        -- Function to switch the llm.nvim configurations to a selected model
        local function SwitchLLMModel(model_name)
            local llm = require("llm")
            local config = models[model_name]

            if not config then
                print("Model configuration not found: " .. model_name)
            end

            -- Update llm.nvim configuration
            llm.setup({
                debug = true,
                model = config.model,
                backend = "ollama",
                url = "http://127.0.0.1:11434",
                enable_suggestions_on_startup = true,
                enable_suggestions_on_files = "*",
                tokens_to_clear = config.tokens_to_clear,
                request_body = {
                    model = config.model,
                    max_new_tokens = 100,
                    temperature = 0.2,
                    top_p = 0.95,
                },
                fim = config.fim,
                debounce_ms = 120,
                accept_keymap = "<c-j>",
                dismiss_keymap = "<S-Tab>",
                lsp = {
                    bin_path = vim.api.nvim_call_function("stdpath", { "data" }) .. "/mason/bin/llm-ls",
                    version = "0.5.2",
                    enabled = true,
                },
                tokenizer = config.tokenizer,
                context_window = config.context_window,
            })

            print("Switched to model: " .. model_name)
        end

        -- Create Neovim command to switch models
        vim.api.nvim_create_user_command("LLMSwitchModel", function(opts)
            SwitchLLMModel(opts.args)
        end, {
            nargs = 1,
            complete = function()
                return vim.tbl_keys(models)
            end
        })

        SwitchLLMModel("starcoder2:3b")
    end,
}

-- Keybinding to switch models
--vim.keymap.set('n', '<leader>lm', function ()
--    vim.ui.select(vim.tbl_keys(models), {
--        prompt = "Select LLM Model:",
--    }, function (choice)
--        if choice then
--            SwitchLLMModel(choice)
--        end
--    end)
--end, { desc = 'Switch LLM Model' })

-- Load default model on startup
--SwitchLLMModel("codellama:7b")
