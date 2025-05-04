setopt autocd
setopt interactive_comments
setopt prompt_subst
setopt histignorespace
setopt hist_reduce_blanks
setopt hist_verify
setopt hist_ignore_all_dups
stty stop undef

autoload -Uz vcs_info
zstyle ":vcs_info:*" enable git svn hg
zstyle ":vcs_info:*" formats "(%b) "
precmd() {
	vcs_info
	# foot's pipe-command-output shell integration
	builtin zle || printf "\e]133;D\e\\"
}
preexec() {
	# foot's pipe-command-output shell integration
	printf "\e]133;C\e\\"
}

PROMPT='%B%F{cyan}%c %F{blue}${vcs_info_msg_0_}%F{%(?.green.red)}>%f%b '
RPROMPT='%(?..[%F{red}%?%f] )'
[ -n "$SSH_TTY" ] && PROMPT="%F{magenta}[%M] $PROMPT"

HISTSIZE=999999999
SAVEHIST=$HISTSIZE
HISTFILE="${HISTFILE:-$XDG_STATE_HOME/history}"

export GPG_TTY="$(tty)"

[ -r "$XDG_CONFIG_HOME/shell/aliasrc" ] && . "$XDG_CONFIG_HOME/shell/aliasrc"
alias doas="doas "

fpath=("$ZDOTDIR/completions" $fpath)
_comp_options+=(globdots)
autoload -Uz compinit
zstyle ":completion:*" menu select
zstyle ":completion:*" use-cache on
zstyle ":completion:*" cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
zstyle ":completion:*" completer _complete _extensions _correct
zmodload zsh/complist
find "$ZDOTDIR/.zcompdump" -mtime +1 >/dev/null 2>&1 && compinit || compinit -C

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
	[ $ZSH_SUBSHELL -eq 0 ] && osc7-pwd
}
autoload -Uz add-zsh-hook
add-zsh-hook -Uz chpwd chpwd-osc7-pwd

zshcache_time="$(date +%s%N)"
precmd_rehash() {
	[ -f /var/cache/zsh/pacman ] && {
		local paccache_time="$(date -r /var/cache/zsh/pacman +%s%N)"
		[ "$zshcache_time" -lt "$paccache_time" ] && {
			rehash
			zshcache_time="$paccache_time"
		}
	}
}
add-zsh-hook -Uz precmd precmd_rehash

fzf_select_widget() {
	local file="$(fd --type f --hidden --strip-cwd-prefix | fzf)" || return
	BUFFER="$BUFFER \"$file\""
	zle redisplay
	zle accept-line
}
zle -N fzf_select_widget
bindkey "^s" fzf_select_widget

fzf_editor_widget() {
	local file="$(fd --type f --hidden --strip-cwd-prefix | fzf)" || return
	BUFFER="$EDITOR \"$file\""
	zle redisplay
	zle accept-line
}
zle -N fzf_editor_widget
bindkey "^f" fzf_editor_widget

fzf_open_widget() {
	local file="$(fd --type f --hidden --strip-cwd-prefix | fzf)" || return
	opener="open"
	command -v "$opener" >/dev/null 2>&1 || opener="xdg-open"
	BUFFER="$opener \"$file\""
	zle redisplay
	zle accept-line
}
zle -N fzf_open_widget
bindkey "^o" fzf_open_widget

fzf_cd_widget() {
	local dir="$(fd --type d --hidden --strip-cwd-prefix | fzf)" || return
	BUFFER="cd \"$dir\""
	zle redisplay
	zle accept-line
}
zle -N fzf_cd_widget
bindkey "^g" fzf_cd_widget

todo_widget() {
	BUFFER="notes todo"
	[ -f TODO.md ] && BUFFER="$EDITOR TODO.md"
	zle redisplay
	zle accept-line
}
zle -N todo_widget
bindkey "^t" todo_widget

[ -r /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ] && {
	. /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
	bindkey -a "k" history-substring-search-up
	bindkey -a "j" history-substring-search-down
	bindkey "^[[A" history-substring-search-up
	bindkey "^[[B" history-substring-search-down
}
[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh ] && {
	ZSH_AUTOSUGGEST_STRATEGY=(history completion)
	. /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
}
[ -r /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ] &&
	. /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"
[ -r /usr/share/z/z.sh ] && . /usr/share/z/z.sh
