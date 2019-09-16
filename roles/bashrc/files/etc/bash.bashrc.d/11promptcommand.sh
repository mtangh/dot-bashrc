# ${bashrcdir}/11promptxommand.sh
# $Id$

# Not an error undefined variable
set +u

# Initialize PROMPT_COMMAND
PROMPT_COMMAND=""

# Lookup PROMPT_COMMAND
for promptsdir in \
"${bashrcdir}/prompt.d/" \
"/usr/local/etc/${bashrcdir##*/}/prompt.d/" \
"${XDG_CONFIG_HOME:-${HOME}/.config}/bash_prompt.d" \
"${HOME}/.bash_prompt.d"
do
  if [ -d "${promptsdir}" ]
  then
    for prompts_sh in "${promptsdir}"/{$TERM/,}[0-9][0-9]*.sh
    do
      [ -x "$prompts_sh" ] &&
      . "$prompts_sh" &&
      [ -n "$PROMPT_COMMAND" ] &&
      break 2 || :
    done
    unset prompts_sh
  fi
  [ -n "$PROMPT_COMMAND" ] &&
  break || :
done 1>/dev/null 2>&1
unset promptsdir

# PROMPT_COMMAND
if [ -z "$PROMPT_COMMAND" ]
then
  for prompt_cmd in $(
  declare -F|grep ' _pc_'|cut -d' ' -f3)
  do
    PROMPT_COMMAND="${PROMPT_COMMAND}${PROMPT_COMMAND:+;}"
    PROMPT_COMMAND="${PROMPT_COMMAND}${prompt_cmd}"
  done
  unset prompt_cmd
fi 2>/dev/null

# To an undefined variable in error
set -u

# *eof*
