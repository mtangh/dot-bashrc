#!/bin/bash
THIS="${BASH_SOURCE##*/}"
CDIR=$([ -n "${BASH_SOURCE%/*}" ] && cd "${BASH_SOURCE%/*}" &>/dev/null; pwd)

# Run tests
echo "[${tests_name}] install.sh for user" && {

  run_inst=0
  ng_count=0

  bash -n install.sh &&
  for n in 1 2
  do
    run_inst=$n
    echo "${THIS}.${n}"
    bash -x install.sh --install --source=$(pwd) && {
      ( for check_file in \
          ${HOME}/.config/bash.{bashrc,profile,bash_logout} \
          ${HOME}/.config/bash.bashrc.d/vim/vimrc \
          ${HOME}/.config/bash.bashrc.d/skel.d/default/dot.{bashrc,inputrc,vimrc} \
          ${HOME}/.bashrc ;
        do [ -e "${check_file}" ] && echo "Found - ${check_file}" || exit 1
        done; ) &&
      ( [ -z "${PS1:-}" ] && PS1='\$ ' || :
        unset os vendor osvendor machine LS_COLORS LSCOLORS
        . "${HOME}/.config/bash.bashrc" &&
        echo "Load ${HOME}/.config/bash.bashrc" && {
          [ -n "$os"       ] && echo "Found - os=$os"             &&
          [ -n "$vendor"   ] && echo "Found - vendor=$vendor"     &&
          [ -n "$osvendor" ] && echo "Found - osvendor=$osvendor" &&
          [ -n "$machine"  ] && echo "Found - machine=$machine"   &&
          [ -n "$LS_COLORS" -o -n "$LSCOLORS" ] &&
          echo "Found - LS_COLORS or LSCOLORS" &&
          :;
        }; )
    } ||
    ng_count=$((++ng_count))
  done &&
  [ $run_inst -gt 0 ] &&
  [ $ng_count -eq 0 ]

} &&
echo "[${tests_name}] DONE."

# End
exit $?
