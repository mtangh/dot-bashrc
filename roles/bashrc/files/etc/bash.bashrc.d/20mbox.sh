# ${bashrcdir}/20mbox.sh
# $Id$

[ -n "$USER" ] ||
  return 0

mbox_conf_file="${HOME}/.mailbox"
mail_spool_dir="/var/spool/mail"

for mail_spool_dir in \
/var/spool/mail \
/var/mail
do
  [ -d "${mail_spool_dir}" ] &&
    break
done

if [ -f "${mbox_conf_file}" ]
then
  . "${mbox_conf_file}" 2>/dev/null
fi

set +u

[ -z "${MBOX}" ] && MBOX=.mbox
[ -z "${MBOX}" ] || export MBOX
[ -z "${MAIL}" ] && MAIL="${mail_spool_dir}/${USER}"
[ -z "${MAIL}" ] || export MAIL

set -u

unset mbox_conf_file
unset mail_spool_dir

# *eof*
