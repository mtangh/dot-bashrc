# ${bashrcdir}/profile.d/00init.sh
# $Id$

# check "$HOME/.bashrc"
[ -f "${HOME}/.bashrc" ] &&
  return

# user template dir.
tmplt_dir=${bashrcdir}/skel.d

# make user template file(s)
if [ -d "${tmplt_dir}/`uname`" ]
then
  ${bashrcdir}/bin/mkUserTmplt \
    "${tmplt_dir}/`uname`" 1>/dev/null 2>&1
fi

# unset
unset tmplt_dir

# *eof* 
