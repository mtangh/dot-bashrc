# ${bashrcdir}/04inputrc.sh
# $Id$

# Find inputrc file in
for input_rc in $(
/bin/ls -1 \
"${HOME}/.inputrc.d"/{${TERM},default} \
"${HOME}/.inputrc"{.${TERM},} \
"${bashrcdir}/inputrc.d"/{${TERM},default} \
2>/dev/null; )
do
  # Test with suffix
  for file_suffix in ${machine} ${osvendor} ${ostype}
  do
    [ -r "${input_rc}.${file_suffix}" ] && {
      INPUTRC="${input_rc}.${file_suffix}" &&
      break 2; }
  done
  # Test without suffix
  [ -z "${INPUTRC}" -a -r "${input_rc}" ] && {
    INPUTRC="${input_rc}" &&
    break; }
done

# Cleanup
unset input_rc file_suffix

# Export
[ -n "$INPUTRC" ] &&
  export INPUTRC

# end
return 0