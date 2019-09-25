#!/bin/bash
THIS="${BASH_SOURCE##*/}"
CDIR=$([ -n "${BASH_SOURCE%/*}" ] && cd "${BASH_SOURCE%/*}" &>/dev/null; pwd)

# Run tests
echo "[${tests_name}] syntax-check.sh" && {

  bash -n syntax-check.sh &&
  bash syntax-check.sh

} &&
echo "[${tests_name}] DONE."

# End
exit $?
