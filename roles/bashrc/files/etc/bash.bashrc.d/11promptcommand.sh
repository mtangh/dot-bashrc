# ${bashrcdir}/11promptxommand.sh
# $Id$

# Not an error undefined variable
set +u

# Initialize PROMPT_COMMAND
PROMPT_COMMAND=""

# PROMPT_COMMAND
for prompt_command_sh in \
${bashrcdir}/prompt.d/{$TERM/,}[0-9][0-9]*.sh \
$HOME/.bash_prompt.d/{$TERM/,}*.sh ;
do
  if [ -x "$prompt_command_sh" ]
  then
    . "$prompt_command_sh" 1>/dev/null 2>&1
  fi
  if [ -n "$PROMPT_COMMAND" ]
  then
    break
  fi
done 2>/dev/null

if [ -z "$PROMPT_COMMAND" ]
then
  for prompt_command in $(declare -F|grep ' _pc_'|cut -d' ' -f3 2>/dev/null)
  do
    if [ -z "${PROMPT_COMMAND}" ]
    then
      PROMPT_COMMAND="${prompt_command}"
    else
      PROMPT_COMMAND="${PROMPT_COMMAND};${prompt_command}"
    fi
  done
fi

if [ -z "$PROMPT_COMMAND" ]
then
  case $TERM in
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

# unset
unset prompt_command_sh prompt_command

# To an undefined variable in error
set -u

# *eof*
