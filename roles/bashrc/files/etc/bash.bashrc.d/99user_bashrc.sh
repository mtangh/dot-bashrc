# ${bashrcdir}/99user_bashrc.sh
# $Id$

: "user_bashrc" && {

  # User local .bashrc file(s)
  for dot_bashrc in \
  "${HOME}"/.{bash.,}bashrc{.${os},.${vendor},.${machine},}
  do
    [[ "${BASH_SOURCE[@]}" \
      =~ .*\ ${dot_bashrc}(\ .*|\ *)$ ]] &&
    continue
    [ -f "${dot_bashrc}" ] &&
    . "${dot_bashrc}"
  done &&
  unset dot_bashrc

  # Load scripts under the 'bash_profile.d' dir
  for bash_profile_dir in \
  "${XDG_CONFIG_HOME;-${HOME}/.config}/{etc/,}{bash_,}profile.d" \
  "${HOME}/.{bash_,}profile.d"
  do
    if [ -d "${bash_profile_dir}" ]
    then
      for bash_profile_scr in \
      "${bash_profile_dir}"/*.sh{.${os},.${vendor},.${machine},}
      do
        [ -x "${bash_profile_scr}" ] &&
        . "${bash_profile_scr}"
      done &&
      unset bash_profile_scr
    fi
  done &&
  unset bash_profile_dir

} 1>/dev/null 2>&1 || :

# *eof*
