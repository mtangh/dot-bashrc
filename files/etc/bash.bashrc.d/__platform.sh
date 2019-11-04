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

## RC Loader
__pf_rc_loader() {
  local suffixes=("" "${os:--}" "${osvendor:--}" "${vendor:--}" "${machine:--}")
  local _in_file=""
  local _rc_file=""
  local _rc_suff=""
  local _rc_load=""
  for _in_file in "${@}"
  do
    case "${_in_file}" in
    -n) suffixes=("" "${os:--}" "${osvendor:--}" "${vendor:--}" "${machine:--}") ;;
    -r) suffixes=("${machine:--}" "${vendor:--}" "${osvendor:--}" "${os:--}" "") ;;
    *)
      for _rc_suff in "${suffixes[@]}"
      do
        if [ -d "${_in_file}${_rc_suff:+/${_rc_suff}}" ]
        then
          for _rc_file in "${_in_file}${_rc_suff:+/${_rc_suff}}"/*
          do
            [ -f "${_rc_file}" ] && echo "${_rc_file}" || :
          done
        elif [ -r "${_in_file}${_rc_suff:+.${_rc_suff}}" ]
        then
          echo "${_in_file}${_rc_suff:+.${_rc_suff}}" &&
          _rc_load="yes"
        elif [ -r "${_in_file}${_rc_suff:+_${_rc_suff}}" ]
        then
          echo "${_in_file}${_rc_suff:+_${_rc_suff}}" &&
          _rc_load="yes"
        fi || :
      done
      ;;
    esac
  done || :
  [ -n "${_rc_load}" ]
  return $?
}

} &>/dev/null || :

# End
return 0
