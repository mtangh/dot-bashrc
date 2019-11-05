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
__pf_rc_loader "${bashrc_dir}"/profile.d/[0-9][0-9]*.sh
} 2>/dev/null || :; )
do
  [ -f "${profile_sh}" ] &&
  [ -x "${profile_sh}" ] &&
  . "${profile_sh}" || :
done

# Cleanup
unset profile_sh

# end
return 0
