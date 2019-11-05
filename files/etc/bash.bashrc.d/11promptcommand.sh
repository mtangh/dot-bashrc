# ${bashrc_dir}/11promptxommand.sh
# $Id$

# Initialize PROMPT_COMMAND
PROMPT_COMMAND=""

# Lookup PROMPT_COMMAND
for prompts_sh in $( {
__pf_rc_loader \
{"${bashrc_dir}","${bash_local}"}/prompt.d/{$TERM/,}[0-9][0-9]*.sh \
"${XDG_CONFIG_HOME:-${HOME}/.config}/"bash_prompt.d/{$TERM/,}[0-9][0-9]*.sh \
"${HOME}/."bash_prompt.d/{$TERM/,}[0-9][0-9]*.sh
} 2>/dev/null || :; )
do
  [ -f "$prompts_sh" ] &&
  [ -x "$prompts_sh" ] &&
  . "$prompts_sh" &&
  [ -n "$PROMPT_COMMAND" ] &&
  break || :
done
unset prompts_sh

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
