{
    pkgs,
    lib,
    config,
    ...
}:
let
    primaryAccount = lib.lists.findFirst (acc: acc.primary == true) null (
        builtins.attrValues config.accounts.email.accounts
    );
in
{
    programs.git = {
        enable = true;
        package = pkgs.git;
        ignores = [
            "/node_modules/"
            "/__pycache__/"
            "/zig-out/"
            "/.zig-cache/"
            "/target/"
            "/wheels/"
            "/.venv/"
            "*.py[oc]"
            "*.egg-info"
        ];
        settings = {
            init = {
                defaultBranch = "main";
            };
            core = {
                editor = "${config.programs.neovim.package or pkgs.neovim-unwrapped}/bin/nvim";
                pager = "${config.programs.delta.package or pkgs.delta}/bin/delta";
            };
            user = {
                name = primaryAccount.realName;
                email = primaryAccount.address;
                signingKey = primaryAccount.gpg.key;
            };
            gpg = {
                format = "openpgp";
                openpgp.program = "${config.programs.gpg.package or pkgs.gnupg}/bin/gpg";
                x509.program = "${config.programs.gpg.package or pkgs.gnupg}/bin/gpgsm";
                ssh.program = builtins.toString (
                    pkgs.writeShellScript "ssh-signkey" ''
                        #!/bin/sh
                        # A workaround to stop git from being annoying when using ssh signing keys.
                        # By default, git uses ssh-keygen to sign commits. ssh-keygen does not honor
                        # AddKeysToAgent in ssh config. So here you go.

                        set -eu

                        while getopts "Y:n:f:" opt; do
                            case "$opt" in
                                f)
                                    key="''${OPTARG%.pub}"
                                    ssh-add -T "$key.pub" 2>&- || ssh-add "$key"
                                ;;
                                *) ;;
                            esac
                        done

                        exec ssh-keygen "$@"
                    ''
                );
            };
            commit = {
                gpgSign = true;
            };
            push = {
                default = "simple";
                autoSetupRemote = true;
                gpgSign = "if-asked";
            };
            tag = {
                gpgSign = true;
            };
            pull = {
                rebase = true;
            };
            rebase = {
                autoStash = true;
            };
            rerere = {
                enabled = true;
            };
            receive = {
                advertisePushOptions = true;
            };
            alias = {
                co = "checkout";
                cm = "commit -m";
                st = "status -sb";
                br = "branch";
                cl = "clone";
                dt = "difftool";
                wt = "worktree";
                ls = "ls-files";
                tree = "ls-tree --full-tree -r HEAD";
                logg = "log --oneline --graph --decorate";
                undo = "reset --soft HEAD^";
                root = "rev-parse --show-toplevel";
            };
        };
        lfs = {
            enable = true;
            package = pkgs.git-lfs;
            skipSmudge = false;
        };
    };

    home.shellAliases = lib.mkIf config.programs.git.enable {
        g = "git";
        gst = "git status -sb";
        gph = "git push";
        gpl = "git pull";
        gdf = "git diff";
    };

    home.file."${config.xdg.binHome}/gac" = lib.mkIf config.programs.git.enable {
        source =
            let
                gitBin = "${config.programs.git.package or pkgs.git}/bin/git";
            in
            pkgs.writeShellScript "gac" ''
                set -eu

                if [ $# -lt 2 ]; then
                    printf "usage:\n  %s files... message\n" "$(basename "$0")"
                    exit 1
                fi

                for msg; do :; done

                for f; do
                    [ "$f" = "$msg" ] && break
                    [ -n "''${files:-}" ] && files="$files $f" || files="$f"
                done

                # shellcheck disable=SC2086
                ${gitBin} add $files &&
                    ${gitBin} commit -m "$msg"
            '';
    };
}
