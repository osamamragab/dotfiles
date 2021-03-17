setopt autocd
setopt interactive_comments
setopt prompt_subst
stty stop undef

__git_branch() {
	br="$(git symbolic-ref HEAD --short 2>/dev/null)"
	[ "$br" ] && echo "($br) "
}

PS1='%B%{%F{cyan}%}%c %{%F{blue}%}$(__git_branch)%{%F{green}%}>%b%{%f%} '

HISTSIZE=10000000
SAVEHIST=10000000

autoload -U compinit
zstyle ":completion:*" menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

bindkey -v
export KEYTIMEOUT=1

bindkey -M menuselect "h" vi-backward-char
bindkey -M menuselect "k" vi-up-line-or-history
bindkey -M menuselect "l" vi-forward-char
bindkey -M menuselect "j" vi-down-line-or-history
bindkey -M menuselect '^[[Z' reverse-menu-complete

bindkey -v "^?" backward-delete-char
bindkey "^[[P" delete-char
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

# vi cursor shapes
zle-keymap-select() {
	case $KEYMAP in
		vicmd) echo -ne '\e[1 q' ;;
		viins|main) echo -ne '\e[5 q' ;;
	esac
}
zle -N zle-keymap-select
zle-line-init() {
	zle -K viins
	echo -ne '\e[5 q'
}
zle -N zle-line-init
echo -ne '\e[5 q'
preexec() {
	echo -ne '\e[5 q'
}

autoload edit-command-line
zle -N edit-command-line
bindkey "^e" edit-command-line

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && . "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"

# https://github.com/rupa/z
[ -s "$HOME/programs/z/z.sh" ] && . "$HOME/programs/z/z.sh"
