# ${bashrcdir}/09env.sh
# $Id$

set +u

# EDITOR
[ -z "$EDITOR" ] && EDITOR="`type -p vi`"
[ -z "$EDITOR" ] && EDITOR="`type -p vim`"
[ -z "$EDITOR" ] && EDITOR="`type -p emacs`"
[ -z "$EDITOR" ] && EDITOR="`type -p pico`"
[ -z "$EDITOR" ] && EDITOR="`type -p nano`"
[ -z "$EDITOR" ] || export EDITOR

# PAGER
[ -z "$PAGER" ] && PAGER="`type -p lv`"
[ -z "$PAGER" ] && PAGER="`type -p jless`"
[ -z "$PAGER" ] && PAGER="`type -p less`"
[ -z "$PAGER" ] && PAGER="`type -p more`"
[ -z "$PAGER" ] || export PAGER

# RSYNC
[ -x "`type -p rsync`" ] &&
[ -x "`type -p ssh`" ] && {
  RSYNC_RSH="`type -p ssh`"
  export RSYNC_RSH
}

# CVS
[ -x "`type -p cvs`" ] &&
[ -x "`type -p ssh`" ] && {
  CVS_RSH="`type -p ssh`"
  export CVS_RSH
}

set -u

# *eof*
