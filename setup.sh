#!/bin/sh

cdir="$(dirname "$(readlink -f "$0")")"
cp -srfv "$cdir/.config" "$cdir/.local" "$cdir/.zprofile" "$cdir/.editorconfig" "$HOME"
ln -sf "$HOME/.config/tmux/tmux.conf" "$HOME/.tmux.conf"
