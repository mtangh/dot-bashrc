# ${bashrcdir}/70java.sh
# $Id$

[ -z "$JAVA_HOME" ] && {

  [ -x "/usr/libexec/java_home" ] &&
    JAVA_HOME="$(/usr/libexec/java_home 2>/dev/null)"

}

[ -z "$JAVA_HOME" ] && {

  java_cmd=`type -p java`

  for java_home_path in \
  /usr/java/{default,latest} \
  "${java_cmd%/bin/java}"
  do
    [ -x "${java_home_path}/bin/java" ] ||
      continue
    [ -x "${java_home_path}/bin/javac" ] ||
      continue
    [ -x "${java_home_path}/bin/javah" ] ||
      continue
    [ -x "${java_home_path}/bin/javap" ] ||
      continue
    [ -x "${java_home_path}/bin/jar" ] ||
      continue
    [ -x "${java_home_path}/bin/keytool" ] ||
      continue
    JAVA_HOME="${java_home_path}"
    break
  done

  unset java_home_path
  unset java_cmd

}

[ -n "$JAVA_HOME" ] &&
  export JAVA_HOME

# *eof*
