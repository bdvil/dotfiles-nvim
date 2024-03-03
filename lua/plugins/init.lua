return {
	-- "stevearc/dressing.nvim",
	"nvim-treesitter/playground",
	{
		"mbbill/undotree",
		config = function()
			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		opts = {},
	},
	"tpope/vim-repeat",
	"tpope/vim-surround",
	"tpope/vim-unimpaired",
	"folke/flash.nvim",

	"mrjones2014/nvim-ts-rainbow",

	"windwp/nvim-autopairs",
	{
		"numToStr/Comment.nvim",
		lazy = false,
		config = function()
			require("Comment").setup()
		end,
	},

	{
		"christoomey/vim-tmux-navigator",
		lazy = false,
	},

	"lukas-reineke/indent-blankline.nvim",

	"norcalli/nvim-colorizer.lua",

	{
		"akinsho/flutter-tools.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"stevearc/dressing.nvim",
		},
	},

	"dart-lang/dart-vim-plugin",

	{
		"AckslD/nvim-FeMaco.lua",
		config = function()
			require("femaco").setup({
				float_opts = function(_)
					return {
						relative = "editor",
						width = vim.api.nvim_win_get_width(0),
						height = vim.api.nvim_win_get_height(0),
						anchor = "NW",
						zindex = 1,
						row = 0,
						col = 0,
					}
				end,
				ensure_newline = function(_)
					return true
				end,
			})

			local femaco_edit = require("femaco.edit")
			vim.keymap.set("n", "<leader>e", femaco_edit.edit_code_block)
		end,
	},

	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
}
