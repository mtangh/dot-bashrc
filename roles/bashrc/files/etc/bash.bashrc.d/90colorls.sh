# ${bashrcdir}/90colorls.sh
# $Id$

##
## color ls
##

# colors dir.
sys_colors_dir="${bashrcdir}/colors.d"

# load color ls settings
for lscolors_sh in \
"${sys_colors_dir}/${ostype}/colorls.sh" \
"${sys_colors_dir}/colorls.sh" 
do
  [ -e "${lscolors_sh}" ] &&
    .  "${lscolors_sh}" 2>/dev/null &&
    break
done

# cleanup
unset lscolors_sh
unset sys_colors_dir

# *eof*
