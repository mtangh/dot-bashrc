# ${bashrcdir}/04inputrc.sh
# $Id$

for input_rc in \
${HOME}/.inputrc.d/${TERM}{.${machine},.${osvendor},.${ostype},} \
${HOME}/.inputrc.d/default{.${machine},.${osvendor},.${ostype},} \
${HOME}/.inputrc.${TERM}{.${machine},.${osvendor},.${ostype},} \
${HOME}/.inputrc{.${machine},.${osvendor},.${ostype},} \
${bashrcdir}/inputrc.d/${TERM}{.${machine},.${osvendor},.${ostype},} \
${bashrcdir}/inputrc.d/default
do
  [ -r "$input_rc" ] &&
    INPUTRC="$input_rc" &&
    break
done
unset input_rc

[ -n "$INPUTRC" ] &&
  export INPUTRC

# *eof*
