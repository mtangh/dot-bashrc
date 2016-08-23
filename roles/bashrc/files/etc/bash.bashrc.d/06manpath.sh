# ${bashrcdir}/06manpath.sh
# $Id$

# path config command
pathconf=${bashrcdir}/bin/pathconfig

# man path file and directory.
sys_manpath_file="/etc/manpaths"
usr_manpath_file="${HOME}/.manpaths"
sys_manpaths_dir="/etc/manpaths.d"
usr_manpaths_dir="${HOME}/.manpaths.d"

# man path entry
manpaths_dirs=""

# lookup manpaths file(s)
for manpath_entry in \
"${sys_manpath_file}" \
`/bin/ls -1 ${sys_manpaths_dir}/{${machine}/,${osvendor}/,${ostype}/,}* 2>/dev/null` \
"${usr_manpath_file}{.${machine},.${osvendor},.${ostype}}" \
`/bin/ls -1 ${usr_manpaths_dir}/{${machine}/,${osvendor}/,${ostype}/,}* 2>/dev/null`
do
  [ -f "${manpath_entry}" ] ||
    continue
  [ -x "${manpath_entry}" ] &&
    manpaths_dirs="${manpaths_dirs} `/bin/bash ${manpath_entry} 2>/dev/null`"
  [ -x "${manpath_entry}" ] ||
    manpaths_dirs="${manpaths_dirs} `/bin/cat ${manpath_entry} 2>/dev/null`"
done

# export new PATH
MANPATH=
eval `$pathconf MANPATH -s -a ${manpaths_dirs}`

# clean up
unset pathconf
unset sys_manpath_file usr_manpath_file
unset sys_manpaths_dir usr_manpaths_dir
unset manpaths_dirs manpath_entry

# *eof* 
