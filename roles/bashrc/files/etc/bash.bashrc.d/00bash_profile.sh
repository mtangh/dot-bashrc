# ${bashrcdir}/00bash_profile.sh
# $Id$

[[ "${BASH_SOURCE[@]}" \
  =~ .*\ /etc/profile$ ]] ||
  return 0

# profile.d
profiledir="${bashrcdir}/profile.d"

# Load '${profiledir}' scripts
for profile_sh in \
`ls -1 ${profiledir}/[0-9][0-9]*.sh{,.${ostype},.${osvendor},.${machine}} 2>/dev/null`
do
  [ -x "${profile_sh}" ] &&
    . "${profile_sh}" 2>/dev/null
done

# cleanup
unset profiledir 
unset profile_sh

# *eof*
