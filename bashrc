# -*- shell-script -*-

export PATH=$HOME/bin:$PATH

export WORKON_HOME=~/Envs
source /usr/local/bin/virtualenvwrapper.sh


# for Chef, via "Test-Driven Infrastructure with Chef"
[[ -s "~/.rvm/scripts/rvm" ]] && source "~/.rvm/scripts/rvm"


# :::::::::::::::::::::::::::::::::::::::::::::::::: ANDROID

# export PATH=$HOME/src/android-sdk/tools:$HOME/src/android-sdk/platform-tools/:$PATH


# :::::::::::::::::::::::::::::::::::::::::::::::::: PYTHON

export PIP_DOWNLOAD_CACHE=$HOME/.pip_download_cache
export WORKON_HOME=~/Envs



# If not running interactively, don't do anything
[ -z "$PS1" ] && return


# :::::::::::::::::::::::::::::::::::::::::::::::::: PROMPT

# Git branch in prompt -- http://raftaman.net/?p=936
export PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '

# :::::::::::::::::::::::::::::::::::::::::::::::::: WORK

export CDPATH=~/work

. ~/src/setup/misc/django_bash_completion 
. ~/src/setup/misc/fabric-completion.bash
. ~/src/setup/misc/git-completion.bash


# :::::::::::::::::::::::::::::::::::::::::::::::::: MISC

export DEBEMAIL="johnlmitchell@gmail.com"
export DEBFULLNAME="John Mitchell"


# :::::::::::::::::::::::::::::::::::::::::::::::::: HISTORY

# don't put duplicate lines in the history
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend
shopt -s cdspell # enables automatic typo correction for directory names
shopt -s nocaseglob 


# :::::::::::::::::::::::::::::::::::::::::::::::::: MISC

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

set bell-style none



# :::::::::::::::::::::::::::::::::::::::::::::::::: PROMPT
# # set variable identifying the chroot you work in (used in the prompt below)
# if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
#     debian_chroot=$(cat /etc/debian_chroot)
# fi

# # set a fancy prompt (non-color, unless we know we "want" color)
# case "$TERM" in
#     xterm-color) color_prompt=yes;;
# esac

# # uncomment for a colored prompt, if the terminal has the capability; turned
# # off by default to not distract the user: the focus in a terminal window
# # should be on the output of commands, not on the prompt
# #force_color_prompt=yes

# if [ -n "$force_color_prompt" ]; then
#     if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
# 	# We have color support; assume it's compliant with Ecma-48
# 	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
# 	# a case would tend to support setf rather than setaf.)
# 	color_prompt=yes
#     else
# 	color_prompt=
#     fi
# fi

# if [ "$color_prompt" = yes ]; then
#     PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# else
#     PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
# fi
# unset color_prompt force_color_prompt

# JM:
PS1='${debian_chroot:+($debian_chroot)}\u@\h:\W\$ '




# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi


# XXXXX:
# export CDPATH=$HOME/src
# export PATH=$HOME/local/bin:$PATH

# 
# enable color support of ls and also add handy aliases
# - disabled in Emacs
if [ "$color_prompt" -a -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
export EDITOR=vim


# /usr/share/doc/bash-completion/README.gz
set show-all-if-ambiguous on
set visible-stats on
set page-completions off


# . /etc/bash_completion.d/django_bash_completion
# compleat
PATH="${PATH}:/home/johnm/src/android-sdk/tools"
