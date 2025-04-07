return {
    "rose-pine/neovim",
    name = "rose-pine",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        -- Setup for rose-pine
        require('rose-pine').setup({
            variant = 'moon',
            disable_background = true,
        })

        -- Function to customize colors and apply the colorscheme
        local function ColorMyPencils(color)
            color = color or "rose-pine"
            vim.cmd.colorscheme(color)

            -- Customize highlight groups
            vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        end

        -- Apply the custom function
        ColorMyPencils()

        -- Setup for nvim-web-devicons
        require('nvim-web-devicons').setup {
            override = {
                zsh = {
                    icon = "",
                    color = "#428850",
                    cterm_color = "65",
                    name = "Zsh"
                }
            };
            -- globally enable different highlight colors per icon (default to true)
            -- if set to false all icons will have the default icon's color
            color_icons = true;
            -- globally enable default icons (default to false)
            -- will get overriden by `get_icons` option
            default = true;
            -- globally enable "strict" selection of icons - icon will be looked up in
            -- different tables, first by filename, and if not found by extension; this
            -- prevents cases when file doesn't have any extension but still gets some icon
            -- because its name happened to match some extension (default to false)
            strict = true;
            -- same as `override` but specifically for overrides by filename
            -- takes effect when `strict` is true
            override_by_filename = {
                [".gitignore"] = {
                    icon = "",
                    color = "#f1502f",
                    name = "Gitignore"
                }
            };
            -- same as `override` but specifically for overrides by extension
            -- takes effect when `strict` is true
            override_by_extension = {
                ["log"] = {
                    icon = "",
                    color = "#81e043",
                    name = "Log"
                }
            };
        }
    end,
    lazy = false, -- Load it immediately on startup
    priority = 1000, -- Ensure it loads before other plugins
}
