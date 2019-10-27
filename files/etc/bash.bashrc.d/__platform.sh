# ${bashrc_dir}/__platform.sh
# $Id$

# Default
os="__UNKNOWN__"
vendor="__UNKNOWN__"
osvendor="__UNKNOWN__"
machine="__UNKNOWN__"

# Platform
: "platform" && {

# OS-Type
[ -z "${OSTYPE:-}" ] ||
case "${OSTYPE}" in
darwin*)
  os=$(
    if [ -x "/usr/bin/sw_vers" ]
    then os=$(/usr/bin/sw_vers -productName)
    else os="darwin"
    fi || :
    echo "${os// /}"|tr '[:upper:]' '[:lower:]'; )
    ;;
*-*)
  os=$(echo "${OSTYPE%%-*}"|tr '[:upper:]' '[:lower:]')
  ;;
*)
  os=$(echo "${OSTYPE}"|tr '[:upper:]' '[:lower:]')
  ;;
esac

# Vendor
[ -z "${MACHTYPE:-}" ] ||
if [[ "${MACHTYPE}" =~ ^([^-]+)-([^-]+)-([^-].*)$ ]]
then
  vendor=$(echo "${BASH_REMATCH[2]}"|tr '[:upper:]' '[:lower:]')
  osvendor="${os}_${vendor}"
fi

# Machine Name
[ -z "${HOSTNAME:-}" ] ||
if [[ "${HOSTNAME}" =~ ^([^.]+)([.].+$|$) ]]
then
  machine=$(echo "${BASH_REMATCH[1]}"|tr '[:upper:]' '[:lower:]')
else
  machine=$(/bin/hostname -s|tr '[:upper:]' '[:lower:]')
fi

} &>/dev/null || :

# End
return 0
