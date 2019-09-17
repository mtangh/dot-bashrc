#!/bin/bash
THIS="${BASH_SOURCE##*/}"
NAME="${THIS%.*}"
CDIR=$(cd "${BASH_SOURCE%/*}" &>/dev/null; pwd)

# Path
bashrc_dir="roles/bashrc/files/etc/bash.bashrc.d"

# Ret
exitcode=0

# Syntax check
for scr in $(
find "${bashrc_dir}/bin" -type f |sort
find "${bashrc_dir}" -type f -a -name "*.sh*" |sort
)
do
  bash -n "$scr" || exitcode=$?
done

# Syntax ?
[ $exitcode -le 0 ] && {
  echo "OK."
} || :

# end
exit $exitcode
