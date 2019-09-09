# ${bashrcdir}/06manpath.sh
# $Id$

# path config command
pathconf="${bashrcdir}/bin/pathconfig"

# manpath file and directory.
sys_manpath_file="${bashrcdir}/pathconfig.d/manpaths"
sys_manpaths_dir="${bashrcdir}/pathconfig.d/manpaths.d"
ule_manpath_file="/usr/local/etc/manpaths"
ule_manpaths_dir="/usr/local/etc/manpaths.d"
usr_manpath_file="${HOME}/.manpaths"
xdg_manpath_file="${XDG_CONFIG_HOME:-${HOME}/.config}/manpaths"

# manpaths entry
manpaths_dirs=""

# lookup manpaths file(s)
for manpath_entry in $(
/bin/ls -1 \
"${sys_manpath_file}" \
"${sys_manpaths_dir}"/* \
"${ule_manpath_file}" \
"${ule_manpaths_dir}"/* \
{${usr_manpath_file},${xdg_manpath_file}}{.${machine},.${osvendor},.${ostype}} \
{${usr_manpath_file},${xdg_manpath_file}}.d/{${machine}/,${osvendor}/,${ostype}/,}* \
2>/dev/null; )
do
  [ -f "${manpath_entry}" ] ||
    continue
  [ -x "${manpath_entry}" ] &&
    manpaths_dirs="${manpaths_dirs+${manpaths_dirs} }$(/bin/bash ${manpath_entry} 2>/dev/null)"
  [ -x "${manpath_entry}" ] ||
    manpaths_dirs="${manpaths_dirs+${manpaths_dirs} }$(/bin/cat ${manpath_entry} 2>/dev/null)"
done

# export new PATH
MANPATH=
eval $($pathconf MANPATH -s -a ${manpaths_dirs})

# Cleanup
unset pathconf
unset sys_manpath_file usr_manpath_file xdg_manpath_file
unset manpaths_dirs manpath_entry

# end
return 0
