# ${bashrcdir}/01bash_init.sh
# $Id$

[ -d "/etc/profile.d" ] && {

  # load the /etc/profiled.*.sh
  for profile_sh in /etc/profile.d/*.sh
  do
    [ -x "$profile_sh" ] && {
      . "$profile_sh"
    } || :
  done

  # Cleanup
  unset profile_sh

} || :

# end
return 0
