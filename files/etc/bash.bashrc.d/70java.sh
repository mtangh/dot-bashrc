# ${bashrc_dir}/70java.sh
# $Id$

[ -z "${JAVA_HOME:-}" ] && {

  [ -x "/usr/libexec/java_home" ] &&
  JAVA_HOME="$(/usr/libexec/java_home)"

} 2>/dev/null || :

[ -z "${JAVA_HOME:-}" ] && {

  java_cmd=$(type -p java)

  [ -n "${java_cmd}" -a -n "$(type -P readlink)" ] && {
    jcmdreal=$(readlink "${java_cmd}")
    java_cmd="${jcmdreal:-${java_cmd}}"
    unset jcmdreal
  } 2>/dev/null

  for jhomedir in \
  /{usr/local,opt,usr}/java/{default,latest} "${java_cmd%/bin/java}"
  do
    for jsdk_cmd in java javac javah javap jar keytool
    do
      [ -x "${jhomedir}/bin/${jsdk_cmd}" ] || {
        break 2
      }
    done && {
      JAVA_HOME="${jhomedir}"
      break
    }
  done

  unset jhomedir jsdk_cmd

} || :

[ -n "${JAVA_HOME:-}" ] && {
  export JAVA_HOME
} || :

# *eof*
