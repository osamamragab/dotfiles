return require("packer").startup(function()
	use("wbthomason/packer.nvim")
	use("neovim/nvim-lspconfig")
	use("glepnir/lspsaga.nvim")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/nvim-cmp")
	use("nvim-lua/lsp_extensions.nvim")
	use("L3MON4D3/LuaSnip")
	use("saadparwaiz1/cmp_luasnip")
	use("rafamadriz/friendly-snippets")
	use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
	-- use("nvim-treesitter/playground")
	use("tpope/vim-surround")
	use("tpope/vim-dispatch")
	use("tpope/vim-commentary")
	-- use("tpope/vim-fugitive")
	-- use("ThePrimeagen/git-worktree.nvim")
	use("nvim-lua/plenary.nvim")
	use("nvim-lua/popup.nvim")
	use("nvim-telescope/telescope.nvim")
	use("nvim-telescope/telescope-fzy-native.nvim")
	use("junegunn/goyo.vim")
	use("windwp/nvim-autopairs")
	use("mhinz/vim-signify")
	use("simrat39/symbols-outline.nvim")
	use("editorconfig/editorconfig-vim")
	use("rust-lang/rust.vim")
	use("darrikonn/vim-gofmt", { run = ":GoUpdateBinaries" })
	use("psf/black", { tag = "stable" })
	use("sbdchd/neoformat")
	use("elixir-editors/vim-elixir")
	use("arcticicestudio/nord-vim")
	-- use("nvim-lualine/lualine.nvim")
	-- use("itchyny/lightline.vim")
	-- use("sainnhe/sonokai")
	-- use("joshdick/onedark.vim")
	-- use("gruvbox-community/gruvbox")
	-- use("luisiacc/gruvbox-baby")
end)
