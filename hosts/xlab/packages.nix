{
    pkgs,
    ...
}:
{
    environment.systemPackages = with pkgs; [
        gcc
        gnumake
        pinentry-curses
    ];
}
