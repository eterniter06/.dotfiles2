#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

export XCURSOR_PATH=${XCURSOR_PATH}:~/.local/share/icons
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && startx

