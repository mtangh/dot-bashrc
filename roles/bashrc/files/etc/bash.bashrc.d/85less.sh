# ${bashrcdir}/85less.sh
# $Id$

[ -x "`type -p less`" ] ||
  return 0

# Charset for LESS
LESSCHARSET=utf-8
export LESSCHARSET

# less initialization script (sh)
if [ -x "`type -p lesspipe.sh`" ]
then
  LESSOPEN="|`type -p lesspipe.sh` %s"
  export LESSOPEN
fi

# *eof*
