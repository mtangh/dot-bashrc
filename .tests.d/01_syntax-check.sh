#!/bin/bash
THIS="${BASH_SOURCE##*/}"
CDIR=$([ -n "${BASH_SOURCE%/*}" ] && cd "${BASH_SOURCE%/*}" &>/dev/null; pwd)

# Run tests
echo "[${tests_name}] syntax-check.sh" && {

  # Path
  bashrc_dir="${tests_wdir}/files/etc/bash.bashrc.d"

  # Error
  syntax_err=0

  # Syntax check
  for shscript in $(set +x && {
    find "${bashrc_dir}/bin" -type f |sort
    find "${bashrc_dir}" -type f -a -name "*.sh*" |sort
    } 2>/dev/null; )
  do
    echo "${shscript}:"
    bash -n "${shscript}" || syntax_err=$?
  done &&
  [ $syntax_err -le 0 ] &&
  echo "OK."

} &&
echo "[${tests_name}] DONE."

# End
exit $?
