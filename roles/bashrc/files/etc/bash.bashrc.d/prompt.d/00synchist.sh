# ${bashrcdir}/prompt.d/00synchist.sh

_pc_synchist() {
  [ -s "${HISTFILE:-$HOME/.bash_history}" ] && 
  [ $HISTFILESIZE -gt 0 ] && {
    history -a
    history -c
    history -r
  }
  return 0
}
