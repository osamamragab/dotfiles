setopt autocd
setopt interactive_comments
setopt prompt_subst
setopt histignorespace
setopt hist_reduce_blanks
setopt hist_verify
setopt hist_ignore_all_dups
stty stop undef

autoload -Uz vcs_info
zstyle ":vcs_info:*" enable git svn
zstyle ":vcs_info:*" formats "(%b) "
precmd() {
	vcs_info
	echo -ne "\e[1 q"
}
PROMPT='%B%F{cyan}%c %F{blue}${vcs_info_msg_0_}%F{%(?.green.red)}>%f%b '
[ -n "$SSH_TTY" ] && PROMPT="%F{magenta}[%M] $PROMPT"

HISTSIZE=999999999
SAVEHIST=$HISTSIZE
HISTFILE="${HISTFILE:-${XDG_STATE_HOME:-$HOME/.local/state}/history}"

export GPG_TTY="$(tty)"

[ -r "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && . "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"
alias doas="doas "

fpath=("${XDG_CONFIG_HOME:-$HOME/.config}/zsh/completions" $fpath)
_comp_options+=(globdots)
autoload -Uz compinit
zstyle ":completion:*" menu select
zmodload zsh/complist
[ "$(find "$ZDOTDIR/.zcompdump" -mtime +1)" ] && compinit
compinit -C

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

function osc7-pwd() {
    emulate -L zsh
    setopt extendedglob
    local LC_ALL=C
    printf '\e]7;file://%s%s\e\' $HOST ${PWD//(#m)([^@-Za-z&-;_~])/%${(l:2::0:)$(([##16]#MATCH))}}
}
function chpwd-osc7-pwd() {
    (( ZSH_SUBSHELL )) || osc7-pwd
}
autoload -Uz add-zsh-hook
add-zsh-hook -Uz chpwd chpwd-osc7-pwd

bindkey -s "^o" '^uxdg-open "$(fzf)" >/dev/null\n'
bindkey -s "^f" '^ue "$(fzf)"\n'
bindkey -s "^g" '^ucd "$(dirname "$(fzf)")"\n'
bindkey -s "^t" '^u[ -f TODO.md ] && $EDITOR TODO.md || notes todo\n'

ZSHPLUGINSDIR="${ZSHPLUGINSDIR:-/usr/share/zsh/plugins}"
if [ -r "$ZSHPLUGINSDIR/zsh-history-substring-search/zsh-history-substring-search.zsh" ]; then
	. "$ZSHPLUGINSDIR/zsh-history-substring-search/zsh-history-substring-search.zsh"
	bindkey -a "k" history-substring-search-up
	bindkey -a "j" history-substring-search-down
	bindkey "^[[A" history-substring-search-up
	bindkey "^[[B" history-substring-search-down
fi
if [ -r "$ZSHPLUGINSDIR/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh" ]; then
	ZSH_AUTOSUGGEST_STRATEGY=(history completion)
	. "$ZSHPLUGINSDIR/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
fi
[ -r "$ZSHPLUGINSDIR/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" ] &&
	. "$ZSHPLUGINSDIR/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"
[ -r /usr/share/z/z.sh ] && . /usr/share/z/z.sh
# [ -r "$SDKMAN_DIR/bin/sdkman-init.sh" ] && . "$SDKMAN_DIR/bin/sdkman-init.sh" || true
