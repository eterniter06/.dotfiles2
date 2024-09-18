#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# File for all additional path directories
if [ -f "$HOME/.bash_paths" ]; then
    . ~/.bash_paths
fi

export XCURSOR_PATH=${XCURSOR_PATH}:~/.local/share/icons
if [[ -z $DISPLAY ]] ; then
    [[ $XDG_VTNR -eq 1 ]] && startx
    [[ $XDG_VTNR -eq 2 ]] && dbus-run-session startplasma-wayland
fi
