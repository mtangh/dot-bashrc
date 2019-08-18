# ${bashrcdir}/05path.sh
# $Id$

# path config command
pathconf="${bashrcdir}/bin/pathconfig"

# path file and directory.
sys_path_file="${bashrcdir}/paths.d/paths"
sys_paths_dir="${bashrcdir}/paths.d/include"
usr_path_file="${HOME}/.paths"
xdg_path_file="${XDG_CONFIG_HOME:-${HOME}/.config}/paths"

# path entry
paths_root=""
paths_dirs=""

# root or admin
root_or_admin=0

# root ?
if [ "$UID" = "0" ] ||
   [[ "`/bin/groups`" =~ (, *| *)(wheel|admin)(, *| *) ]]
then
  root_or_admin=1
fi

# root path setting
[ $root_or_admin -eq 0 ] &&
for path_entry in $(
/bin/ls -1 \
"${sys_path_file}.root" \
"${sys_paths_dir}/root"/* \
2>/dev/null; )
do
  [ -f "${path_entry}" -a -x "${path_entry}" ] &&
  paths_root="${paths_root+${paths_root} }$(/bin/bash ${path_entry})"
  [ -f "${path_entry}" -a ! -x "${path_entry}" ] &&
  paths_root="${paths_root+${paths_root} }$(/bin/cat ${path_entry})"
done 2>/dev/null || :

# Set default if empty
[ $root_or_admin -eq 0 -a -z "${paths_root}" ] &&
for path_entry in {/usr,}/sbin
do
  [ -d "${path_entry}" ] &&
  paths_root="${paths_root+${paths_root} }${path_entry}"
done 2>/dev/null || :

# lookup paths file(s)
for path_entry in $(
/bin/ls -1 \
"${sys_path_file}" \
"${sys_paths_dir}"/{${machine}/,${osvendor}/,${ostype}/,}/ \
{${usr_path_file},${xdg_path_file}}{.${machine},.${osvendor},.${ostype},} \
{${usr_path_file},${usr_path_file}}.d/{${machine}/,${osvendor}/,${ostype}/,}* \
2>/dev/null; )
do
  [ -f "${path_entry}" -a -x "${path_entry}" ] &&
  paths_dirs="${paths_dirs+${paths_dirs} }$(/bin/bash ${path_entry})"
  [ -f "${path_entry}" -a ! -x "${path_entry}" ] &&
  paths_dirs="${paths_dirs+${paths_dirs} }$(/bin/cat ${path_entry})"
done 2>/dev/null || :

# Set default if empty
[ -z "${paths_dirs}" ] &&
for path_entry in {/usr,}/bin
do
  [ -d "${path_entry}" ] &&
  paths_dirs="${paths_dirs+${paths_dirs} }${path_entry}"
done

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
