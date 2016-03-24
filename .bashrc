
# Check for an interactive session
[ -z "$PS1" ] && return

alias ls='ls --color=auto'
alias la='ls -laG'

set -o vi

PS1='[\u@\h \W]\$ '

HISTSIZE=30
HISTFILESIZE=30
HISTCONTROL=ignoredups
HISTTIMEFORMAT='%F %T -> '

#export LC_ALL="es_ES.UTF-8"


alias h='history'

