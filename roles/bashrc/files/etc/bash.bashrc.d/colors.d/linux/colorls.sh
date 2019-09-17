# ${bashrcdir}/colors.d/${os}/colorls.sh
# $Id$

##
## color-ls For Linux
##

dir_colors=""

# ls options
ls_options="-Fq"
[ ${UID} -eq 0 ] &&
ls_options="-A ${ls_options}" || :

# color-ls
for lsclr_path in \
"${XDG_CONFIG_HOME:-${HOME}/.config}"/{etc/,}dir{_,}colors \
"${HOME}"/.dir{_,}colors \
"${bashrcsir}/colors.d/${os}/DIR_COLORS"
do
  for lsclr_file in \
  "${lsclr_path}"{/${TERM},.${TERM},}{.${machine},.${osvendor},.${os},}
  do
    [ -f "${lsclr_file}" ] && {
      dir_colors="${lsclr_file}"
      break 2
    } || :
  done
  [ -z "${dir_colors}" ] || {
    break
  }
done

# default dircolors
alias ls="ls ${ls_options}"

# setup dircolors
if [ -f "${dir_colors}" ] &&
   ! egrep -qi "^COLOR.*none" "${dir_colors}" &>/dev/null
then
  eval $(dircolors --sh "${dir_colors}" 2>/dev/null)
  if [ -n "$LS_COLORS" ]
  then
    alias ls="ls ${ls_options} --color=tty"
  fi
fi

# ls aliases
alias lll="ls -l --author --full-time --time-style='+%Y-%m-%d %H:%M:%S'"

# cleanup
unset dir_colors ls_options
unset lsclr_path lsclr_file

# *eof*
