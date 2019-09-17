# ${bashrcdir}/99user_bashrc.sh
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
    . "${dot_bashrc}"
  done

  # Load scripts under the 'bash_profile.d' dir
  for bash_profile_dir in \
  "${XDG_CONFIG_HOME;-${HOME}/.config}/{etc/,}{bash_,}profile.d" \
  "${HOME}/.{bash_,}profile.d"
  do
    if [ -d "${bash_profile_dir}" ]
    then
      for bash_profile_scr in \
      "${bash_profile_dir}"/*.sh{.${os},.${osvendor},.${machine},}
      do
        [ -x "${bash_profile_scr}" ] &&
        . "${bash_profile_scr}" || :
      done
      unset bash_profile_scr
    fi
  done

  unset dot_bashrc
  unset bash_profile_dir

} || :

# *eof*
