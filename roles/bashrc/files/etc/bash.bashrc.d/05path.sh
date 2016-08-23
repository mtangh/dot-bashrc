# ${bashrcdir}/05path.sh
# $Id$

# path config command
pathconf=${bashrcdir}/bin/pathconfig

# path file and directory.
sys_path_file="${bashrcdir}/paths.d/paths"
sys_paths_dir="${bashrcdir}/paths.d/include"
usr_path_file="${HOME}/.paths"
usr_paths_dir="${HOME}/.paths.d"

# path entry
paths_root=""
paths_dirs=""

# root ?
if [ "$UID" = "0" ] ||
   [[ "`groups 2>/dev/null`" =~ (, *| *)(wheel|admin)(, *| *) ]]
then
  # root path setting
  for path_entry in \
  "${sys_path_file}.root" \
  `/bin/ls -1 ${sys_paths_dir}/root/* 2>/dev/null`
  do
    [ -f "${path_entry}" ] ||
      continue
    [ -x "${path_entry}" ] &&
      paths_root="${paths_root} `/bin/bash ${path_entry} 2>/dev/null`"
    [ -x "${path_entry}" ] ||
      paths_root="${paths_root} `/bin/cat ${path_entry} 2>/dev/null`"
  done
  if [ -z "${paths_root}" ]
  then
    for path_entry in /usr/sbin /sbin
    do
      [ -d "${path_entry}" ] &&
        paths_root="${paths_root} ${path_entry}"
    done
  fi
fi

# lookup paths file(s)
for path_entry in \
${sys_path_file} \
`/bin/ls -1 ${sys_paths_dir}/{${machine}/,${osvendor}/,${ostype}/,}* 2>/dev/null` \
${usr_path_file}{.${machine},.${osvendor},.${ostype}} \
`/bin/ls -1 ${usr_paths_dir}/{${machine}/,${osvendor}/,${ostype}/,}* 2>/dev/null`
do
  [ -f "${path_entry}" ] ||
    continue
  [ -x "${path_entry}" ] &&
    paths_dirs="${paths_dirs} `/bin/bash ${path_entry} 2>/dev/null`"
  [ -x "${path_entry}" ] ||
    paths_dirs="${paths_dirs} `/bin/cat ${path_entry} 2>/dev/null`"
done
if [ -z "${paths_dirs}" ]
then
  for path_entry in /usr/bin /bin
  do
    [ -d "${path_entry}" ] &&
      paths_dirs="${paths_dirs} ${path_entry}"
  done
fi
# for ${HOME}/bin
for path_entry in ${HOME}/{s,.s,,.}bin
do
  [ -d "${path_entry}" ] &&
    paths_dirs="${paths_dirs} ${path_entry}"
done

# export new PATH
PATH=
eval `$pathconf PATH -s -f -a ${paths_root} ${paths_dirs}`

# clean up
unset pathconf
unset sys_path_file usr_path_file
unset sys_paths_dir usr_paths_dir
unset paths_root paths_dirs path_entry

# *eof* 
