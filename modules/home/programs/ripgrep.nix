{ pkgs, ... }:
{
    programs.ripgrep = {
        enable = true;
        package = pkgs.ripgrep;
        arguments = [
            "--vimgrep"
            "--smart-case"
            "--hidden"
            "--follow"
            "--column"
            "--line-number"
            "--no-heading"
            "--max-columns=4096"
            "--glob=!**/.git/*"
        ];
    };
}
