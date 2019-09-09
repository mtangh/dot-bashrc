# ${bashrcdir}/04inputrc.sh
# $Id$

inputrc_file=""
fname_suffix=""

# inputrc path
usr_inputrc_path="${HOME}/.inputrc"
xdg_inputrc_path="${XDG_CONFIG_HOME:-${HOME}/.config}/inputrc"

# Find inputrc file in
for inputrc_file in $(
/bin/ls -1 \
{${usr_inputrc_path},${xdg_inputrc_path}}.d/{${TERM},default} \
{${usr_inputrc_path},${xdg_inputrc_path}}{.${TERM},} \
/usr/local/etc/${bashrcdir##*/}/inputrc.d/{${TERM},default} \
/usr/local/etc/${bashrcdir##*/}/inputrc{.${TERM},} \
${bashrcdir}/inputrc.d/{${TERM},default} \
2>/dev/null; )
do
  # Test with suffix
  for fname_suffix in ${machine} ${osvendor} ${ostype}
  do
    [ -r "${inputrc_file}.${fname_suffix}" ] && {
      INPUTRC="${inputrc_file}.${fname_suffix}" &&
      break 2;
    } || :
  done
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