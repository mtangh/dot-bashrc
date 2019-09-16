# ${bashrcdir}/04inputrc.sh
# $Id$

inputrc_file=""
fname_suffix=""

# inputrc path
sys_inputrc_path="/usr/local/etc/${bashrcdir##*/}/inputrc"
usr_inputrc_path="${HOME}/.inputrc"
xdg_inputrc_path="${XDG_CONFIG_HOME:-${HOME}/.config}/inputrc"

# Find inputrc file in
for inputrc_file in $(echo \
${usr_inputrc_path}{.d/${TERM},.d/default,.${TERM},}{.${vendor},.${os},${machine},} \
${xdg_inputrc_path}{.d/${TERM},.d/default,.${TERM},}{.${vendor},.${os},${machine},} \
${sys_inputrc_path}{.d/${TERM},.d/default,.${TERM},} \
${bashrcdir}/inputrc.d/{${TERM},default} \
2>/dev/null; )
do
  # Test without suffix
  [ -z "${INPUTRC}" -a -r "${inputrc_file}" ] && {
    INPUTRC="${inputrc_file}" &&
    break
  } || :
done

# Export
[ -n "$INPUTRC" ] && {
  export INPUTRC
} || :

# Cleanup
unset inputrc_file fname_suffix
unset usr_inputrc_path xdg_inputrc_path

# end
return 0