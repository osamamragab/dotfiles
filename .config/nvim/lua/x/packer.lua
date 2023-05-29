return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")
	use({
		"VonHeikemen/lsp-zero.nvim",
		requires = {
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim", run = ":MasonUpdate" },
		  { "williamboman/mason-lspconfig.nvim" },
			{ "hrsh7th/nvim-cmp" },
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

	use("ThePrimeagen/harpoon")
	use("tpope/vim-fugitive")
	use("lewis6991/gitsigns.nvim")
	use("gpanders/editorconfig.nvim")
	use("windwp/nvim-autopairs")
	use("numToStr/Comment.nvim")
	use("akinsho/flutter-tools.nvim")
	use("folke/zen-mode.nvim")
	use("nvim-lualine/lualine.nvim")

	use({ "nordtheme/vim", as = "nord" })
	-- use("sainnhe/sonokai")
	-- use("joshdick/onedark.vim")
	-- use("luisiacc/gruvbox-baby")
	-- use("tiagovla/tokyodark.nvim")
	-- use({ "rose-pine/neovim", as = "rose-pine" })

	-- use("shaunsingh/nord.nvim")
	-- use("gruvbox-community/gruvbox")
	-- use("ziglang/zig.vim")
	-- use("rust-lang/rust.vim")
	-- use("darrikonn/vim-gofmt", { run = ":GoUpdateBinaries" })
	-- use("psf/black", { tag = "stable" })
	-- use("elixir-editors/vim-elixir")
end)
