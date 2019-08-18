# ${bashrcdir}/11promptxommand.sh
# $Id$

# Not an error undefined variable
set +u

# Initialize PROMPT_COMMAND
PROMPT_COMMAND=""

# Prompt dir
usr_prompt_dir="${HOME}/.bash_prompt.d"
xdg_prompt_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/bash_prompt.d"

# PROMPT_COMMAND
for prompt_command_sh in $(
/bin/ls -1 \
"${bashrcdir}/prompt.d"/{$TERM/,}[0-9][0-9]*.sh \
{${usr_prompt_dir},${xdg_prompt_dir}}/{$TERM/,}*.sh \
2>/dev/null; )
do
  [ -x "$prompt_command_sh" ] && {
    . "$prompt_command_sh"; }
  [ -n "$PROMPT_COMMAND" ] && {
    break; }
done 1>/dev/null 2>&1

if [ -z "$PROMPT_COMMAND" ]
then
  for prompt_command in $(declare -F|grep ' _pc_'|cut -d' ' -f3 2>/dev/null)
  do
    if [ -z "${PROMPT_COMMAND}" ]
    then PROMPT_COMMAND="${prompt_command}"
    else PROMPT_COMMAND="${PROMPT_COMMAND};${prompt_command}"
    fi
  done
fi

if [ -z "$PROMPT_COMMAND" ]
then
  case "$TERM" in
  xterm*)
    PROMPT_COMMAND='printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
    ;;
  screen)
    PROMPT_COMMAND='printf "\033]0;%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
    ;;
  *)
    ;;
  esac
fi

# Cleanup
unset prompt_command_sh prompt_command
unset usr_prompt_dir xdg_prompt_dir

# To an undefined variable in error
set -u

# *eof*
