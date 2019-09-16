# ${bashrcdir}/12completion.sh
# $Id$

# completion dierctory
for completdir in \
{"${bashrcdir}","${bashlocal}"}/completion.d \
{"${XDG_CONFIG_HOME:-${HOME}/.config}/","${HOME}/."}bash_completion.d
do
  if [ -d "${completdir}" ]
  then
    for complet_sh in \
    "${completdir}"/*.sh{,.${os},.${osvendor},.${machine}} \
    "${completdir}"/{"${osvendor}","${os}"}/*.sh{,.${machine}}
    do
      [ -x "${complet_sh}" ] && {
        . "${complet_sh}"
      } || :
    done
    unset complet_sh
  fi
done 2>/dev/null || :

# Cleanup
unset completdir

# *eof*
