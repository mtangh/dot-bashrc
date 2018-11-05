#!/bin/bash
THIS="${0##*/}"
CDIR=$([ -n "${0%/*}" ] && cd "${0%/*}" 2>/dev/null; pwd)
# Name
THIS="${THIS:-git-files-update.sh}"
BASE="${BASE}"
# Prohibits overwriting by redirect and use of undefined variables.
set -Cu
# Install Shell
install_sh="https://raw.githubusercontent.com/mtangh/dot-git-files/master/install.sh"
# Get Command
script_get=""
[ -z "${script_get}" ] &&
[ -n "$(type -P curl 2>/dev/null)" ] &&
script_get="$(type -P curl 2>/dev/null) -sL"
[ -z "${script_get}" ] &&
[ -n "$(type -P wget 2>/dev/null)" ] &&
script_get="$(type -P wget 2>/dev/null) -qO -"
# Run
${script_get} "${install_sh}" 2>/dev/null |
/bin/bash
# End
exit $?
