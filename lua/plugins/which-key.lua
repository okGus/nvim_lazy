return {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function ()
        local wk = require("which-key")
        wk.setup()

        wk.add({
            { "<leader>c", group = "[C]ode" },
            { "<leader>d", group = "[D]ocument" },
            { "<leader>r", group = "[R]ename" },
            { "<leader>s", group = "[S]earch" },
            { "<leader>w", group = "[W]orkspace" },
            { "<leader>sf", ":.,/}/s/", desc = "Replace in function" },
            { "<leader>sr", ":%s/", desc = "Replace in file" },

            -- These hide the following underscores to prevent unnecessary hints
            { "<leader>c_", hidden = true },
            { "<leader>d_", hidden = true },
            { "<leader>r_", hidden = true },
            { "<leader>s_", hidden = true },
            { "<leader>w_", hidden = true },
        })
    end,
}
