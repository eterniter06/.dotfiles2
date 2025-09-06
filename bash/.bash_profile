#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

export XCURSOR_PATH=${XCURSOR_PATH}:~/.local/share/icons
if [[ -z $DISPLAY ]] ; then
    [[ $XDG_VTNR -eq 1 ]] && startx
    [[ $XDG_VTNR -eq 2 ]] && dbus-run-session startplasma-wayland
fi
