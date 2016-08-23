# ${bashrcdir}/12completion.sh
# $Id$

# completion dierctory
sys_completions_dir="${bashrcdir}/completion.d"
usr_completions_dir="${HOME}/.bash_completion.d"

# lookup completion settings
for completion_sh in \
`ls -1 ${sys_completions_dir}/*.sh{,.${ostype},.${machine}} 2>/dev/null` \
`ls -1 ${sys_completions_dir}/${ostype}/*.sh{,.${machine}} 2>/dev/null` \
`ls -1 ${usr_completions_dir}/*.sh.${ostype},.${machine} 2>/dev/null` \
`ls -1 ${usr_completions_dir}/${ostype}/*.sh{,.${machine}} 2>/dev/null`
do
  [ -x "${completion_sh}" ] &&
    . "${completion_sh}" 2>/dev/null
done

# clean up
unset sys_completions_dir
unset usr_completions_dir

# *eof*
