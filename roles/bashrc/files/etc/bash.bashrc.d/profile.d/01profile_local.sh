# ${bashrcdir}/profile.d/01profile_local.sh
# $Id$

[ -d "${bashlocal}" ] ||
return 0

# Load scripts under '${profiledir}' dir
for profile_sh in \
"${bashlocal}"/profile.d/[0-9][0-9]*.sh{"${machine}",}
do
  [ -x "${profile_sh}" ] && {
    . "${profile_sh}"
  } || :
done 2>/dev/null

# Cleanup
unset profile_sh

# end
return 0
