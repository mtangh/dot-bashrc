# ${bashrcdir}/05path.sh
# $Id$

# path config command
pathconf="${bashrcdir}/bin/pathconfig"

# paths
paths_dirs=""

# root or admin
is_sys_adm=0

# root ?
if [ "$UID" = "0" ] ||
   [[ "$(/bin/groups)" =~ (, *| *)(wheel|admin)(, *| *) ]]
then is_sys_adm=1
fi

# lookup paths file(s)
for lookuppath in \
{"${bashrcdir}","${bashlocal}"}/pathconfig.d/paths \
{"${HOME}/.","${XDG_CONFIG_HOME:-${HOME}/.config}/"}paths
do
  for paths_file in $( {
    [ -d "${lookuppath%/*}" ] &&
    echo "${lookuppath}"{.${os},.${osvendor},.${machine},}
    [ -d "${lookuppath}.d" ] &&
    echo "${lookuppath}".d{/${os},/${osvendor},/${machine},}/*
  } 2>/dev/null; )
  do
    [ -f "${paths_file}" ] || continue
    paths_dirs="${paths_dirs+${paths_dirs} }"
    [ -x "${paths_file}" ] &&
    paths_dirs="${paths_dirs}$(/bin/bash ${paths_file})"
    [ -x "${paths_file}" ] ||
    paths_dirs="${paths_dirs}$(/bin/cat ${paths_file})"
  done
  for group_name in $(id -Gn 2>/dev/null)
  do
    for paths_file in
    "${lookuppath}"
    [ -f "${paths_file}" ] || continue
    paths_dirs="${paths_dirs+${paths_dirs} }"
    [ -x "${paths_file}" ] &&
    paths_dirs="${paths_dirs}$(/bin/bash ${paths_file})"
    [ -x "${paths_file}" ] ||
    paths_dirs="${paths_dirs}$(/bin/cat ${paths_file})"
  done
  unset paths_file
done 2>/dev/null || :

# Set default if dirs is empty
if [ -z "${paths_dirs}" ]
then
  for path_entry in $(
  : "Default path-list" && {
    [ $is_sys_adm -ne 0 ] &&
    echo {/usr/local,/usr,}/sbin
    echo {/usr/local,/usr,}/bin
  } 2>/dev/null || :; )
  do
    [ -d "${path_entry}" ] && {
      paths_dirs="${paths_dirs+${paths_dirs} }"
      paths_dirs="${paths_dirs}${path_entry}"
    } || :
  done
fi 2>/dev/null || :

# for ${HOME}/bin
for path_entry in {${HOME},${XDG_CONFIG_HOME:-$HOME/.config}}/{s,.s,,.}bin
do
  [ -d "${path_entry}" ] && {
    paths_dirs="${paths_dirs+${paths_dirs} }"
    paths_dirs="${paths_dirs}${path_entry}"
  } || :
done

# export new PATH
PATH=
eval $($pathconf PATH -s -f -a ${paths_dirs})

# Cleanup
unset pathconf
unset brc_cpaths sys_cpaths
unset usr_cpaths xdg_cpaths
unset paths_dirs path_entry
unset is_sys_adm

# *eof*
