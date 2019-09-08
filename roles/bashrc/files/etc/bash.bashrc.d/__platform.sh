# ${bashrcdir}/__platform.sh
# $Id$

osvendor="__UNKNOWN__"
ostype="__UNKNOWN__"
machine="__UNKNOWN__"

# OS-Type and Vendor
if [[ "${MACHTYPE}" =~ ^([^-]+)-([^-]+)-([_A-Za-z]+).*$ ]]
then
  osvendor="${BASH_REMATCH[2],,}"
  ostype=$(
    if [ -x "/usr/bin/sw_vers" ]
    then os=$(/usr/bin/sw_vers -productName)
    else os="${BASH_REMATCH[3]}"
    fi 1>/dev/null 2>&1 || :
    os="${os// /}"; echo "${os,,}"; )
fi

# Machine Name
if [[ "${HOSTNAME}" =~ ^([^.]+)([.].+$|$) ]]
then machine="${BASH_REMATCH[1],, }"
else machine=$(/bin/hostname -s 2>/dev/null); machine="${machine,,}"
fi
machine="${machine,,}"

# End
return 0
