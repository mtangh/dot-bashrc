# ${bashrcdir}/01bash_init.sh
# $Id$

[ -d "/etc/profile.d" ] ||
  return

# load the /etc/profiled.*.sh
for profile_sh in \
`/bin/ls -1 /etc/profile.d/*.sh 2>/dev/null`
do
  [ -x "$profile_sh" ] &&
    . "$profile_sh" 2>/dev/null
done

# cleanup
unset profile_sh

# *eof* 
