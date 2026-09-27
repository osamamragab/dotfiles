{
  flake.aspects.dev = {
    homeManager =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      let
        cfg = config.programs.neovim;
      in
      {
        programs.neovim = {
          enable = true;
          package = pkgs.neovim-unwrapped;
          defaultEditor = true;
          waylandSupport = pkgs.stdenv.hostPlatform.isLinux;
          vimAlias = true;
          vimdiffAlias = true;
          withRuby = false;
          withPerl = false;
          withNodeJs = false;
          withPython3 = false;
        };

        home.file.".config/nvim" = lib.mkIf cfg.enable {
          source = ./neovim;
          recursive = true;
        };

        home.shellAliases = lib.mkIf cfg.enable {
          vi = "nvim --noplugin";
        };
        xdg.mimeApps.defaultApplications = lib.mkIf cfg.enable (
          lib.genAttrs [
            "text/plain"
            "text/x-c"
            "text/x-shellscript"
          ] (_: [ "nvim.desktop" ])
        );
      };
  };
}
