#!/bin/bash
THIS="${BASH_SOURCE##*/}"
CDIR=$([ -n "${BASH_SOURCE%/*}" ] && cd "${BASH_SOURCE%/*}" &>/dev/null; pwd)

# Run tests
echo "[${tests_name}] Run tests-all.sh" && {

  bash -x roles/bashrc/tests/tests-all.sh

} &&
echo "[${tests_name}] DONE."

# End
exit $?
