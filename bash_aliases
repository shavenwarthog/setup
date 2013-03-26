# -*- shell-script -*-

alias ls='ls -CF'
alias pygrep='find . -name "*.py" | xargs egrep'

# :::::::::::::::::::::::::::::::::::::::::::::::::: APT

alias agi='sudo apt-get install'
alias acs='apt-cache search'

# :::::::::::::::::::::::::::::::::::::::::::::::::: MISC

# alias rgrep='egrep -nri "$@" .'

# setterm -term linux -back black -fore white -clear

# :::::::::::::::::::::::::::::::::::::::::::::::::: GIT

alias c='git commit -am'
alias gb='git branch'
# alias gcm='git commit -m 
alias gd='git diff'
alias gdh='git diff HEAD^'
alias gds='git diff --stat'
alias gst='git status'
alias gv='git commit -v'

# ................ git flow
alias gff='git flow feature'


# alias gd='git diff | $EDITOR'
alias gba='git branch -a'
# alias gdc='git diff --cached | mate'
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

