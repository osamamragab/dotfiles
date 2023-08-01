return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")
	use("neovim/nvim-lspconfig")
	use({
		"williamboman/mason.nvim",
		run = ":MasonUpdate",
		requires = {{ "williamboman/mason-lspconfig.nvim" }},
	})
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "L3MON4D3/LuaSnip" },
			{ "rafamadriz/friendly-snippets" },
		},
	})
	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-fzy-native.nvim" },
		},
	})
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use("nvim-treesitter/nvim-treesitter-context")
	-- use("nvim-treesitter/playground")
	use("gpanders/editorconfig.nvim")
	use("tpope/vim-fugitive")
	use("ThePrimeagen/harpoon")
	use("folke/trouble.nvim")
	use("folke/zen-mode.nvim")
	use({ "nordtheme/vim", as = "nord" })
end)
