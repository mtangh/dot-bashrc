# ${bashrc_dir}/10prompt.sh
# $Id$

# Default PS*
PS1=$([ ${UID:--1} -ne 0 ] && echo '\u@' || :)'\h \W\$ '
PS2='> '
PS3='=> '
PS4='+${BASH_SOURCE:+(${BASH_SOURCE##*/}${LINENO:+:$LINENO}):} ${FUNCNAME:+$FUNCNAME(): }'

# PS* for TERM
case "${TERM:-}" in
xterm*)
  CLR=$([ ${UID:--1} -eq 0 ] && echo '1;31' || echo '1;34')
  CL1="${CLR}"
  CL2="${CLR}"
  CL3="${CLR}"
  CL4="1;30"
  PS1="\[\e[${CL1}m\]${PS1}\[\e[0;39m\]"
  PS2="\[\e[${CL2}m\]${PS2}\[\e[0;39m\]"
  PS3="\[\e[${CL3}m\]${PS3}\[\e[0;39m\]"
  PS4="\[\e[${CL4}m\]${PS4}\[\e[0;39m\]"
  unset CLR CL1 CL2 CL3 CL4
  ;;
*)
  ;;
esac

# *eof*
