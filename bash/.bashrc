# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=erasedups:ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=3000
HISTFILESIZE=5000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then

    normal="\[\033[00m\]"
    purple="\[\033[01;34m\]"

    boldNormal="\[\033[01;00m\]"
    boldGreen="\[\033[01;32m\]"
    boldRed="\[\033[01;31m\]"

    if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
        host="${boldGreen}\h${normal}${purple}@${normal}"
    fi

    source /usr/share/git/git-prompt.sh

    lastCommandStatus="if [ \$? = 0 ]; then echo \"${boldGreen}\"; else echo \"${boldRed}\"; fi"

    GIT_PS1_SHOWCOLORHINTS="true"
    GIT_PS1_HIDE_IF_PWD_IGNORED="true"
    GIT_PS1_SHOWCONFLICTSTATE="true"
    GIT_PS1_SHOWDIRTYSTATE="true"
    GIT_PS1_SHOWSTASHSTATE="true"
    GIT_PS1_SHOWUNTRACKEDFILES="true"

    PS1="${debian_chroot:+($debian_chroot)}${host}\`${lastCommandStatus}\`\u${normal}: ${purple}\w${normal}\$(__git_ps1 \" (%s)\")\n${normal}\$ "

    unset host
    unset normal
    unset purple
    unset boldGreen
    unset boldRed
    unset boldNormal
    unset lastCommandStatus
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

mkcd(){
    mkdir -p "$1" && cd "$_";
}

# Use vim mode in bash
# set -o vi
# bind '"jk":vi-movement-mode'
# bind -m vi-command 'Control-l: clear-screen'

# dirname is treated as cd dirname
shopt -s autocd

# spell correction for cd
shopt -s cdspell

# Fix java whitescreen app issues on xmonad
# Consider removing this from here : Look into the hack xmonad module
export _JAVA_AWT_WM_NONREPARENTING=1

# fzf settings 
fzf_dir="/usr/share/fzf"

# source both files
if [ -d "$fzf_dir" ]; then
    . $fzf_dir/key-bindings.bash
    . $fzf_dir/completion.bash
fi

# Git auto-completion
source /usr/share/git/completion/git-completion.bash

# QMK auto-competion
source ~/qmk_firmware/util/qmk_tab_complete.sh

# Askpass
export SUDO_ASKPASS=$HOME/.local/bin/askpass-rofi

export GPG_TTY=$(tty)
