# ${bashrcdir}/99user_bashrc.sh
# $Id$

# User local .bashrc file(s)
for dot_bashrc_sh in \
`ls -1 ${HOME}/.bashrc{.${ostype},.${osvendor},.${machine}} 2>/dev/null` \
`ls -1 ${HOME}/.bashrc.d/{${ostype},${osvendor},${machine}} 2>/dev/null` \
"${HOME}/.bashrc"
do
  [[ "${BASH_SOURCE[@]}" \
    =~ .*\ ${dot_bashrc_sh}(\ .*|\ *)$ ]] &&
    continue
  [ -f "${dot_bashrc_sh}" ] &&
    . "${dot_bashrc_sh}"
done

# cleanup
unset dot_bashrc_sh

# *eof*
