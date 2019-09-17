# ${bashrc_dir}/04inputrc.sh
# $Id$

inputrc_path=""
inputrc_file=""

# Lookup inputrc file in
for inputrc_path in \
"${XDG_CONFIG_HOME:-${HOME}/.config}/inputrc" \
"${HOME}/.inputrc" \
"${bash_local}/inputrc" \
"${bashrc_dir}/inputrc"
do
  for inputrc_file in \
  "${inputrc_path}"{.d/${TERM},.d/default,.${TERM},}{.${machine},.${osvendor},.${os},}
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