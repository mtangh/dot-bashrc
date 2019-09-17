# ${bashrc_dir}/06manpath.sh
# $Id$

# path config command
pathconf="${bashrc_dir}/bin/pathconfig"

# manpaths entry
mpathsdirs=""

for paths_path in \
/etc/manpaths \
{"${bashrc_dir}","${bash_local}"}/pathconfig.d/manpaths \
{"${HOME}/.","${XDG_CONFIG_HOME:-${HOME}/.config}/"}manpaths
do
  for mpathsfile in $(
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
    [ -f "${mpathentry}" ] || continue
    mpathsdirs="${mpathsdirs+${mpathsdirs} }"
    [ -x "${mpathentry}" ] &&
    mpathsdirs="${mpathsdirs}$(/bin/bash ${mpathentry})"
    [ -x "${mpathentry}" ] ||
    mpathsdirs="${mpathsdirs}$(/bin/cat ${mpathentry})"
  done
  unset mpathsfile
done 2>/dev/null || :

# export new PATH
MANPATH=
eval $($pathconf MANPATH -s -a ${mpathsdirs})

# Cleanup
unset pathconf
unset mpathsdirs paths_path

# end
return 0
