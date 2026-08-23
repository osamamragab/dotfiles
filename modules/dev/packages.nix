{
    flake.aspects.dev = {
        homeManager = { pkgs, config, ... }: {
            home.packages = with pkgs; [
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

            home.sessionVariables = {
                DO_NOT_TRACK = "true";
                GH_TELEMETRY = "false";
                GLAB_SEND_TELEMETRY = "false";
                PYENV_ROOT = "${config.xdg.dataHome}/pyenv";
                CARGO_HOME = "${config.xdg.dataHome}/cargo";
                RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
                PYTHON_HISTORY = "${config.xdg.stateHome}/python_history";
                NODE_REPL_HISTORY = "${config.xdg.stateHome}/node_repl_history";
            };
        };
    };
}
