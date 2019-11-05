# ${bashrc_dir}/98aliases.sh
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
[ -r "/etc/bash.bashrc" ] && {
  trap "source /etc/bash.bashrc" USR1
  alias reload-bashrc-all="pkill -USR1 bash"
} || :

# load aliases
for aliases_file in $( {
__pf_rc_loader \
{"${bash_local}","${bashrc_dir}"}/aliases
} 2>/dev/null || :; )
do
  [ -f "${aliases_file}" ] &&
  [ -r "${aliases_file}" ] &&
  . "${aliases_file}" 2>/dev/null || :
done || :
unset aliases_file

# *eof*

