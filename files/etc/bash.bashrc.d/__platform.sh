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
  local _sfx=("" "${os:--}" "${osvendor:--}" "${vendor:--}" "${machine:--}")
  local _grp=("" ${usergroups:--})
  local _arg=""
  local _rcf=""
  local _plt=""
  local _ugn=""
  local _cnt=0
  for _arg in "${@}"
  do
    [ -z "${_arg}" ] ||
    case "${_arg}" in
    -n) 
      _sfx=("" "${os:--}" "${osvendor:--}" "${vendor:--}" "${machine:--}")
      _grp=("" ${usergroups:--})
      ;;
    -r)
      _sfx=("${machine:--}" "${vendor:--}" "${osvendor:--}" "${os:--}" "")
      _grp=(${usergroups:--} "")
      ;;
    *)
      [ -n "${_arg}" -a -d "${_arg%/*}" ] &&
      for _rcf in $( {
        for _plt in "${_sfx[@]}"
        do
          for _ugn in "${_grp[@]}"
          do
            if [ -f "${_arg}${_plt:+.$_plt}${_ugn:+.$_ugn}" ]
            then echo "${_arg}${_plt:+.$_plt}${_ugn:+.$_ugn}"
            fi || :
            if [ -d "${_arg}.d/${_plt:--}/${_ugn:--}" ]
            then echo "${_arg}.d/${_plt}/${_ugn}"/*
            elif [ -d "${_arg}.d/${_plt:--}" ]
            then echo "${_arg}.d/${_plt}"/*"${_ugn:+.$_ugn}"
            elif [ -d "${_arg}.d" -a -n "${_plt:-}${_ugn:-}" ]
            then echo "${_arg}.d"/*${_plt:+.$_plt}${_ugn:+.$_ugn}
            fi || :
          done
        done
      } 2>/dev/null || :; )
      do
        [ -f "${_rcf}" ] && {
          echo "${_rcf}" && _cnt=$((++_cnt))
        } || :
      done
      ;;
    esac
  done || :
  [ ${_cnt} -gt 0 ]
  return $?
}

} &>/dev/null || :

# End
return 0
