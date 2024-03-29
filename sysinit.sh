#!/bin/sh
# vim: wrap
# shellcheck disable=SC2164

cdir="$(dirname "$(readlink -f "$0")")"
if [ -x "$cdir/setup.sh" ]; then
	echo "running dotfiles setup script..."
	"$cdir/setup.sh"
fi

if ! command -v doas >/dev/null 2>&1; then
	echo "installing doas..."
	sudo xbps-install -Sy opendoas
	echo "permit nopass keepenv :wheel" | sudo tee /etc/doas.conf >/dev/null
fi

level="${1:-0}"

xi() {
	name="$1"
	pkgs=""
	shift
	while [ $# -gt 0 ]; do
		case "$1" in
			-*)
				c="$(echo "$1" | tr -cd "-" | wc -c)"
				[ "$c" -eq "${#1}" ] && [ "$level" -lt "${#1}" ] && break
				;;
			*)
				pkgs="$pkgs $1"
				;;
		esac
		shift
	done
	[ -z "$pkgs" ] && return
	[ "$name" != "_" ] && echo "installing $name..."
	# shellcheck disable=SC2086
	doas xbps-install -Sy $pkgs
}

echo "updating system..."
doas xbps-install -Sy xbps
doas xbps-install -Syu

xi "x" \
	xorg xorg-server xinit libX11-devel libXft-devel libXinerama libXinerama-devel libXrandr libXrandr-devel

xi "filesystems support" \
	fuse fuse-exfat mtpfs simple-mtpfs

xi "network manager" \
	NetworkManager ufw

xi "build tools" \
	gcc git make pkg-config

xi "general tools" \
	curl wget gnupg gnupg2 openssh pass passmenu keepassxc tmux nnn slop maim dunst xdg-utils xtools time entr vsv mlocate fzf ripgrep cronie libnotify xcompmgr unclutter urlview darkhttpd youtube-dl pam-gnupg xdotool xclip yank xwallpaper pmount autofs tar bsdtar xz zip unzip tlp delta tig exiftool redshift newsboat \
	- lshw rsync inotify-tools earlyoom spt sc-im surfraw android-tools scrcpy translate-shell xautolock miniserve yt-dlp youtube-viewer aria2 openntpd bluez lprng qemu lftp fribidi arandr tree bat glow dragon catimg mdp screenkey git-extras git-lfs xoris fbida buku \
	-- glab github-cli pcmanfm xarchiver ffmpegthumbnailer gnome-epub-thumbnailer

xi "manual pages" \
	man-pages man-pages-posix

xi "text editor" \
	vim neovim

xi "zsh" \
	zsh zsh-completions zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search

xi "audio tools" \
	alsa-utils alsa-plugins-pulseaudio pulseaudio pamixer pulsemixer

xi "multimedia tools" \
	ffmpeg ImageMagick mpv sxiv \
	-- playerctl mpv-mpris

xi "music players" \
	mpd mpc ncmpcpp

xi "pdf tools" \
	zathura zathura-pdf-mupdf mupdf \
	-- wkhtmltopdf

xi "video/photo/audio editors" \
	- gimp \
	-- openshot darktable krita audacity lmms obs

xi "system monitoring tools" \
	lm_sensors htop iftop powertop mon \
	- bmon atop iotop gotop \
	-- speedometer vnstat sysstat procs nmon wavemon

xi "email tools" \
	neomutt msmtp isync notmuch

xi "chatting applications" \
	irssi \
	- weechat weechat-python \
	-- tuir toot Signal-Desktop telegram-desktop

xi "web browsers" \
	firefox lynx w3m tor \
	- amfora sacc torbrowser-launcher \
	-- lagrange

xi "torrent tools" \
	transmission rtorrent \
	- btfs

xi "programming stuff" \
	clang tcc go rustup python3 lua nodejs R perl ruby c gdb valgrind strace ltrace clang-analyzer rust-analyzer yarn binutils upx delve jq xxd
[ "$level" -gt 0 ] && xi _ clib elixir clojure leiningen gef radare2 postgresql13 mariadb sqlite redis flex bison byacc clang-tools-extra shellcheck shfmt pylint black python3-ipython python3-numpy python3-matplotlib python3-scipy python3-jupyter jupyterlab
go install -v github.com/google/pprof@latest github.com/securego/gosec@latest honnef.co/go/tools/cmd/staticcheck@latest
if [ "$level" -gt 1 ]; then
	xi _ clisp erlang ctags grpc protobuf terraform tflint tokei misspell pgcli hexedit hyperfine svgcleaner
	go install -v google.golang.org/protobuf/cmd/protoc-gen-go@latest github.com/fullstorydev/grpcurl@latest github.com/timakin/bodyclose@latest
	pip install mycli litecli
fi
cargo install stylua
yarn global add typescript eslint prettier typescript-language-server pyright
[ "$level" -gt 0 ] && yarn global add sass pug @vue/cli vls svelte-language-server
[ "$level" -gt 1 ] && yarn global add svgo ts-node nodemon serve livereload
if ! command -v deno >/dev/null 2>&1; then
	curl -fsSL https://deno.land/x/install/install.sh | \
		DENO_INSTALL="${XDG_DATA_HOME:-$HOME/.local/share}/deno" sh
