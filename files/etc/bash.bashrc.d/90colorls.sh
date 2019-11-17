# ${bashrc_dir}/90colorls.sh
# $Id$

##
## color ls
##

# load color ls settings
for lscolorssh in $( {
__pf_rc_loader \
"${bash_local}"/colors.d/${vendor:+$vendor/}colorls.sh \
"${bashrc_dir}"/colors.d/${os:+$os/}colorls.sh \
"${bashrc_dir}"/colors.d/colorls.sh
} 2>/dev/null || :; )
do
  [ -f "${lscolorssh}" -a -x "${lscolorssh}" ] && {
    . "${lscolorssh}" && break
  } || :
done || :
unset lscolorssh

# *eof*
