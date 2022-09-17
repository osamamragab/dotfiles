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

HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"

alias doas="doas "
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc" ] && . "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliasrc"

fpath=("${XDG_CONFIG_HOME:-$HOME/.config}/zsh/completions" $fpath)
autoload -U compinit
zstyle ":completion:*" menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# vi mode
bindkey -v
KEYTIMEOUT=1

# vi keys in completion menu
bindkey -M menuselect "h" vi-backward-char
bindkey -M menuselect "k" vi-up-line-or-history
bindkey -M menuselect "l" vi-forward-char
bindkey -M menuselect "j" vi-down-line-or-history
bindkey -M menuselect "^[[Z" reverse-menu-complete
bindkey -v "^?" backward-delete-char

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

bindkey "^[[P" delete-char
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

# edit line in vi
autoload edit-command-line
zle -N edit-command-line
bindkey "^e" edit-command-line
bindkey -M vicmd '^e' edit-command-line
bindkey -M vicmd '^[[P' vi-delete-char
bindkey -M visual '^[[P' vi-delete

bindkey -s "^o" 'xdg-open "$(fzf-tmux)" >/dev/null\n'
bindkey -s "^f" 'cd "$(dirname "$(fzf-tmux)")"\n'
bindkey -s "^t" '[ -f TODO.md ] && $EDITOR TODO.md || notes todo\n'

NNN_FIFO="$(mktemp /tmp/nnn-XXXXXX.fifo)"
onexit() {
	[ -p "$NNN_FIFO" ] && rm -f "$NNN_FIFO"
}
trap onexit EXIT

ZSHPLUGINSDIR="${ZSHPLUGINSDIR:-/usr/share/zsh/plugins}"
if [ -d "$ZSHPLUGINSDIR" ]; then
	[ -f "$ZSHPLUGINSDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh" ] &&
		. "$ZSHPLUGINSDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"
	if [ -f "$ZSHPLUGINSDIR/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh" ]; then
		ZSH_AUTOSUGGEST_STRATEGY=(history completion)
		. "$ZSHPLUGINSDIR/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
	fi
	if [ -f "$ZSHPLUGINSDIR/zsh-history-substring-search/zsh-history-substring-search.zsh" ]; then
		. "$ZSHPLUGINSDIR/zsh-history-substring-search/zsh-history-substring-search.zsh"
		bindkey -a "k" history-substring-search-up
		bindkey -a "j" history-substring-search-down
		bindkey "^[[A" history-substring-search-up
		bindkey "^[[B" history-substring-search-down
	fi
fi

[ -f "${PROGRAMSDIR:-$HOME/programs}/z/z.sh" ] && . "${PROGRAMSDIR:-$HOME/programs}/z/z.sh"
