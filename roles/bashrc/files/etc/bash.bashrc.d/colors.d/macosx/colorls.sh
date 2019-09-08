# ${bashrcdir}/colors.d/${ostype}/colorls.sh
# $Id$

##
## color-ls For Darwin
##

# color-ls
for lscolors_sh in \
${HOME}/.lscolors/${ostype}/${TERM}{.${machine},.${osvendor},} \
${HOME}/.lscolors/${TERM}{.${machine},.${osvendor},} \
${HOME}/.lscolors.${TERM}{.${machine},.${osvendor},} \
${HOME}/.lscolors \
${sys_colors_dir}/${ostype}/LSCOLORS.${TERM}{.${machine},.${osvendor},} \
${sys_colors_dir}/${ostype}/LSCOLORS{.${machine},.${osvendor},} 
do
  [ -f "${lscolors_sh}" ] ||
    continue
  [ -x "${lscolors_sh}" ] &&
    export LSCOLORS=`bash ${lscolors_sh} 2>/dev/null` ||
    export LSCOLORS=`cat ${lscolors_sh} 2>/dev/null`
  break
done

# setup ls aliases
alias ls="ls -FGq"
alias le="ls -le"
alias l@="ls -l@"
alias lll="ls -lTO"
alias lsacl="ls -le"
alias lsattr="ls -l@"

# cleanup
unset lscolors_sh

# *eof*
