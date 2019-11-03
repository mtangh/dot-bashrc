# ${bashrc_dir}/00bash_profile.sh
# $Id$

[ -n "${BASH:-}" ] ||
  return 0

# Run login shell only.
[[ "${BASH_SOURCE[@]}" \
  =~ .*\ /etc/profile$ ]] ||
  return 0

# Load scripts under '${profiledir}' dir
for profile_sh in $( {
/bin/ls "${bashrc_dir}"/profile.d/[0-9][0-9]*.sh{,".${os}",".${osvendor}"}
} 2>/dev/null; )
do
  [ -x "${profile_sh}" ] && . "${profile_sh}" || :
done

# Cleanup
unset profile_sh

# end
return 0
