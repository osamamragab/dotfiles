#!/bin/sh

cdir="$(dirname "$(readlink -f "$0")")"
cp -srfv "$cdir/.config" "$cdir/.local" "$HOME"
ln -sf "$HOME/.config/shell/profile" "$HOME/.zprofile"
ln -sf "$HOME/.config/tmux/tmux.conf" "$HOME/.tmux.conf"
