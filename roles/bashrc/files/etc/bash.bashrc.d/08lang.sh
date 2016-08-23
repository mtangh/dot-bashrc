# ${bashrcdir}/08lang.sh
# $Id$

set +u

i18ndir="${bashrcdir}/i18n.d"

# $sysxkbmap means we're running under Xinit;
# we want to re-read settings in case we're running in CJKI and
# have been defaulted to English on the console.
for i18n in \
${HOME}/.i18n.d/${machine}{.${TERM},} \
${HOME}/.i18n.d/{${osvendor},${ostype}}{.${TERM},} \
${HOME}/.i18n.d/{${TERM},default} \
${HOME}/.i18n{.${TERM},} \
${i18ndir}/${machine}{.${TERM},} \
${i18ndir}/{${osvendor},${ostype}}{.${TERM},} \
${i18ndir}/default
do
  if [ -f "${i18n}" ]
  then
    . "${i18n}" 2>/dev/null &&
    break
  fi
done
unset i18n    

if [ -n "$GDM_LANG" ]
then
  LANG="$GDM_LANG"
  unset LANGUAGE
  if [ "$GDM_LANG" = "zh_CN.GB18030" ]
  then
    LANGUAGE="zh_CN.GB18030:zh_CN.GB2312:zh_CN"
    export LANGUAGE
  fi
fi

if [ -n "$LANG" ] &&
   [ "${TERM}" = "linux" ]
then
  case $LANG in
  *.utf8*|*.UTF-8*)
    case $LANG in 
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
fi

[ -n "$LANG" ]              && export LANG
[ -n "$LANG" ]              || unset LANG

[ -n "$LC_ADDRESS" ]        && export LC_ADDRESS
[ -n "$LC_ADDRESS" ]        || unset LC_ADDRESS
[ -n "$LC_CTYPE" ]          && export LC_CTYPE
[ -n "$LC_CTYPE" ]          || unset LC_CTYPE
[ -n "$LC_COLLATE" ]        && export LC_COLLATE
[ -n "$LC_COLLATE" ]        || unset LC_COLLATE
[ -n "$LC_IDENTIFICATION" ] && export LC_IDENTIFICATION
[ -n "$LC_IDENTIFICATION" ] || unset LC_IDENTIFICATION
[ -n "$LC_MEASUREMENT" ]    && export LC_MEASUREMENT
[ -n "$LC_MEASUREMENT" ]    || unset LC_MEASUREMENT
[ -n "$LC_MESSAGES" ]       && export LC_MESSAGES
[ -n "$LC_MESSAGES" ]       || unset LC_MESSAGES
[ -n "$LC_MONETARY" ]       && export LC_MONETARY
[ -n "$LC_MONETARY" ]       || unset LC_MONETARY
[ -n "$LC_NAME" ]           && export LC_NAME
[ -n "$LC_NAME" ]           || unset LC_NAME
[ -n "$LC_NUMERIC" ]        && export LC_NUMERIC
[ -n "$LC_NUMERIC" ]        || unset LC_NUMERIC
[ -n "$LC_PAPER" ]          && export LC_PAPER
[ -n "$LC_PAPER" ]          || unset LC_PAPER
[ -n "$LC_TELEPHONE" ]      && export LC_TELEPHONE 
[ -n "$LC_TELEPHONE" ]      || unset LC_TELEPHONE
[ -n "$LC_TIME" ]           && export LC_TIME
[ -n "$LC_TIME" ]           || unset LC_TIME

[ -n "$LANGUAGE" ]          && export LANGUAGE
[ -n "$LANGUAGE" ]          || unset LANGUAGE
[ -n "$LINGUAS" ]           && export LINGUAS
[ -n "$LINGUAS" ]           || unset LINGUAS

[ -n "$_XKB_CHARSET" ]      && export _XKB_CHARSET
[ -n "$_XKB_CHARSET" ]      || unset _XKB_CHARSET
    
if [ -n "$LC_ALL" ] &&
   [ "$LC_ALL" != "$LANG" ]
then
  export LC_ALL
else
  unset LC_ALL
fi

unset i18ndir

set -u

# *eof*
