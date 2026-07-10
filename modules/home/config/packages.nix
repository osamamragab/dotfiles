{ pkgs, ... }:
{
    # TODO: add all user packages.
    home.packages = with pkgs; [
        libnotify
        wl-clipboard
        sound-theme-freedesktop
        wiremix
        helvum
        tree-sitter

        gcc
        gnumake
        clang-tools
        zig
        go
        rustc
        cargo
        nodejs
    ];
}
