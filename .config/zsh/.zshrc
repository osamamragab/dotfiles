setopt autocd
setopt interactive_comments
setopt prompt_subst
stty stop undef

__git_branch() {
	br="$(git symbolic-ref HEAD --short 2>/dev/null)"
	[ "$br" ] && echo "($br) "
}

autoload -U colors && colors
PS1="%B%{$fg[cyan]%}%c %{$fg[blue]%}\$(__git_branch)%{$fg[green]%}>%{$reset_color%}%b "

HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"

MAILCHECK=0

fpath=($fpath "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/completions")
autoload -U compinit
zstyle ":completion:*" menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

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

# vi cursor shapes
zle-keymap-select() {
	case $KEYMAP in
		vicmd) echo -ne "\e[1 q" ;;
		viins|main) echo -ne "\e[5 q" ;;
	esac
}
zle -N zle-keymap-select
zle-line-init() {
	zle -K viins
	echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne "\e[5 q"
preexec() {
	echo -ne "\e[5 q"
}

autoload edit-command-line
zle -N edit-command-line
bindkey "^e" edit-command-line

plugdir="/usr/share/zsh/plugins"
if [ -d "$plugdir" ]; then
	[ -f "$plugdir/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh" ] &&
		. "$plugdir/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"
	[ -f "$plugdir/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh" ] &&
		. "$plugdir/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
	if [ -f "$plugdir/zsh-history-substring-search/zsh-history-substring-search.zsh" ]; then
		. "$plugdir/zsh-history-substring-search/zsh-history-substring-search.zsh"
		bindkey -a "k" history-substring-search-up
		bindkey -a "j" history-substring-search-down
		bindkey "^[[A" history-substring-search-up
		bindkey "^[[B" history-substring-search-down
	fi
fi
unset plugdir

bindkey -s "^f" 'cd "$(dirname "$(fzf-tmux)")"\n'
bindkey -s "^s" '$EDITOR "$(fzf-tmux)"\n'
bindkey -s "^t" '[ -f TODO.md ] && $EDITOR TODO.md || notes todo\n'
#bindkey -s "^[t" '[ -d .git ] && grep TODO -Hnr *\n'

alias doas="doas "

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && . "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"

# https://github.com/rupa/z
[ -f "$HOME/programs/z/z.sh" ] && . "$HOME/programs/z/z.sh"
