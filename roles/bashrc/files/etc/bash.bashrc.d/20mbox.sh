# ${bashrcdir}/20mbox.sh
# $Id$

[ -n "$USER" ] ||
  return 0

usr_mbox_conf_file="${HOME}/.mbox.conf"
xdg_mbox_conf_file="${XDG_CONFIG_HOME:-$HOME/.config}/mbox.conf"

mail_spool_dir=""

# Mail spool dir
for mail_spool_dir in /var/spool/mail /var/mail
do
  [ -d "${mail_spool_dir}" ] &&
  break || :
done

# Mail box config
for mbox_conf_file in \
"${xdg_mbox_conf_file}" \
"${usr_mbox_conf_file}"
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
unset mbox_conf_file mail_spool_dir
unset usr_mbox_conf_file xdg_mbox_conf_file

# *eof*
