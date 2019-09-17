# ${bashrc_dir}/05path.sh
# $Id$

# path config command
pathconf="${bashrc_dir}/bin/pathconfig"

# paths
paths_dirs=""

# lookup paths file(s)
for paths_path in \
/etc/paths \
{"${bashrc_dir}","${bash_local}"}/pathconfig.d/paths \
{"${HOME}/.","${XDG_CONFIG_HOME:-${HOME}/.config}/"}paths
do
  for paths_file in $(
    [ -n "${paths_path}" -a -d "${paths_path%/*}" ]  && {
      for ps in "" ${os} ${osvendor} ${machine}
      do
        for gn in "" ${usergroups}
        do
          [ -f "${paths_path}${ps:+.$ps}${gn:+.$gn}" ] &&
          echo "${paths_path}${ps:+.$ps}${gn:+.$gn}" || :
          [ -d "${paths_path}.d${ps:+/$ps}${gn:+/$gn}" ] &&
          echo "${paths_path}.d${ps:+/$ps}${gn:+/$gn}"/* || :
        done
      done
    } 2>/dev/null)
  do
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
  for paths_file in $( {
    [ "$(id -g)" = "0" ] &&
    echo {/usr/local,/usr,}/sbin
    echo {/usr/local,/usr,}/bin
  } 2>/dev/null || :; )
  do
    [ -d "${paths_file}" ] && {
      paths_dirs="${paths_dirs+${paths_dirs} }"
      paths_dirs="${paths_dirs}${paths_file}"
    } || :
  done
fi 2>/dev/null || :

# for ${HOME}/bin
for paths_file in {${HOME},${XDG_CONFIG_HOME:-$HOME/.config}}/{s,.s,,.}bin
do
  [ -d "${paths_file}" ] && {
    paths_dirs="${paths_dirs+${paths_dirs} }"
    paths_dirs="${paths_dirs}${paths_file}"
  } || :
done

# export new PATH
PATH=
eval $($pathconf PATH -s -f -a ${paths_dirs})

# Cleanup
unset pathconf
unset paths_dirs paths_path

# *eof*
