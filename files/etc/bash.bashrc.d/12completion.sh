# ${bashrc_dir}/12completion.sh
# $Id$

# completion dierctory
for completdir in \
{"${bashrc_dir}","${bash_local}"}/completion.d \
{"${XDG_CONFIG_HOME:-${HOME}/.config}/","${HOME}/."}bash_completion.d
do
  if [ -d "${completdir}" ]
  then
    for complet_sh in $( {
    /bin/ls "${completdir}"/*.sh{,.${os},.${osvendor},.${machine}}
    /bin/ls "${completdir}"/{"${osvendor}","${os}"}/*.sh{,.${machine}}
    } 2>/dev/null; )
    do
      [ -x "${complet_sh}" ] && . "${complet_sh}" || :
    done
    unset complet_sh
  fi
done 2>/dev/null || :

# Cleanup
unset completdir

# *eof*
