# ${bashrc_dir}/90colorls.sh
# $Id$

##
## color ls
##

# load color ls settings
for lscolors_d in \
{"${bash_local}","${bashrc_dir}"}/colors.d{/${os},/${osvendor},}
do
  [ -e "${lscolors_d}/colorls.sh" ] &&
  . "${lscolors_d}/colorls.sh" 2>/dev/null &&
  break || :
done || :

# Cleanup
unset lscolors_d

# *eof*
