# ${bashrcdir}/01bash_init.sh
# $Id$

[ -d "/etc/profile.d" ] ||
  return 0

# load the /etc/profiled.*.sh
for profile_sh in \
$(/bin/ls -1 /etc/profile.d/*.sh)
do
  [ -x "$profile_sh" ] &&
    . "$profile_sh"
done

# cleanup
unset profile_sh

# end
return 0
