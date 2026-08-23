{
    flake.aspects.desktop = {
        nixos = { pkgs, ... }: {
            programs.appimage = {
                enable = true;
                binfmt = true;
                package = pkgs.appimage-run;
            };
        };
    };
}
