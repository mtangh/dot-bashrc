# ${bashrc_dir}/colors.d/${os}/colorls.sh
# $Id$

##
## color-ls For Linux
##

dir_colors=""

# User config dir.
usrconfdir="${XDG_CONFIG_HOME:-${HOME}/.config}"

# ls options
ls_options="-Fq"
[ ${UID} -eq 0 ] &&
ls_options="-A ${ls_options}" || :

# color-ls
for lsclr_file in $( {
__pf_rc_loader \
"${usrconfdir}"/{etc/,}dir{_,}colors{/${TERM},.${TERM},} \
"${HOME}"/.dir{_,}colors{/${TERM},.${TERM},} \
"${bash_local}"/colors.d/${vendor:+$vendor/}DIR_COLORS{.${TERM},} \
"${bashrc_dir}"/colors.d/${os:+$os/}DIR_COLORS{.${TERM},}
} 2>/dev/null || :; )
do
  [ -f "${lsclr_file}" ] && {
    dir_colors="${lsclr_file}"
    break
  } || :
done

# default dircolors
alias ls="ls ${ls_options}"

# setup dircolors
[ ! -f "${dir_colors}" -o ! -r "${dir_colors}" ] ||
egrep -qi "^COLOR.*none" "${dir_colors}" &>/dev/null || {

  eval $(dircolors --sh "${dir_colors}" 2>/dev/null)
  if [ -n "${LS_COLORS:-}" ]
  then
    alias ls="ls ${ls_options} --color=tty"
  fi

} || :

# ls aliases
alias lll="ls -l --author --full-time --time-style='+%Y-%m-%d %H:%M:%S'"

# cleanup
unset dir_colors ls_options
unset lsclr_file

# *eof*
