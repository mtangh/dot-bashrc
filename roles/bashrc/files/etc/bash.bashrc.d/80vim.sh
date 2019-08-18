# ${bashrcdir}/80vim.sh
# $Id$

# Unset tmpid
unset tmpid

# vim installed ?
[ -x "$(type -p vim)" ] ||
  return 0

# Unprivileged user
[ $UID -gt 500 ] ||
  return 0

# for bash and zsh, only if no alias is already set
alias vi 1>/dev/null 2>&1 || {
  alias vi=vim
}

# *eof*
