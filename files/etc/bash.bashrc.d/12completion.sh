# ${bashrc_dir}/12completion.sh
# $Id$

# completion dierctory
for complet_sh in $( {
__pf_rc_loader \
{"${bashrc_dir}","${bash_local}"}/completion.d/*.sh \
"${XDG_CONFIG_HOME:-${HOME}/.config}/"bash_completion.d/*.sh \
"${HOME}/."bash_completion.d/*.sh
} 2>/dev/null || :; )
do
  [ -f "${complet_sh}" -a -x "${complet_sh}" ] && {
    . "${complet_sh}"
  } || :
done 2>/dev/null || :
unset complet_sh

# *eof*
