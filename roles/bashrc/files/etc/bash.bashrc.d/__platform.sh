# ${bashrcdir}/__platform.sh
# $Id$

os="__UNKNOWN__"
vendor="__UNKNOWN__"
machine="__UNKNOWN__"

: "platform" && {

# OS-Type
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
if [[ "${MACHTYPE}" =~ ^([^-]+)-([^-]+)-([^-].*)$ ]]
then
  vendor="${BASH_REMATCH[2],,}"
  osvendor="${os}_${vendor}"
fi

# Machine Name
if [[ "${HOSTNAME}" =~ ^([^.]+)([.].+$|$) ]]
then
  machine="${BASH_REMATCH[1],,}"
else 
  machine=$(/bin/hostname -s)
  machine="${machine,,}"
fi

} 1>/dev/null 2>&1 || :

# End
return 0