fi

xi "cheat sheet tools" \
	cheat tealdeer
if [ "$level" -gt 0 ] && ! command -v cht.sh >/dev/null 2>&1; then
	doas curl -o /usr/local/bin/cht.sh https://cht.sh/:cht.sh
	doas chmod +x /usr/local/bin/cht.sh
fi

xi "docker" \
	docker docker-compose docker-credential-pass

xi "arduino" \
	- arduino arduino-cli

xi "markup/latex tools" \
	pandoc groff mdocml texlive \
	-- texlive-full

xi "networking tools" \
	nmap netcat lsof traceroute mtr wireshark wireshark-qt termshark inetutils iputils net-tools bind-utils socat websocat iperf3 arp-scan aircrack-ng ettercap bettercap macchanger sqlmap wrk hey wuzz \
	- hashcat hashcat-utils testssl.sh radamsa nemesis \
	-- geoip geoip-data kismet proxychains-ng thc-hydra john
cargo install xh
pip install mitmproxy

xi "fonts" \
	font-ibm-plex-otf font-inconsolata-otf amiri-font fonts-croscore-ttf

PROGRAMSDIR="${PROGRAMSDIR:-$HOME/programs}"
[ -d "$PROGRAMSDIR" ] || mkdir -p "$PROGRAMSDIR"

guser="$(git config --global --get user.username)"
if [ -z "$guser" ]; then
	printf "git username: "
	read -r guser
fi

if [ "$guser" ]; then
	echo "installing suckless programs..."
	for p in dwm st dmenu dwmblocks surf tabbed slock sent; do
		echo "installig $p"
		ups="git://git.suckless.org/$p"
		sbr="master"
		case "$p" in
			dwmblocks)
				ups="git@github.com:torrinfail/$p.git"
				;;
			surf)
				sbr="surf-webkit2"
				xi "surf dependencies" \
					webkit2gtk-devel gcr-devel gst-libav gst-plugins-good1
				;;
			sent)
				xi "sent dependencies" \
					farbfeld
				;;
		esac
		[ -d "$PROGRAMSDIR/$p" ] || git clone "git@gitlab.com:$guser/$p.git" "$PROGRAMSDIR/$p"
		cd "$PROGRAMSDIR/$p"
		git checkout main
		git remote add upstream "$ups"
		git fetch "$ups" "$sbr" && git merge "$ups/$sbr"
		doas make install && make clean
	done
fi

echo "installing mutt-wizard..."
[ -d "$PROGRAMSDIR/mutt-wizard" ] || git clone git@github.com:LukeSmithxyz/mutt-wizard.git "$PROGRAMSDIR/mutt-wizard"
cd "$PROGRAMSDIR/mutt-wizard"
git checkout master
doas make install

echo "installing nnn..."
[ -d "$PROGRAMSDIR/nnn" ] || git clone git@github.com:jarun/nnn.git "$PROGRAMSDIR/nnn"
cd "$PROGRAMSDIR/nnn"
git checkout master
doas make install O_NERD=1 && make clean

echo "installing hx..."
[ -d "$PROGRAMSDIR/hx" ] || git clone git@github.com:krpors/hx.git "$PROGRAMSDIR/hx"
cd "$PROGRAMSDIR/hx"
git checkout master
doas make install && make clean

echo "installing z..."
[ -d "$PROGRAMSDIR/z" ] || git clone git@github.com:rupa/z.git "$PROGRAMSDIR/z"
doas cp -f "$PROGRAMSDIR/z/z.1" /usr/local/share/man/man1/z.1
doas chmod 644 /usr/local/share/man/man1/z.1

echo "installing lua-language-server"
[ -d "$PROGRAMSDIR/lua-language-server" ] || git clone git@github.com:sumneko/lua-language-server.git
cd "$PROGRAMSDIR/lua-language-server"
git submodule update --init --recursive
cd 3rd/luamake && ./compile/install.sh && cd ../.. && ./3rd/luamake/luamake rebuild

echo "installing elixir-ls"
[ -d "$PROGRAMSDIR/elixir-ls" ] || git clone git@github.com:elixir-lsp/elixir-ls
cd "$PROGRAMSDIR/elixir-ls"
mix deps.get && mix compile && mix elixir_ls.release -o bin

cd "$cdir"

if [ ! -f "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim" ]; then
	echo "installing vim plug..."
	curl --create-dirs -fLo "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim" https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if [ -f /usr/lib/mpv-mpris/mpris.so ] && [ ! -f "$HOME/.config/mpv/scripts/mpris.so" ]; then
	echo "linking mpv-mpris plugin"
	[ -d "$HOME/.config/mpv/scripts" ] || mkdir -p "$HOME/.config/mpv/scripts"
	doas ln -s /usr/lib/mpv-mpris/mpris.so "$HOME/.config/mpv/scripts/mpris.so"
fi

echo "changing default shell to zsh..."
chsh -s "$(which zsh)"
