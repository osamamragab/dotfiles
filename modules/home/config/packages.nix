{
    pkgs,
    ...
}:
{
    # TODO: add all user packages.
    home.packages = with pkgs; [
        libnotify
        wl-clipboard
        wiremix
        helvum
        tree-sitter
        buku

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
