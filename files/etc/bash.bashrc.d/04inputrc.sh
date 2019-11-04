# ${bashrc_dir}/04inputrc.sh
# $Id$

inputrc_path=""
inputrc_file=""

# Lookup inputrc file in
for inputrc_path in \
{"${XDG_CONFIG_HOME:-${HOME}/.config}"/,"${HOME}"/.}inputrc \
{"${bash_local}","${bashrc_dir}"}/inputrc
do
  for inputrc_file in $( {
  __pf_rc_loader -r "${inputrc_path}"{.d/${TERM},.d/default,.${TERM},}
  } 2>/dev/null || :; )
  do
    [ -r "${inputrc_file}" ] && {
      INPUTRC="${inputrc_file}" &&
      break
    } || :
  done
done 2>/dev/null || :

# Export
[ -n "${INPUTRC:-}" ] && {
  export INPUTRC
} || :

# Cleanup
unset inputrc_path inputrc_file

# end
return 0