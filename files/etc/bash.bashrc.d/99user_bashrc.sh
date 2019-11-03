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
  for dot_profiles_dir in \
  "${XDG_CONFIG_HOME:-${HOME}/.config}"/{etc/,}{bash_,}profile.d \
  "${HOME}"/.{bash_,}profile.d
  do
    if [ -d "${dot_profiles_dir}" ]
    then
      for dot_profiles_scr in $( {
      /bin/ls "${dot_profiles_dir}"/*.sh{,.${os},.${osvendor},.${machine}}
      } 2>/dev/null; )
      do
        [ -x "${dot_profiles_scr}" ] && . "${dot_profiles_scr}" || :
      done
      unset dot_profiles_scr
    fi
  done
  unset dot_profiles_dir

} || :

# *eof*
