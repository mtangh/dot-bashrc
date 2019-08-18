# ${bashrcdir}/12completion.sh
# $Id$

# completion dierctory
sys_completions_dir="${bashrcdir}/completion.d"
usr_completions_dir="${HOME}/.bash_completion.d"

# lookup completion settings
for completion_sh in $(
/bin/ls -1 \
"${sys_completions_dir}"/*.sh{,.${ostype},.${machine}} \
"${sys_completions_dir}/${ostype}"/*.sh{,.${machine}} \
"${usr_completions_dir}"/*.sh.${ostype},.${machine} \
"${usr_completions_dir}/${ostype}"/*.sh{,.${machine}} \
2>/dev/null; )
do
  [ -x "${completion_sh}" ] &&
    . "${completion_sh}" 2>/dev/null
done

# Cleanup
unset sys_completions_dir
unset usr_completions_dir

# *eof*
