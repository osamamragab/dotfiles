setopt autocd
setopt interactive_comments
setopt prompt_subst
setopt histignorespace
stty stop undef

__promptcmd() {
	pr="%F{$([ $? -eq 0 ] && echo "green" || echo "red")}>"
	br="$(git symbolic-ref HEAD --short 2>/dev/null)"
	wd="%F{cyan}%c"
	[ "$br" ] && echo "$wd %F{blue}($br) $pr" || echo "$wd $pr"
}
PS1="%B\$(__promptcmd)%F{reset}%b "

HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"

MAILCHECK=0

fpath=("${XDG_CONFIG_HOME:-$HOME/.config}/zsh/completions" $fpath)
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

bindkey -s "^o" 'xdg-open "$(fzf-tmux)" >/dev/null\n'
bindkey -s "^s" '$EDITOR "$(fzf-tmux)"\n'
bindkey -s "^f" 'cd "$(dirname "$(fzf-tmux)")"\n'
bindkey -s "^t" '[ -f TODO.md ] && $EDITOR TODO.md || notes todo\n'
#bindkey -s "^[t" '[ -d .git ] && grep TODO -Hnr *\n'

NNN_FIFO="/tmp/nnn-$(shuf -i 100-999 -n 1).fifo"
onexit() {
	[ -p "$NNN_FIFO" ] && rm -f "$NNN_FIFO"
}
trap onexit EXIT

alias doas="doas "

# command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init -)"

[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && . "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"

# https://github.com/rupa/z
[ -f "$HOME/programs/z/z.sh" ] && . "$HOME/programs/z/z.sh"
