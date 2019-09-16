# ${bashrcdir}/20mbox.sh
# $Id$

[ -n "$USER" ] ||
  return 0

# Mail spool dir
mail_spool_dir=""

# Lookup Mail spool dir
for mail_spool_dir in /var/spool/mail /var/mail
do
  [ -d "${mail_spool_dir}" ] &&
  break || :
done

# Lookup Mbox config
for mbox_conf_file in \
"${HOME}/.mbox.conf" \
"${XDG_CONFIG_HOME:-$HOME/.config}/mbox.conf"
do
  [ -f "${mbox_conf_file}" ] && {
    . "${mbox_conf_file}" &&
    break
  } || :
done 2>/dev/null

# Disable the 'u' option.
set +u

# Env
[ -z "${MBOX}" ] && MBOX=".mbox"
[ -z "${MBOX}" ] || export MBOX
[ -z "${MAIL}" ] && MAIL="${mail_spool_dir}/${USER}"
[ -z "${MAIL}" ] || export MAIL

# Enable the 'u' option again.
set -u

# Cleanup
unset mail_spool_dir mbox_conf_file

# *eof*
