# ${bashrc_dir}/99user_bashrc.sh
# $Id$

: "user_bashrc" && {

  # User local .bashrc file(s)
  for dot_bashrc in \
  "${HOME}"/{.bash,}.bashrc{.${machine},.${osvendor},.${os},}
  do
    [ -f "${dot_bashrc}" ] ||
      continue
    [[ "${BASH_SOURCE[@]}" \
      =~ .*\ ${dot_bashrc}(\ .*|\ *)$ ]] &&
      continue
    . "${dot_bashrc}" &&
      break
  done
  unset dot_bashrc

  # Load scripts under the 'bash_profile.d' dir
  for dot_prof_dir in \
  "${XDG_CONFIG_HOME:-${HOME}/.config}"/{etc/,}{bash_,}profile.d \
  "${HOME}"/.{bash_,}profile.d
  do
    [ -d "${dot_prof_dir}" ] ||
      continue
    for dot_prof_scr in $( {
    __pf_rc_loader "${dot_prof_dir}"/*.sh
    } 2>/dev/null || :; )
    do
      [ -x "${dot_prof_scr}" ] && . "${dot_prof_scr}" || :
    done
    unset dot_prof_scr
  done
  unset dot_prof_dir

} || :

# *eof*
