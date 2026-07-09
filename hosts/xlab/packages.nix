{ pkgs, ... }:
{
    # TODO: add all system packages.
    environment.systemPackages = with pkgs; [
        cage
        gcc
        gnumake
        pinentry-curses
    ];
}
