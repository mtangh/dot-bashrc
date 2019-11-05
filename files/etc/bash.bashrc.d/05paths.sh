# ${bashrc_dir}/05path.sh
# $Id$

# path config command
pathconf="${bashrc_dir}/bin/pathconfig"

# paths
paths_dirs=""

# lookup paths file(s)
for paths_file in $( {
__pf_rc_loader \
/etc/paths \
{"${bashrc_dir}","${bash_local}"}/pathconfig.d/paths \
{"${HOME}/.","${XDG_CONFIG_HOME:-${HOME}/.config}/"}paths
} 2>/dev/null || :; )
do
  [ -f "${paths_file}" ] || continue
  paths_dirs="${paths_dirs:+${paths_dirs} }"
  [ -x "${paths_file}" ] &&
  paths_dirs="${paths_dirs}$(echo $(/bin/bash ${paths_file} 2>/dev/null))"
  [ -x "${paths_file}" ] ||
  paths_dirs="${paths_dirs}$(echo $(/bin/cat ${paths_file} 2>/dev/null))"
done || :
unset paths_file

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
      paths_dirs="${paths_dirs:+${paths_dirs} }"
      paths_dirs="${paths_dirs}${paths_file}"
    } || :
  done || :
  unset paths_file
fi || :

# for ${HOME}/bin
for userbindir in {${HOME},${XDG_CONFIG_HOME:-$HOME/.config}}/{s,.s,,.}bin
do
  [ -d "${userbindir}" ] && {
    paths_dirs="${paths_dirs:+${paths_dirs} }"
    paths_dirs="${paths_dirs}${userbindir}"
  } || :
done || :
unset userbindir

# export new PATH
PATH=
eval $($pathconf PATH -s -f -a ${paths_dirs})

# Cleanup
unset pathconf
unset paths_dirs

# *eof*
