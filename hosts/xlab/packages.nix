{
    pkgs,
    ...
}:
{
    # TODO: add all system packages.
    environment.systemPackages = with pkgs; [
        gcc
        gnumake
        pinentry-curses
    ];
}
