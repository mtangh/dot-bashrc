# ${bashrcdir}/00bash_profile.sh
# $Id$

[[ "${BASH_SOURCE[@]}" \
  =~ .*\ /etc/profile$ ]] ||
  return 0

# profile.d
profiledir="${bashrcdir}/profile.d"

# Load scripts under '${profiledir}' dir
for profile_sh in $(
/bin/ls -1 "${profiledir}"/[0-9][0-9]*.sh{.${ostype},.${osvendor},.${machine},} \
2>/dev/null; )
do
  [ -x "${profile_sh}" ] &&
    . "${profile_sh}"
done

# Cleanup
unset profiledir profile_sh

# end
return 0
