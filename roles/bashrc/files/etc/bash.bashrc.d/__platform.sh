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
    os="${os// /}";
    echo "${os,,}"; )
    ;;
*-*)
  os="${OSTYPE%%-*}"
  os="${os,,}"
  ;;
*)
  os="${OSTYPE,,}"
  ;;
esac

# Vendor
[ -z "${MACHTYPE:-}" ] ||
if [[ "${MACHTYPE}" =~ ^([^-]+)-([^-]+)-([^-].*)$ ]]
then
  vendor="${BASH_REMATCH[2],,}"
  osvendor="${os}_${vendor}"
fi

# Machine Name
[ -z "${HOSTNAME:-}" ] ||
if [[ "${HOSTNAME}" =~ ^([^.]+)([.].+$|$) ]]
then
  machine="${BASH_REMATCH[1],,}"
else
  machine=$(/bin/hostname -s)
  machine="${machine,,}"
fi

} &>/dev/null || :

# End
return 0
