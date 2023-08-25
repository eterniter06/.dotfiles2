#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

export XCURSOR_PATH=${XCURSOR_PATH}:~/.local/share/icons
export PATH="$HOME/.local/bin:$PATH"
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && startx

