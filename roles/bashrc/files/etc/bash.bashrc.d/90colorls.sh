# ${bashrcdir}/90colorls.sh
# $Id$

##
## color ls
##

# load color ls settings
for lscolors_d in \
"/usr/local/etc/${bashrcdir##*/}/colors.d" \
"${bashrcdir}"/colors.d{/${os},}
do
  [ -e "${lscolors_d}/colorls.sh" ] &&
  . "${lscolors_d}/colorls.sh" &&
  break || :
done 1>/dev/null 2>&1 || :

# Cleanup
unset lscolors_d

# *eof*
