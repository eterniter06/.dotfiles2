#!/bin/bash

./setup_username.bash

# Todo: Check whether parent folder exists before stowing
# Stowing without checking for parent folder symlinks the entire directory
# e.g.: Stowing wallpapers below without checking if "$HOME/Pictures" exists will create a
# symlink $Home/Pictures -> Pictures/

stow \
    alacritty \
    bash \
    beets \
    fonts \
    git \
    kitty \
    nitrogen \
    nvim \
    picom \
    posyblack \
    vim \
    wallpapers \
    x \
    xmobar \
    xmonad
