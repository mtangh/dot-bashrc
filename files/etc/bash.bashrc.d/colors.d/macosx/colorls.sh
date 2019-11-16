# ${bashrc_dir}/colors.d/${os}/colorls.sh
# $Id$

##
## color-ls For macOS
##

# User config dir.
usrconfdir="${XDG_CONFIG_HOME:-${HOME}/.config}"

# color-ls
for lsclr_file in $( {
__pf_rc_loader \
"${usrconfdir}"/{etc/,}lscolors{/${TERM},.${TERM},} \
"${HOME}/.lscolors"{/${TERM},.${TERM},} \
{"${bash_local}","${bashrc_dir}"}/colors.d/${os:+$os/}LSCOLORS{.${TERM},}
} 2>/dev/null || :; )
do
  [ -f "${lsclr_file}" ] ||
    continue
  [ -x "${lsclr_file}" ] &&
  LSCOLORS=$(bash ${lsclr_file} 2>/dev/null)
  [ -x "${lsclr_file}" ] ||
  LSCOLORS=$(cat ${lsclr_file} 2>/dev/null)
  [ -n "${LSCOLORS:-}" ] && {
    export LSCOLORS
    break
  } || :
done

# Setup ls aliases
alias ls="ls -FGq"
alias le="ls -le"
alias l@="ls -l@"
alias lll="ls -lTO"
alias lsacl="ls -le"
alias lsattr="ls -l@"

# Cleanup
unset usrconfdir
unset lsclr_file

# *eof*
