{ pkgs,  ... }:
{
    programs.man = {
        enable = true;
        man-db.enable = true;
    };
}
