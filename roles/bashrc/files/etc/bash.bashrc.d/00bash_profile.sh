# ${bashrcdir}/00bash_profile.sh
# $Id$

# Run login shell only.
[[ "${BASH_SOURCE[@]}" \
  =~ .*\ /etc/profile$ ]] ||
  return 0

# Load scripts under '${profiledir}' dir
for profile_sh in \
"${bashrcdir}"/profile.d/[0-9][0-9]*.sh{,".${os}",".${osvendor}"}
do
  [ -x "${profile_sh}" ] && {
    . "${profile_sh}"
  } || :
done 2>/dev/null

# Cleanup
unset profile_sh

# end
return 0
