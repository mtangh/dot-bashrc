#!/bin/bash
THIS="${BASH_SOURCE##*/}"
CDIR=$([ -n "${BASH_SOURCE%/*}" ] && cd "${BASH_SOURCE%/*}" &>/dev/null; pwd)

# Run tests
echo "[${tests_name}] install.sh for user" && {

  bash -n install.sh &&
  bash install.sh -D --install --source=$(pwd)/roles/bashrc && {
    ( for check_file in \
        ${HOME}/.config/bash.{bashrc,profile,bash_logout} \
        ${HOME}/.config/bash.bashrc.d/vim/vimrc \
        ${HOME}/.config/bash.bashrc.d/skel.d/default/dot.{bashrc,inputrc,vimrc} \
        ${HOME}/.bashrc ;
      do [ -e "${check_file}" ] && echo "Found - ${check_file}" || exit 1
      done; ) &&
    ( unset os vendor osvendor machine
      . "${HOME}/.config/bash.bashrc" &&
      echo "Load ${HOME}/.config/bash.bashrc" && {
        [ -n "$os"       ] && echo "Found - os=$os"             &&
        [ -n "$vendor"   ] && echo "Found - vendor=$vendor"     &&
        [ -n "$osvendor" ] && echo "Found - osvendor=$osvendor" &&
        [ -n "$machine"  ] && echo "Found - machine=$machine"   &&
        :;
      }; )
  }

} &&
echo "[${tests_name}] DONE."

# End
exit $?
