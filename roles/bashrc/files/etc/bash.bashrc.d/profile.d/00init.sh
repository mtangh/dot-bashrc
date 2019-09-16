# ${bashrcdir}/profile.d/00init.sh
# $Id$

# check "$HOME/.bashrc"
[ -f "${HOME}/.bashrc" ] &&
  return 0

# Update user-home
( cd "${bashrcdir}" 2>/dev/null &&
  [ -x "${usrhomeupd}" ] && {
    "${usrhomeupd}" ${usrhomeopt} --skel=./skel.d
  }; ) || :

# *eof*
return 0
