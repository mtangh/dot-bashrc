# ${bashrc_dir}/11promptxommand.sh
# $Id$

# Initialize PROMPT_COMMAND
PROMPT_COMMAND=""

# Lookup PROMPT_COMMAND
for promptsdir in \
{"${bashrc_dir}","${bash_local}"}/prompt.d \
{"${XDG_CONFIG_HOME:-${HOME}/.config}/","${HOME}/."}bash_prompt.d
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
  [ -n "$PROMPT_COMMAND" ] && {
    break
  } || :
done &>/dev/null || :
unset promptsdir

# PROMPT_COMMAND
if [ -z "$PROMPT_COMMAND" ]
then
  for prompt_cmd in $(
    declare -F |
    grep 'declare -f _pc_' |
    while read _fnc
    do echo "${_fnc##* -f }"
    done; )
  do
    PROMPT_COMMAND="${PROMPT_COMMAND}${PROMPT_COMMAND:+;}"
    PROMPT_COMMAND="${PROMPT_COMMAND}${prompt_cmd}"
  done
  unset prompt_cmd
fi &>/dev/null || :

# *eof*
