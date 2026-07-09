{ pkgs, ... }:
{
    programs.mbsync = {
        enable = true;
        package = pkgs.isync;
    };
}
