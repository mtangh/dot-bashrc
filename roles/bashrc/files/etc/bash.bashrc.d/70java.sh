# ${bashrcdir}/70java.sh
# $Id$

[ -z "$JAVA_HOME" ] && {

  [ -x "/usr/libexec/java_home" ] &&
  JAVA_HOME="$(/usr/libexec/java_home)"

} 2>/dev/null || :

[ -z "$JAVA_HOME" ] && {

  java_cmd=$(type -p java)
  
  [ -n "${java_cmd}" -a -n "$(type -P readlink)" ] && {
    java_cmd=$(readlink -f "${java_cmd}")
  } 2>/dev/null

  for java_home_path in \
  /{usr,usr/local,opt}/java/{default,latest} \
  "${java_cmd%/bin/java}"
  do
    for java_jdk_cmd in \
    java javac javah javap jar keytool
    do
      [ -x "${java_home_path}/bin/${java_jdk_cmd}" ] || {
        break 2
      }
    done &&
    unset java_jdk_cmd
    JAVA_HOME="${java_home_path}"
    break
  done

  unset java_home_path
  unset java_cmd

} || :

[ -n "$JAVA_HOME" ] && {
  export JAVA_HOME 
} || :

# *eof*
