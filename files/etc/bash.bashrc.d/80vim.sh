# ${bashrc_dir}/80vim.sh
# $Id$

# Unset tmpid
unset tmpid &>/dev/null || :

# vim installed ?
[ -x "$(type -p vim)" ] ||
  return 0

# Unprivileged user
[ ${UID:--1} -gt 500 ] ||
  return 0

# for bash and zsh, only if no alias is already set
alias vi &>/dev/null || {
  alias vi=vim
}

# *eof*
