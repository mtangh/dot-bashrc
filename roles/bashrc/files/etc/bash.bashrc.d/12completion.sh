# ${bashrcdir}/12completion.sh
# $Id$

# completion dierctory
for completdir in \
"${bashrcdir}/completion.d" \
"/usr/local/etc/${bashrcdir##*/}/completion.d" \
"${XDG_CONFIG_HOME:-${HOME}/.config}/bash_completion.d" \
"${HOME}/.bash_completion.d"
do
  if [ -d "${completdir}" ]
  then
    for complet_sh in \
    "${completdir}"/*.sh{,.${os},.${vendor},.${machine}} \
    "${completdir}/${os}"/*.sh{,.${vendor},.${machine}}
    do
      [ -x "${complet_sh}" ] && {
        . "${complet_sh}"
      } || :
    done
    unset complet_sh
  fi
done

# Cleanup
unset completdir || :

# *eof*
