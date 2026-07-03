{ pkgs, ... }:
{
    programs.parallel = {
        enable = true;
        package = pkgs.parallel;
        will-cite = true;
    };
}
