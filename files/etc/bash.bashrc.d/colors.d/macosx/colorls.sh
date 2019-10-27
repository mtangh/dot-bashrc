# ${bashrc_dir}/colors.d/${os}/colorls.sh
# $Id$

##
## color-ls For macOS
##

# color-ls
for lsclr_path in \
"${XDG_CONFIG_HOME:-${HOME}/.config}"/{etc/,}lscolors \
"${HOME}/.lscolors" \
{"${bash_local}","${bashrc_dir}"}/colors.d/${os}/LSCOLORS
do
  for lsclr_file in \
  "${lsclr_path}"{/${TERM},.${TERM},}{.${machine},.${vendor},}
  do
    [ -f "${lsclr_file}" ] || {
      continue
    }
    [ -x "${lsclr_file}" ] &&
    LSCOLORS=$(bash ${lsclr_file} 2>/dev/null) ||
    LSCOLORS=$(cat ${lsclr_file} 2>/dev/null)
    [ -n "${LSCOLORS:-}" ] && {
      export LSCOLORS
      break 2
    } || :
  done
  [ -z "${LSCOLORS:-}" ] || {
    break
  }
done

# Setup ls aliases
alias ls="ls -FGq"
alias le="ls -le"
alias l@="ls -l@"
alias lll="ls -lTO"
alias lsacl="ls -le"
alias lsattr="ls -l@"

# Cleanup
unset lsclr_path lsclr_file

# *eof*
