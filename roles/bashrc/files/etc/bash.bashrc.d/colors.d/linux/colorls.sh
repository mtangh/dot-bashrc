# ${bashrcdir}/colors.d/${ostype}/colorls.sh
# $Id$

##
## color-ls For Linux
##

ls_user_opt="-Fq"

if [ "`id -u`" = "0" ]
then
  ls_root_opt="-A"
else
  ls_root_opt=""
fi

# color-ls
for dircolors in \
${HOME}/.dir{_colors,colors}/${TERM}{.${machine},.${osvendor},} \
${HOME}/.dir{_colors,colors}.${TERM}{.${machine},.${osvendor},} \
${HOME}/.dir{_colors,colors} \
${sys_colors_dir}/${ostype}/DIR_COLORS.${TERM}{.${machine},.${osvendor},} \
${sys_colors_dir}/${ostype}/DIR_COLORS
do
  [ -f "${dircolors}" ] ||
    continue
  COLORS="${dircolors}"
  break
done

# default dircolors
alias ls="ls ${ls_root_opt} ${ls_user_opt}"

# setup dircolors
if ! egrep -qi "^COLOR.*none" ${COLORS} &>/dev/null
then
  eval `dircolors --sh "${COLORS}" 2>/dev/null`
  if [ -n "$LS_COLORS" ]
  then
    alias ls="ls ${ls_root_opt} ${ls_user_opt} --color=tty"
  fi
fi

# ls aliases
alias lll="ls -l --author --full-time --time-style='+%Y-%m-%d %H:%M:%S'"

# cleanup
unset dircolors
unset ls_root_opt
unset ls_user_opt

# *eof*
