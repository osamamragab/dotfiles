{
    pkgs,
    lib,
    config,
    ...
}:
{
    programs.git = {
        enable = true;
        package = pkgs.git;
        signing = {
            format = null;
            signByDefault = true;
            signer = "~/.config/git/ssh-signkey";
        };
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
                editor = "nvim";
                pager = "delta";
            };
            user = {
                name = "Osama Ragab";
                email = "theosamaragab@gmail.com";
                signingKey = "~/.ssh/id_ed25519";
            };
            gpg = {
                format = "ssh";
            };
            commit = {
                gpgSign = true;
            };
            push = {
                default = "simple";
                autoSetupRemote = true;
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
        };
    };

    home.shellAliases = lib.mkIf config.programs.git.enable {
        g = "git";
        gst = "git status -sb";
        gph = "git push";
        gpl = "git pull";
        gdf = "git diff";
    };

    xdg.configFile."git/ssh-signkey" = lib.mkIf config.programs.git.enable {
        text = ''
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
        '';
    };
}
