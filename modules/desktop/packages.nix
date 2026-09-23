{
  flake.aspects.desktop = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        wl-clipboard
        wl-mirror
        wlr-randr
        wdisplays
        wayvnc
        wev
        lswt
        libnotify
        gimp
        krita
        kicad
        freecad
        blender
        lmms
        libreoffice
        telegram-desktop
        vesktop
        rustdesk-flutter
      ];
    };
  };
}
