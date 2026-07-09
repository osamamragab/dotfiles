{ pkgs, lib, config, ... }:
{
    programs.zsh = {
        enable = true;
        package = pkgs.zsh;
        dotDir = if config.xdg.enable then "${config.xdg.configHome}/zsh" else config.home.homeDirectory;
        enableCompletion = true;
        enableVteIntegration = true;
        defaultKeymap = "viins";
        autocd = true;
        # zprof.enable = true;
        autosuggestion = {
            enable = true;
            strategy = [ "history" "completion" ];
        };
        history = {
            size = 32768;
            save = 32768;
            path = "$XDG_STATE_HOME/history";
            share = true;
            ignoreAllDups = true;
            ignoreSpace = true;
            extended = false;
        };
        setOptions = [
            "PROMPT_SUBST"
            "INTERACTIVE_COMMENTS"
            "HIST_REDUCE_BLANKS"
            "HIST_VERIFY"
        ];
        historySubstringSearch = {
            enable = true;
            searchUpKey = [ "^[[A" ];
            searchDownKey = [ "^[[B" ];
        };
        fastSyntaxHighlighting = {
            enable = true;
            package = pkgs.zsh-fast-syntax-highlighting;
            theme = "XDG:overlay";
        };
        plugins = [
            {
                src = pkgs.zsh-z;
                name = "z";
                file = "share/zsh-z/zsh-z.plugin.zsh";
            }
        ];
        completionInit = lib.mkIf config.programs.zsh.enableCompletion ''
            fpath+=("$ZDOTDIR/completions")
            _comp_options+=(globdots)
            autoload -Uz compinit
            zstyle ":completion:*" menu select
            zstyle ":completion:*" use-cache on
            zstyle ":completion:*" cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
            zstyle ":completion:*" completer _complete _extensions _correct
            zstyle ':completion:*' matcher-list "" "m:{a-zA-Z}={A-Za-z}" "r:|[._-]=* r:|=*" "l:|=* r:|=*"
            zmodload zsh/complist
            find "$ZDOTDIR/.zcompdump" -mtime +1 >/dev/null 2>&1 && compinit || compinit -C
        '';
        initContent = lib.mkMerge [
            (lib.mkOrder 500 ''
                stty stop undef

                autoload -Uz vcs_info
                zstyle ":vcs_info:*" enable git svn hg
                zstyle ":vcs_info:*" formats "(%b) "
                precmd() {
                    vcs_info
                    [ "$TERM" = "foot" ] && {
                        # jumping between commands
                        printf "\e]133;A\e\\"
                        # pipe-command-output shell integration
                        builtin zle || printf "\e]133;D\e\\"
                    }
                }
                preexec() {
                    # pipe-command-output shell integration
                    [ "$TERM" = "foot" ] && printf "\e]133;C\e\\"
                }
                osc7-pwd() {
                    emulate -L zsh
                    setopt extendedglob
                    local LC_ALL=C
                    printf '\e]7;file://%s%s\e\' "$HOST" ''${PWD//(#m)([^@-Za-z&-;_~])/%''${(l:2::0:)$(([##16]#MATCH))}}
                }
                chpwd-osc7-pwd() {
                    [ $ZSH_SUBSHELL -eq 0 ] && osc7-pwd
                }
                autoload -Uz add-zsh-hook
                add-zsh-hook -Uz chpwd chpwd-osc7-pwd

                PROMPT='%B%F{cyan}%c %F{blue}''${vcs_info_msg_0_}%F{%(?.green.red)}>%f%b '
                RPROMPT='%(?..[%F{red}%?%f] )'
                [ -n "''${SSH_TTY:-}" ] && PROMPT="%F{magenta}[%M] $PROMPT"
            '')
            (lib.mkOrder 1200 ''
                bindkey -v
                KEYTIMEOUT=1
                bindkey -M menuselect "h" vi-backward-char
                bindkey -M menuselect "k" vi-up-line-or-history
                bindkey -M menuselect "l" vi-forward-char
                bindkey -M menuselect "j" vi-down-line-or-history
                bindkey -M menuselect "^[[Z" reverse-menu-complete
                bindkey -v "^?" backward-delete-char
                bindkey "^[[P" delete-char
                bindkey "^[[1;5D" backward-word
                bindkey "^[[1;5C" forward-word

                autoload -Uz edit-command-line
                zle -N edit-command-line
                bindkey "^e" edit-command-line
                bindkey -M vicmd "^e" edit-command-line
                bindkey -M vicmd "^[[P" vi-delete-char
                bindkey -M visual "^[[P" vi-delete
            '')
            (lib.mkOrder 1500 ''
                bindkey -a "k" history-substring-search-up
                bindkey -a "j" history-substring-search-down
            '')
        ];
    };

    xdg.configFile."fsh/overlay.ini" = lib.mkIf config.programs.zsh.fastSyntaxHighlighting.enable {
        source = (pkgs.formats.ini {}).generate "overlay.ini" {
            base = {
                comment = 8;
            };
        };
    };

    home.file."${config.programs.zsh.dotDir}/completions/_notes" = lib.mkIf config.programs.zsh.enableCompletion {
        text = ''
            #compdef notes
            _notes() {
                _files -W "''${NOTESDIR:-$(xdg-user-dir DOCUMENTS)/notes}"
            }
            compdef _notes notes
        '';
    };

    home.sessionVariables._Z_DATA = lib.mkIf
        (lib.lists.any (p: p.src == pkgs.zsh-z) config.programs.zsh.plugins)
        "${config.xdg.cacheHome}/zdata";
}
