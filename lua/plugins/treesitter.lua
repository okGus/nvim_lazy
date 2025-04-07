return {
	'nvim-treesitter/nvim-treesitter',
	build = ':TSUpdate',
	dependencies = {
		'nvim-treesitter/playground',
	},
	config = function()
		require('nvim-treesitter.configs').setup({
			ensure_installed = { "javascript", "typescript", "cpp", "c", "lua", "vim", "vimdoc", "query", "rust", "python" },
			sync_install = false,
			auto_install = false,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			playground = {
				enable = true,
			},
		})
	end,
}
