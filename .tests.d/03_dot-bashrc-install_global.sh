#!/bin/bash
THIS="${BASH_SOURCE##*/}"
CDIR=$([ -n "${BASH_SOURCE%/*}" ] && cd "${BASH_SOURCE%/*}" &>/dev/null; pwd)

# Run tests
echo "[${tests_name}] install.sh for global" && {

  bash -n install.sh &&
  sudo bash -x install.sh -G --install --source=$(pwd)/roles/bashrc && {
    ( for check_file in \
        /etc/{bash.,}{bashrc,profile} \
        /etc/bash.bash{_logout,.logout} \
        /etc/bash.bashrc.d/vim/vimrc \
        /etc/bash.bashrc.d/skel.d/default/dot.{bashrc,inputrc,vimrc};
      do [ -e "${check_file}" ] && echo "Found - ${check_file}" || exit 1
      done; ) &&
    ( bash
      unset os vendor osvendor machine
      . "/etc/bash.bashrc" &&
      echo "Load /etc/bash.bashrc" && {
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
