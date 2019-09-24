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


  # Install shell for user
  - |
    set -x;
    : "install.sh for user" && {
      bash -n install.sh &&
      bash install.sh --install --source=$(pwd)/roles/bashrc && {
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
    : "OK";

  # Install shell for global
  - |
    set -x;
    : "install.sh for global" && {
      bash -n install.sh &&
      sudo bash install.sh -G --install --source=$(pwd)/roles/bashrc && {
        ( for check_file in \
            /etc/{bash.,}{bashrc,profile} \
            /etc/bash.bash{_logout,.logout} \
            /etc/bash.bashrc.d/vim/vimrc \
            /etc/bash.bashrc.d/skel.d/default/dot.{bashrc,inputrc,vimrc};
          do [ -e "${check_file}" ] && echo "Found - ${check_file}" || exit 1
          done; ) &&
        ( unset os vendor osvendor machine
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
    : "OK";

  # Basic role syntax check, and tests-run
  - |
    set -x;
    : "Run tests-all.sh" && {
      bash -x roles/bashrc/tests/tests-all.sh
    } &&
    : "OK";

} &&
echo "[${tests_name}] DONE."

# End
exit $?
