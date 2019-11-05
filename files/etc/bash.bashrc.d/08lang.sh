# ${bashrc_dir}/08lang.sh
# $Id$

# $sysxkbmap means we're running under Xinit;
# we want to re-read settings in case we're running in CJKI and
# have been defaulted to English on the console.

for i18nfile in $( {
__pf_rc_loader -r \
{"${XDG_CONFIG_HOME:-${HOME}/.config}/","${HOME}/."}i18n \
{"${bash_local}","${bashrc_dir}"}/i18n
} 2>/dev/null || :; )
do
  [ -f "${i18nfile}" ] && {
    . "${i18nfile}" && break
  } || :
done

if [ -z "${LANG:-}" ] &&
   [ -r "${bashrc_dir}/i18n.d/default" ]
then
  . "${bashrc_dir}/i18n.d/default"
fi || :

# GDM Lang
if [ -n "${GDM_LANG:-}" ]
then
  LANG="${GDM_LANG}"
  unset LANGUAGE
  if [ "${GDM_LANG}" = "zh_CN.GB18030" ]
  then
    LANGUAGE="zh_CN.GB18030:zh_CN.GB2312:zh_CN"
    export LANGUAGE
  fi
fi

# Term "linux"
case "${TERM:-}::${LANG:-}" in
linux::*.utf8*|linux::*.utf-8*|linux::*.UTF8*|linux::*.UTF-8*)
  case "${LANG:-}" in
  ja*|ko*|si*|zh*)
    LANG=en_US.UTF-8
    ;;
  en_IN*)
    ;;
  *_IN*)
    LANG=en_US.UTF-8
    ;;
  esac
  ;;
*)
  ;;
esac

# LANG
[ -n "${LANG:-}" ] && export LANG
[ -n "${LANG:-}" ] || unset LANG

# LC_*
[ -n "${LC_ADDRESS:-}" ]        && export LC_ADDRESS
[ -n "${LC_ADDRESS:-}" ]        || unset  LC_ADDRESS
[ -n "${LC_CTYPE:-}" ]          && export LC_CTYPE
[ -n "${LC_CTYPE:-}" ]          || unset  LC_CTYPE
[ -n "${LC_COLLATE:-}" ]        && export LC_COLLATE
[ -n "${LC_COLLATE:-}" ]        || unset  LC_COLLATE
[ -n "${LC_IDENTIFICATION:-}" ] && export LC_IDENTIFICATION
[ -n "${LC_IDENTIFICATION:-}" ] || unset  LC_IDENTIFICATION
[ -n "${LC_MEASUREMENT:-}" ]    && export LC_MEASUREMENT
[ -n "${LC_MEASUREMENT:-}" ]    || unset  LC_MEASUREMENT
[ -n "${LC_MESSAGES:-}" ]       && export LC_MESSAGES
[ -n "${LC_MESSAGES:-}" ]       || unset  LC_MESSAGES
[ -n "${LC_MONETARY:-}" ]       && export LC_MONETARY
[ -n "${LC_MONETARY:-}" ]       || unset  LC_MONETARY
[ -n "${LC_NAME:-}" ]           && export LC_NAME
[ -n "${LC_NAME:-}" ]           || unset  LC_NAME
[ -n "${LC_NUMERIC:-}" ]        && export LC_NUMERIC
[ -n "${LC_NUMERIC:-}" ]        || unset  LC_NUMERIC
[ -n "${LC_PAPER:-}" ]          && export LC_PAPER
[ -n "${LC_PAPER:-}" ]          || unset  LC_PAPER
[ -n "${LC_TELEPHONE:-}" ]      && export LC_TELEPHONE
[ -n "${LC_TELEPHONE:-}" ]      || unset  LC_TELEPHONE
[ -n "${LC_TIME:-}" ]           && export LC_TIME
[ -n "${LC_TIME:-}" ]           || unset  LC_TIME

# Language and Linguas
[ -n "${LANGUAGE:-}" ] && export LANGUAGE
[ -n "${LANGUAGE:-}" ] || unset  LANGUAGE
[ -n "${LINGUAS:-}" ]  && export LINGUAS
[ -n "${LINGUAS:-}" ]  || unset  LINGUAS

# XKB Charset
[ -n "${_XKB_CHARSET:-}" ] && export _XKB_CHARSET
[ -n "${_XKB_CHARSET:-}" ] || unset  _XKB_CHARSET

# LC_ALL
if [ -n "${LC_ALL:-}" -a "${LC_ALL:-}" != "${LANG:-}" ]
then export LC_ALL
else unset  LC_ALL
fi

# Cleanup
unset i18npath i18nfile

# *eof*
