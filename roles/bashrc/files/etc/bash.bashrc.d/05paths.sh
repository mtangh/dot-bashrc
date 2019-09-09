# ${bashrcdir}/05path.sh
# $Id$

# path config command
pathconf="${bashrcdir}/bin/pathconfig"

# path file and directory.
sys_path_file="${bashrcdir}/pathconfig.d/paths"
sys_paths_dir="${bashrcdir}/pathconfig.d/paths.d"
ule_path_file="/usr/local/etc/paths"
ule_paths_dir="/usr/local/etc/paths.d"
usr_path_file="${HOME}/.paths"
xdg_path_file="${XDG_CONFIG_HOME:-${HOME}/.config}/paths"

# path entry
paths_root=""
paths_dirs=""

# root or admin
root_or_admin=0

# root ?
if [ "$UID" = "0" ] ||
   [[ "$(/bin/groups)" =~ (, *| *)(wheel|admin)(, *| *) ]]
then
  root_or_admin=1
fi

# root path setting
if [ $root_or_admin -eq 0 ]
then
  for path_entry in $(
  /bin/ls -1 \
  "${sys_path_file}.root" \
  "${sys_paths_dir}/root"/* \
  "${ule_path_file}.root" \
  "${ule_paths_dir}/root"/* \
  2>/dev/null; )
  do
    [ -f "${path_entry}" -a -x "${path_entry}" ] &&
    paths_root="${paths_root+${paths_root} }$(/bin/bash ${path_entry})"
    [ -f "${path_entry}" -a ! -x "${path_entry}" ] &&
    paths_root="${paths_root+${paths_root} }$(/bin/cat ${path_entry})"
  done
  # Set default if empty
  if [ -z "${paths_root}" ]
  then
    for path_entry in {/usr/local,/usr,}/sbin
    do
      [ -d "${path_entry}" ] &&
      paths_root="${paths_root+${paths_root} }${path_entry}"
    done 
  fi 2>/dev/null || :
fi 2>/dev/null || :

# lookup paths file(s)
for path_entry in $(
/bin/ls -1 \
"${sys_path_file}" \
"${sys_paths_dir}"/* \
"${ule_path_file}" \
"${ule_paths_dir}"/* \
{${usr_path_file},${xdg_path_file}}{.${machine},.${osvendor},.${ostype},} \
{${usr_path_file},${xdg_path_file}}.d{/${machine},/${osvendor},/${ostype},}/* \
2>/dev/null; )
do
  [ -f "${path_entry}" -a -x "${path_entry}" ] &&
  paths_dirs="${paths_dirs+${paths_dirs} }$(/bin/bash ${path_entry})"
  [ -f "${path_entry}" -a ! -x "${path_entry}" ] &&
  paths_dirs="${paths_dirs+${paths_dirs} }$(/bin/cat ${path_entry})"
done 2>/dev/null || :

# Set default if empty
if [ -z "${paths_dirs}" ]
then
  for path_entry in {/usr/local,/usr,}/bin
  do
    [ -d "${path_entry}" ] &&
    paths_dirs="${paths_dirs+${paths_dirs} }${path_entry}"
  done
fi 2>/dev/null || :

# for ${HOME}/bin
for path_entry in {${HOME},${XDG_CONFIG_HOME:-$HOME/.config}}/{s,.s,,.}bin
do
  [ -d "${path_entry}" ] &&
  paths_dirs="${paths_dirs+${paths_dirs} }${path_entry}"
done

# export new PATH
PATH=
eval $($pathconf PATH -s -f -a ${paths_root} ${paths_dirs})

# Cleanup
unset pathconf
unset sys_path_file sys_paths_dir usr_path_file xdg_path_file
unset paths_root paths_dirs path_entry
unset root_or_admin

# *eof*
