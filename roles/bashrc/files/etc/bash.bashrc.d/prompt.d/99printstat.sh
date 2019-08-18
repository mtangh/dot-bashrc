# ${bashrcdir}/prompt.d/99printstat.sh

_pc_printstat() {
  case "$TERM" in
  xterm*)
    printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"
    ;;
  screen)
    printf "\033]0;%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"
    ;;
  *)
    ;;
  esac
  return 0
}
