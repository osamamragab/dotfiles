{
    pkgs,
    ...
}:
{
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
}
