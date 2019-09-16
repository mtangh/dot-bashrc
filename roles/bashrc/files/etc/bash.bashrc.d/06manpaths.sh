# ${bashrcdir}/06manpath.sh
# $Id$

# path config command
pathconf="${bashrcdir}/bin/pathconfig"

# manpath file and directory.
brc_mpaths="${bashrcdir}/pathconfig.d/manpaths"
sys_mpaths="/usr/local/etc/${bashrcdir##*/}/pathconfig.d/manpaths"
usr_mpaths="${HOME}/.manpaths"
xdg_mpaths="${XDG_CONFIG_HOME:-${HOME}/.config}/manpaths"

# manpaths entry
mpathsdirs=""

# lookup manpaths file(s)
for mpathentry in $(
: "manpaths list" && {
  echo {"${brc_mpaths}","${sys_mpaths}"}
  echo {"${brc_mpaths}","${sys_mpaths}"}.d/*
  echo "${usr_mpaths}"{.${os},.${vendor},.${machine}} \
  echo "${xdg_mpaths}"{.${os},.${vendor},.${machine}} \
  echo "${usr_mpaths}".d{/${os},/${vendor},/${machine},}/* \
  echo "${xdg_mpaths}".d{/${os},/${vendor},/${machine},}/* \
} 2>/dev/null || :; )
do
  [ -f "${mpathentry}" ] || continue
  mpathsdirs="${mpathsdirs+${mpathsdirs} }"
  [ -x "${mpathentry}" ] &&
  mpathsdirs="${mpathsdirs}$(/bin/bash ${mpathentry})"
  [ -x "${mpathentry}" ] ||
  mpathsdirs="${mpathsdirs}$(/bin/cat ${mpathentry})"
done 2>/dev/null || :

# export new PATH
MANPATH=
eval $($pathconf MANPATH -s -a ${mpathsdirs})

# Cleanup
unset pathconf
unset brc_mpaths sys_mpaths
unset usr_mpaths xdg_mpaths
unset mpathsdirs mpathentry

# end
return 0
