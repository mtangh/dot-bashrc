# ${bashrc_dir}/06manpath.sh
# $Id$

# path config command
pathconf="${bashrc_dir}/bin/pathconfig"

# manpaths entry
mpathsdirs=""

# lookup manpaths file(s)
for mpathsfile in $( {
__pf_rc_loader /etc/manpaths \
{"${bashrc_dir}","${bash_local}"}/pathconfig.d/manpaths \
{"${HOME}/.","${XDG_CONFIG_HOME:-${HOME}/.config}/"}manpaths
} 2>/dev/null || :; )
do
  [ -f "${mpathsfile}" ] || continue
  mpathsdirs="${mpathsdirs:+${mpathsdirs} }"
  [ -x "${mpathsfile}" ] &&
  mpathsdirs="${mpathsdirs}$(echo $(/bin/bash ${mpathsfile} 2>/dev/null))"
  [ -x "${mpathsfile}" ] ||
  mpathsdirs="${mpathsdirs}$(echo $(/bin/cat ${mpathsfile} 2>/dev/null))"
done || :
unset mpathsfile

# export new MANPATH
MANPATH=
eval $($pathconf MANPATH -s -a ${mpathsdirs})

# Cleanup
unset pathconf
unset mpathsdirs

# end
return 0
