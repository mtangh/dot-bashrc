# ${bashrc_dir}/09env.sh
# $Id$

# EDITOR
[ -z "${EDITOR:-}" ] && EDITOR="$(type -p vi)"
[ -z "${EDITOR:-}" ] && EDITOR="$(type -p vim)"
[ -z "${EDITOR:-}" ] && EDITOR="$(type -p emacs)"
[ -z "${EDITOR:-}" ] && EDITOR="$(type -p pico)"
[ -z "${EDITOR:-}" ] && EDITOR="$(type -p nano)"
[ -z "${EDITOR:-}" ] || export EDITOR
[ -z "${EDITOR:-}" ] && unset  EDITOR || :

# PAGER
[ -z "${PAGER:-}" ] && PAGER="$(type -p lv)"
[ -z "${PAGER:-}" ] && PAGER="$(type -p jless)"
[ -z "${PAGER:-}" ] && PAGER="$(type -p less)"
[ -z "${PAGER:-}" ] && PAGER="$(type -p more)"
[ -z "${PAGER:-}" ] || export PAGER
[ -z "${PAGER:-}" ] && unset  PAGER || :

# RSYNC
[ -x "$(type -P rsync)" -a -x "$(type -P ssh)" ] && {
  RSYNC_RSH="$(type -P ssh)"
  export RSYNC_RSH
} || :

# CVS
[ -x "$(type -P cvs)" -a -x "$(type -P ssh)" ] && {
  CVS_RSH="$(type -P ssh)"
  export CVS_RSH
} || :

# *eof*
