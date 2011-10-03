# -*- shell-script -*-

alias ls='ls -CF'

alias agi='sudo aptitude install'
alias acs='aptitude search'

# :::::::::::::::::::::::::::::::::::::::::::::::::: GIT
alias c='git commit -am'
alias gv='EDITOR=emacsclient git commit -v'
alias gva='EDITOR=emacsclient git commit -va'
alias gds='git diff --stat'
alias gd='git diff'

# Git aliases from David; esp the first two:
alias gst='git status'
# alias gd='git diff | $EDITOR'
alias gb='git branch'
alias gba='git branch -a'
# alias gc='git commit -v'
# alias gca='git commit -v -a'
alias gdc='git diff --cached | mate'
alias gl='git pull'
alias gp='git push'
alias gk='gitk --all &'

# pip bash completion start
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip
# pip bash completion end

alias sggrep='~/work/johnm/sggrep'
