# ${bashrc_dir}/85less.sh
# $Id$

# lv installed ?
[ -x "$(type -p lv)" ] ||
  return 0

# LV Environment Variables
LV="-lac -Ou8"
export LV

# *eof*
