# ${bashrcdir}/80vim.sh
# $Id$

unset tmpid

[ -x "`type -p vim`" ] ||
  return 0   

[ $UID -le 500 ] &&
  return

# for bash and zsh, only if no alias is already set
alias vi 1>/dev/null 2>&1 ||
  alias vi=vim

# *eof*
