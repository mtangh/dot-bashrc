# ${bashrc_dir}/06manpath.sh
# $Id$

# path config command
pathconf="${bashrc_dir}/bin/pathconfig"

# manpaths entry
mpathsdirs=""

for mpathspath in \
/etc/manpaths \
{"${bashrc_dir}","${bash_local}"}/pathconfig.d/manpaths \
{"${HOME}/.","${XDG_CONFIG_HOME:-${HOME}/.config}/"}manpaths
do
  for mpathsfile in $(
    [ -n "${mpathspath}" -a -d "${mpathspath%/*}" ]  && {
      for ps in "" "${os}" "${osvendor}" "${machine}"
      do
        for gn in "" ${usergroups}
        do
          [ -f "${mpathspath}${ps:+.$ps}${gn:+.$gn}" ] &&
          echo "${mpathspath}${ps:+.$ps}${gn:+.$gn}" || :
          [ -d "${mpathspath}.d${ps:+/$ps}${gn:+/$gn}" ] &&
          echo "${mpathspath}.d${ps:+/$ps}${gn:+/$gn}"/* || :
        done
      done
    } 2>/dev/null)
  do
    [ -f "${mpathsfile}" ] || continue
    mpathsdirs="${mpathsdirs+${mpathsdirs} }"
    [ -x "${mpathsfile}" ] &&
    mpathsdirs="${mpathsdirs}$(/bin/bash ${mpathsfile} 2>/dev/null)"
    [ -x "${mpathsfile}" ] ||
    mpathsdirs="${mpathsdirs}$(/bin/cat ${mpathsfile} 2>/dev/null)"
  done
  unset mpathsfile
done || :

# export new PATH
MANPATH=
eval $($pathconf MANPATH -s -a ${mpathsdirs})

# Cleanup
unset pathconf
unset mpathsdirs mpathspath

# end
return 0
