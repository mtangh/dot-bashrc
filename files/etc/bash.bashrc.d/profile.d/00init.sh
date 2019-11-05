# ${bashrc_dir}/profile.d/00init.sh
# $Id$

# check "$HOME/.bashrc"
[ -f "${HOME}/.bashrc" ] &&
  return 0

# Update user-home
( cd "${bashrc_dir}" 2>/dev/null &&
  [ -x "${usrhomeupd:=./bin/update-user-home}" ] && {
    "${usrhomeupd}" --skel=./skel.d
  }; ) || :

# Updated
[ -f "${HOME}/.bashrc" ] || {
  touch "${HOME}/.bashrc"
}

# *eof*
return 0
