# ${bashrcdir}/98aliases.sh
# $Id$

# cd
alias -- -='cd -'
alias ..='cd ..'
alias cdp='cd -P'

# cp, mv, rm
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

# history
alias hist=history

# ls
alias la="ls -a"
alias l.="ls -d"
alias ll="ls -l"
alias lla="ls -la"

# Reloading bashrc
trap "source /etc/bash.bashrc" USR1
alias reload-bashrc-all="pkill -USR1 bash"

# *eof*

