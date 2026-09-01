{
  flake.aspects.docs = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
        man-pages
        man-pages-posix
      ];

      documentation = {
        doc.enable = true;
        info.enable = true;
        man = {
          enable = true;
          cache.enable = true;
          man-db.enable = false;
          mandoc.enable = true;
        };
        nixos = {
          enable = true;
          checkRedirects = true;
          includeAllModules = true;
          options = {
            splitBuild = true;
            warningsAreErrors = true;
          };
        };
      };
    };
    homeManager =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      {
        programs.info = {
          enable = true;
          package = pkgs.texinfoInteractive;
        };

        home.shellAliases = lib.mkIf config.programs.info.enable {
          info = "info --vi-keys";
        };

        programs.tealdeer = {
          enable = true;
          package = pkgs.tealdeer;
          enableAutoUpdates = false;
          settings = {
            display = {
              compact = true;
              use_pager = true;
            };
            updates = {
              auto_update = false;
              auto_update_interval_hours = 720;
            };
            style = {
              description = {
                underline = false;
                bold = false;
                italic = true;
              };
              command_name = {
                foreground = "green";
                underline = true;
                bold = true;
                italic = false;
              };
              example_text = {
                foreground = "white";
                underline = false;
                bold = false;
                italic = true;
              };
              example_code = {
                foreground = "blue";
                underline = false;
                bold = true;
                italic = false;
              };
              example_variable = {
                foreground = "cyan";
                underline = true;
                bold = false;
                italic = false;
              };
            };
          };
        };
      };
  };
}
