# ${bashrcdir}/10prompt.sh
# $Id$

# Default PS*
PS1=`[ $UID -gt 0 ] && echo '\u'@`'\h \W\$ '
PS2='> '
PS3='=> '
PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME:+$FUNCNAME(): }'

# PS* for TERM
case $TERM in
xterm*)
  CLR=`[ $UID -eq 0 ] && echo '1;31' || echo '1;34'`
  PS1="\[\e[${CLR}m\]${PS1}\[\e[0;39m\]"
  PS2="\[\e[${CLR}m\]${PS2}\[\e[0;39m\]"
  PS3="\[\e[${CLR}m\]${PS3}\[\e[0;39m\]"
  PS4="\[\e[${CLR}m\]${PS4}\[\e[0;39m\]"
  unset CLR
  ;;
*)
  ;;
esac

# *eof*
