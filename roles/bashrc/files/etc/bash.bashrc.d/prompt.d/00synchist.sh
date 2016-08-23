# ${bashrcdir}/prompt.d/00synchist.sh

_pc_synchist() {
  history -a
  history -c
  history -r
  return 0
}
