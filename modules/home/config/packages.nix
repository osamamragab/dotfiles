{
    pkgs,
    config,
    ...
}:
{
    home.packages = with pkgs; [
        # wayland & desktop
        wl-clipboard
        wl-mirror
        wlr-randr
        wayvnc
        lswt
        libnotify

        # audio
        wiremix
        helvum

        # cli tools
        bc
        jq
        buku
        tree-sitter
        fribidi
        dragon-drop
        ffmpeg
        imagemagick
        exiftool
        firejail
        bubblewrap
        croc
        qrencode
        zbar
        minisign
        signify
        hashcat
        duf
        entr

        # networking
        mitmproxy
        bettercap
        wireshark
        termshark
        aircrack-ng
        proxychains-ng
        netcat-openbsd
        macchanger
        mosh
        wrk
        tor
        torsocks
        transmission_4

        # apps
        gimp
        krita
        kicad
        #freecad
        #blender
        lmms
        libreoffice
        telegram-desktop
        localsend
        #rustdesk

        # dev
        gcc
        gnumake
        ninja
        clang-tools
        valgrind
        zig
        lua
        just
        nodejs
        nasm
        patch
        patchelf
        pkgconf
        socat
        strace
        grex
        sqlmap
        tokei
        xxd
        radare2
        iaito
        janet
        ruff
        rustup
        cmake
        meson
        hyperfine
        hurl
        dive
        delve
        typst
        uv
        upx
        usql
        shellcheck
        pnpm
    ];

    programs.pandoc = {
        enable = true;
        package = pkgs.pandoc;
    };

    home.sessionVariables = {
        DO_NOT_TRACK = "true";
        GH_TELEMETRY = "false";
        GLAB_SEND_TELEMETRY = "false";
        PYENV_ROOT="${config.xdg.dataHome}/pyenv";
        CARGO_HOME="${config.xdg.dataHome}/cargo";
        RUSTUP_HOME="${config.xdg.dataHome}/rustup";
        PYTHON_HISTORY = "${config.xdg.stateHome}/python_history";
        NODE_REPL_HISTORY="${config.xdg.stateHome}/node_repl_history";
    };
}
