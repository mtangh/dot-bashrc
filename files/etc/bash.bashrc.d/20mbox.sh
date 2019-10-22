# ${bashrc_dir}/20mbox.sh
# $Id$

[ -n "${USER:-}" ] ||
  return 0

# Mail spool dir
mailspooldir=""

# Lookup Mail spool dir
for mailspooldir in /var/spool/mail /var/mail
do
  [ -d "${mailspooldir}" ] && {
    break
  } || :
done 2>/dev/null || :

# Lookup Mbox config
for mboxconffile in \
"${XDG_CONFIG_HOME:-$HOME/.config}"/{etc/,}mbox.conf \
"${HOME}"/.mbox.conf
do
  [ -f "${mboxconffile}" ] && {
    . "${mboxconffile}" &&
    break
  } || :
done 2>/dev/null || :

# Env
[ -z "${MBOX:-}" ] && MBOX=".mbox"
[ -z "${MBOX:-}" ] || export MBOX
[ -z "${MAIL:-}" ] && MAIL="${mailspooldir}/${USER}"
[ -z "${MAIL:-}" ] || export MAIL

# Cleanup
unset mailspooldir mboxconffile

# *eof*
