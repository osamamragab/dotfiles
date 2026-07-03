{ pkgs, ... }:
{
    programs.delta = {
        enable = true;
        package = pkgs.delta;
        enableGitIntegration = true;
        enableJujutsuIntegration = true;
        options = {
            tabs = 4;
            side-by-side = false;
            line-numbers = true;
            syntax-theme = "Nord";
            file-modified-label = "modified:";
        };
    };
}
