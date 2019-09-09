# ${bashrcdir}/90colorls.sh
# $Id$

##
## color ls
##

# colors dir.
sys_colors_dir="${bashrcdir}/colors.d"
ule_colors_dir="/usr/local/etc/${bashrcdir##*/}/colors.d"

# load color ls settings
for lscolors_sh in \
{${ule_colors_dir},${sys_colors_dir}}/${ostype}/colorls.sh \
{${ule_colors_dir},${sys_colors_dir}}/colorls.sh
do
  [ -e "${lscolors_sh}" ] && {
    . "${lscolors_sh}" &&
    break
  } || :
done 2>/dev/null

# Cleanup
unset lscolors_sh
unset sys_colors_dir ule_colors_dir

# *eof*
