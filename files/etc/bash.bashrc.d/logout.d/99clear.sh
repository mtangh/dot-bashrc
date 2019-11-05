# ${bashrc_dir}/logout.d/99clear.sh
# $Id$

[ "${SHLVL:-0}" = "1" ] ||
return 0

[ -n "$(type -P clear &>/dev/null)" ] && {

  clear

} 2>/dev/null || :

# *eof*
