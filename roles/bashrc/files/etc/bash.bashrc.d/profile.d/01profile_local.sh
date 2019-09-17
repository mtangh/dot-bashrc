# ${bashrc_dir}/profile.d/01profile_local.sh
# $Id$

[ -d "${bash_local:-}" ] ||
return 0

# Load scripts under '${profiledir}' dir
for profile_sh in \
"${bash_local}"/profile.d/[0-9][0-9]*.sh{"${machine}",}
do
  [ -x "${profile_sh}" ] && {
    . "${profile_sh}"
  } || :
done

# Cleanup
unset profile_sh

# end
return 0
