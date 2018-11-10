# ${bashrcdir}/99user_bashrc.sh
# $Id$

: && {

# User local .bashrc file(s)
for dot_bashrc_sh in \
${HOME}/{.bash,}.bashrc{.${ostype},.${osvendor},.${machine},} \
${HOME}/{.bash,}.bashrc.d/{${ostype},${osvendor},${machine}} \
${HOME}/.bashrc
do
  [[ "${BASH_SOURCE[@]}" \
    =~ .*\ ${dot_bashrc_sh}(\ .*|\ *)$ ]] &&
    continue
  [ -f "${dot_bashrc_sh}" ] &&
    . "${dot_bashrc_sh}"
done

# Load scripts under the 'bash.bashrc.d' dir
for bashrc_sh in \
$(ls -1 ${HOME}/{.bash,}.bashrc.d/[0-9][0-9]*.sh{.${ostype},.${osvendor},.${machine},})
do
  [ -x "$bashrc_sh" ] &&
  . "$bashrc_sh"
done

# cleanup
unset dot_bashrc_sh bashrc_sh

} 1>/dev/null 2>&1 || :

# *eof*
