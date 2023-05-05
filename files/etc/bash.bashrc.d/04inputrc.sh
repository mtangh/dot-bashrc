# ${bashrc_dir}/04inputrc.sh
# $Id$

inputrc_file=""

# Lookup inputrc file in
for inputrc_file in $( {
__pf_rc_loader -r \
{"${XDG_CONFIG_HOME:-${HOME}/.config}"/,"${HOME}"/.}inputrc \
{"${bash_local}","${bashrc_dir}"}/inputrc
} 2>/dev/null || :; )
do
  [ -f "${inputrc_file}" -a -r "${inputrc_file}" ] && {
    INPUTRC="${inputrc_file}" &&
    break
  } || :
done || :

# unset
unset inputrc_file

# Export
[ -n "${INPUTRC:-}" ] && {
  export INPUTRC
} || :

# end
return 0