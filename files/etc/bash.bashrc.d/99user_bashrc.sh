# ${bashrc_dir}/99user_bashrc.sh
# $Id$

: "user_bashrc" && {

  # User local .bashrc file(s)
  for dot_bashrc in $( {
  __pf_rc_loader -r "${HOME}"/{.bash,}.bashrc
  } 2>/dev/null || :; )
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
  for dot_prof_scr in $( {
  __pf_rc_loader \
  "${XDG_CONFIG_HOME:-${HOME}/.config}"/{etc/,}{bash_,}profile.d/*.sh \
  "${HOME}"/.{bash_,}profile.d/*.sh
  } 2>/dev/null || :; )
  do
    [ -f "${dot_prof_scr}" ] &&
    [ -x "${dot_prof_scr}" ] &&
    . "${dot_prof_scr}" || :
  done
  unset dot_prof_scr
´
} || :

# *eof*
